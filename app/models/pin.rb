require 'mini_magick'

class Pin < ActiveRecord::Base
  belongs_to :board
  # When :path and :url are not specified in "has_attached_file" then Paperclip
  # will use its default path and default url as shown below:
  # :path => :rails_root/public/system/:class/:attachment/:id_partition/:style/:filename
  # :url => /system/:class/:attachment/:id_partition/:style/:filename
  has_attached_file :image,
    :styles => { :medium => "300x300>", :thumb => "100x100", :icon => "50x50" },
    :path => '/Users/kirti/Dropbox/Projects/RubyonRails/pinteresting/public/uploads/:class/:attachment/:id/:style/:basename.:extension',
    :url => '/uploads/:class/:attachment/:id/:style/:basename.:extension'
  validates :description,  presence: true, length: { maximum: 280 }
  validates :board_id, presence: true
  validates :image, attachment_presence: true

  validates :image, image_encoding: true
  validates_attachment :image,
    :content_type => { :content_type => ["image/jpg", "image/jpeg", "image/gif", "image/png"] },
    :size => {:in => 0..50.kilobytes}

end
