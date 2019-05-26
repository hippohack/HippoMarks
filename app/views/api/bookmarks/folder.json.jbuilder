# logger.debug 'DEBUG >>>'
# logger.debug @bookmarks.inspect
# logger.debug '<<< DEBUG'

json.set! :folder_items do
  json.merge! @folder_items
end
