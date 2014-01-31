class Pin < ActiveRecord::Base
  belongs_to :boards
  validates :description, :image, presence: true

end
