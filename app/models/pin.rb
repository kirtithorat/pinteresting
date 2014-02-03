class Pin < ActiveRecord::Base
  belongs_to :board
  validates :description, :image, presence: true

end
