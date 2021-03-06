class CaptureJob < ApplicationJob
  queue_as :capture

  after_enqueue do |job|
    logger.info('after_enqueue' + job.inspect)
  end

  after_perform do |job|
    logger.info('after_perform' + job.inspect)
  end

  def perform(bookmark_id)
    # Do something later
    @bookmark = Bookmark.find(bookmark_id)

    if @bookmark.og_image_url.blank?
      @bookmark.og_image_url = Bookmark.get_site_capture(@bookmark.url)
    end
    @bookmark.icon = Bookmark.get_icon(@bookmark.url) if @bookmark.icon.blank?

    unless @bookmark.save!
      puts '[ERROR:JOB] => Capture_job is failed.'
    end
  end
end
