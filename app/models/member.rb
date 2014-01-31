class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable
  has_many :boards
  has_many :pins, through: :boards

  validates :firstname, :lastname, :location , presence: true

  def fullname
    self.firstname + " " + self.lastname
  end

  def pincount
    @pincount = 0

    self.boards.each do |board|
      @pincount += board.pins.count
    end
    @pincount
  end

  def boardcount
    @boardcount = self.boards.count
  end

end
