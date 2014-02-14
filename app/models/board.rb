class Board < ActiveRecord::Base
  belongs_to :member
  has_many :pins, dependent: :destroy
  validates :name, presence: true, uniqueness: {scope: :member_id}, length: { maximum: 25 }
  validates :description, length: { maximum: 500 }
  validates :category, :member_id, presence: true
end
