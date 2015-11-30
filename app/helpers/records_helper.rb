module RecordsHelper
  include CryptoHelper

  def write_record(token, file_io)

    file_name = '%s.file' % token
    file_loc = Rails.root.join('data', file_name)

    logger.info{"File_IO: #{b64_encode file_io}"}
    IO.binwrite(file_loc, file_io)
  end

  def read_record(token, file_io)
    #file_name = '%s.file' % token
    #file_loc = Rails.root.join('data', file_name)
    #File.open(file_loc, 'w') do |f|
    #  f.puts file_io
    #end
  end
end
