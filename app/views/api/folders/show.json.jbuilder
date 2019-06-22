# logger.debug 'DEBUG >>>'
# logger.debug @folders.inspect
# logger.debug '<<< DEBUG'

# json.set! :items do
#   json.set! :folders do
#     json.merge! @folders
#   end
#   json.set! :bookmarks do
#     json.merge! @bookmarks
#   end
# end

json.set! :items do
  json.merge! [@folders, @bookmarks]
end

