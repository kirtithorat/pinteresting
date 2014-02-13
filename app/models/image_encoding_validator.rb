class ImageEncodingValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    if record.is_a?Pin
      validate_uploaded_picture(record, attribute, record.image)
    elsif record.is_a?Member
      validate_uploaded_picture(record, attribute, record.avatar)
    end
  end

  def validate_uploaded_picture(record, attribute, picture)
    unless picture.queued_for_write[:original].nil?
      begin
        tempimage =  MiniMagick::Image.open(picture.queued_for_write[:original].path)
        format = tempimage["format"]
        unless (format == 'PNG' || format == 'GIF' || format == 'JPG' || format == 'JPEG')
          record.errors[attribute] << "is of invalid type"
        end
      rescue MiniMagick::Error
        record.errors[attribute] << "is of invalid type"
      end
    end
  end

end
