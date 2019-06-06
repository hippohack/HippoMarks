# logger.debug 'DEBUG >>>'
# logger.debug @folders.inspect
# logger.debug '<<< DEBUG'

json.set! :folders do
  json.merge! @folders
end

