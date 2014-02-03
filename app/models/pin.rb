class Pin < ActiveRecord::Base
  belongs_to :board
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  validates :description, presence: true
  #validates :image, :attachment_presence => true
  validates_attachment :image,
    :content_type => { :content_type => ["image/jpg", "image/gif", "image/png"] }
end
