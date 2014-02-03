class Board < ActiveRecord::Base
  belongs_to :member
  has_many :pins
  validates :name, :category , presence: true

end
