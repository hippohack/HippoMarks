module BookmarksHelper
  require 'addressable/uri'

  def url_to_domain(url)
    Addressable::URI.parse(url).host
  end
end
