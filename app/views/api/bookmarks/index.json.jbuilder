# logger.debug 'DEBUG >>>'
# logger.debug @bookmarks.inspect
# logger.debug '<<< DEBUG'

json.set! :bookmarks do
  json.merge! @bookmarks
end

