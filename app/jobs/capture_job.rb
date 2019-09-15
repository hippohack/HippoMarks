class CaptureJob < ApplicationJob
  queue_as :default

  def perform(bookmark_id)
    # Do something later
    @bookmark = Bookmark.find(bookmark_id)
    @bookmark.og_image_url = Bookmark.get_site_capture(@bookmark.url)
    @bookmark.icon = Bookmark.get_icon(@bookmark.url)

    unless @bookmark.save!
      puts '[ERROR:JOB] => Capture_job is failed.'
    end
  end
end
