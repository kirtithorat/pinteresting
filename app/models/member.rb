class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable
  has_many :boards
  has_many :pins, through: :boards

  validates :firstname, :lastname, :location , presence: true

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  validates_attachment :avatar,
    :content_type => { :content_type => ["image/jpg", "image/gif", "image/png"] }

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
