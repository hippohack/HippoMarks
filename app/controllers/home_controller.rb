class HomeController < ApplicationController
  # before_action :authenticate_account!, except: [:welcome, :release_notes]

  def index
    unless account_signed_in?
      redirect_to welcome_path
      return
    end

    @top_folder = current_account
                  .folders
                  .top_folder(current_account.bookmarkbar_folder_id)
    @sort_setting = current_account.settings.find_by(key: 'item_sort').value

    folders = @top_folder.folders
    bookmarks = @top_folder.bookmarks
    @top_folder_children = folder_item_mix(folders, bookmarks, @sort_setting)
  end

  def welcome
    redirect_to root_path if account_signed_in?
  end

  def release_notes

  end

  private

  def folder_item_mix(folders, bookmarks, sort_type)
    res = []
    folders.each do |folder|
      res.push(folder)
    end

    bookmarks.each do |bookmark|
      res.push(bookmark)
    end

    case sort_type
    when 'optional'
      sort_by_sort_num(res)
    when 'name'
      sort_by_name(res)
    when 'created_at'
      sort_by_created_at(res)
    when 'updated_at'
      sort_by_updated_at(res)
    else
      raise
    end
  end

  # ここに置くかどうかは別途判断が必要
  def sort_by_sort_num(items)
    items.sort_by! do |item|
      item[:sort_num]
    end
  end

  def sort_by_name(items)
    items.sort_by! do |item|
      item[:name]
    end
  end

  def sort_by_created_at(items)
    items.sort_by! do |item|
      item[:created_at]
    end
  end

  def sort_by_updated_at(items)
    items.sort_by! do |item|
      item[:updated_by]
    end
  end

end
