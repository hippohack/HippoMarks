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
    def foo
      raise
    end

    # インスタンスメソッド
    def save_bookmark(params, account, folder_id)
      params.merge!({ account_id: account.id, folder_id: folder_id })
      Bookmark.create!(params)
    end

    def save_folder(params, account, folder_id)
      params.merge!({ account_id: account.id, folder_id: folder_id })
      Folder.create!(params)
    end

    def save_import_data(obj, level, account, folder_id = nil)
      folder_id = level == 1 ? account.bookmarkbar_folder_id : folder_id

      if obj.xpath('./a').present?
        params = {
          name: obj.xpath('./a').text,
          url: obj.xpath('./a').attribute('href').value,
          icon: obj.xpath('./a').attribute('icon')&.value
        }
        raise unless folder_id

        bookmark = save_bookmark(params, account, folder_id)
      else
        params = {
          name: obj.xpath('./h3').text,
          parent_count: level
        }
        folder = save_folder(params, account, folder_id)
        folder_id = folder.id

        obj.next_sibling.xpath('./dt').each do |child|
          save_import_data(child, level + 1, account, folder_id)
        end
      end
    end
  end

  def hoge
    raise
  end

end
