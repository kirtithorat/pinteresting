class Board < ActiveRecord::Base
  belongs_to :members
  has_many :pins
end
