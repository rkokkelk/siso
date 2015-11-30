module RecordsHelper
  include CryptoHelper

  def write_record(token, file_io)
    file_name = '%s.file' % token
    file_loc = Rails.root.join('data', file_name)
    IO.binwrite(file_loc, file_io)
  end

  def read_record(token)
    file_name = '%s.file' % token
    file_loc = Rails.root.join('data', file_name)
    IO.binread(file_loc)
  end

  def valid_token(token)
    file_name = '%s.file' % token
    file_loc = Rails.root.join('data', file_name)
    File.exist?(file_loc) ? false : true
  end
end
