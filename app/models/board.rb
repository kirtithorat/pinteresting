class Board < ActiveRecord::Base
  belongs_to :member
  has_many :pins
  validates :name, presence: true, uniqueness: true
  validates :category, :member_id, presence: true
end
