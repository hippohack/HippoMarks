# logger.debug 'DEBUG >>>'
# logger.debug @bookmarks.inspect
# logger.debug '<<< DEBUG'

json.set! :bookmarkbar_items do
  json.merge! @bookmarkbar_items
end

