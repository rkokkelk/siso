require 'fileutils'
require 'mime/types'

module RecordsHelper
  include CryptoHelper

  def write_record(token, file_io)
    if Rails.env.heroku?
      brick = Brick.new(token: token, blob: file_io)
      brick.save
    else
      file_loc = file_location token
      IO.binwrite(file_loc, file_io)
    end
  end

  def read_record(token)
    raise IOError, "Unable to read record (#{token}), does not exist" unless exists_token? token

    if Rails.env.heroku?
      brick = Brick.find_by(token: token)
      brick.blob
    else
      file_loc = file_location token
      IO.binread(file_loc)
    end
  end

  def remove_record(token)
    raise IOError, "Unable to delete record (#{token}), does not exist" unless exists_token? token

    if Rails.env.heroku?
      brick = Brick.find_by(token: token)
      brick.destroy
    else
      file_loc = file_location token
      FileUtils.rm file_loc
    end
  end

  def exists_token?(token)
    if Rails.env.heroku?
      Brick.exists?(token: token)
    else
      file_loc = file_location token
      File.exist?(file_loc)
    end
  end

  def get_mime_type(file_name)
    ext = File.extname(file_name)
    MIME::Types.type_for(ext)
  end

  def get_token(file)
    File.basename(file, '.file')
  end

  private

  def file_location(value)
    file_name = "#{value}.file"
    Rails.root.join('data', file_name)
  end
end
