class Board < ActiveRecord::Base
  belongs_to :member
  has_many :pins, dependent: :destroy
  validates :name, presence: true, uniqueness: {scope: :member_id}
  validates :category, :member_id, presence: true
end
