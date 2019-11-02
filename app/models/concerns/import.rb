require 'active_support/concern'

# ブックマークのインポート処理
module Import
  extend ActiveSupport::Concern

  # Scope や Callback 処理を実装する
  included do
    # scope :without_deleted, lambda{ where(deleted_at: nil) }
  end

  # インクルード先にメソッド（クラスメソッド）追加
  class_methods do
    # インスタンスメソッド
    def save_bookmark(params, account, folder_id, sort_num = 0)
      params.merge!({ account_id: account.id, folder_id: folder_id })
      bookmark = account.bookmarks.build(params)
      bookmark.sort_num = sort_num
      bookmark.save!
      CaptureJob.perform_later(bookmark.id)
      bookmark
    end

    def save_folder(params, account, folder_id, sort_num = 0)
      params.merge!({ account_id: account.id, folder_id: folder_id })
      folder = account.folders.build(params)
      folder.account_id = account.id
      folder.sort_num = sort_num
      folder.save!
      folder
    end

    def save_import_data(obj, level, account, folder_id = nil, sort_num)
      folder_id = level == 1 ? account.bookmarkbar_folder_id : folder_id

      if obj.xpath('./a').present?
        params = {
          name: obj.xpath('./a').text,
          url: obj.xpath('./a').attribute('href').value,
          icon: obj.xpath('./a').attribute('icon')&.value
        }
        raise unless folder_id

        bookmark = save_bookmark(params, account, folder_id, sort_num)
      else
        params = {
          name: obj.xpath('./h3').text,
          parent_count: level
        }
        folder = save_folder(params, account, folder_id, sort_num)
        folder_id = folder.id

        # raise
        child_sort_num = 0
        obj.next_element.xpath('./dt').each do |child|
          save_import_data(child, level + 1, account, folder_id, child_sort_num)
          child_sort_num += 1
        end
      end
    end
  end

end
