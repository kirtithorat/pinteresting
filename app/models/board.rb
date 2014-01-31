class Board < ActiveRecord::Base
  belongs_to :members
  has_many :pins
  validates :name, :category , presence: true

end
