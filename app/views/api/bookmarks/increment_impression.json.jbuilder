# logger.debug 'DEBUG >>>'
# logger.debug @bookmarks.inspect
# logger.debug '<<< DEBUG'

json.set! :bookmark do
  json.merge! @bookmark
end

