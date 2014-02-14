class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable
  has_many :boards, dependent: :destroy

  validates :firstname, :lastname, :location, presence: true
  validates :membername, presence: true, uniqueness: true,
    length: { maximum: 25 },
    format: { with: /\A([0-9]*[A-Za-z]+[0-9]*)+\z/ , message: "invalid : only allows atleast one letter and numbers" }
  validates :firstname, :lastname, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }
  validates :description, length: { maximum: 280 }
  validates :firstname, :lastname, length: { maximum: 25 }

  has_attached_file :avatar,
    :styles => { :thumb => "100x100>" },
    :path => '/Users/kirti/Dropbox/Projects/RubyonRails/pinteresting/public/uploads/:class/:attachment/:id/:basename.:extension',
    :url => '/uploads/:class/:attachment/:id/:basename.:extension'


  validates :avatar, image_encoding: true
  validates_attachment :avatar,
    :content_type => { :content_type => ["image/jpg", "image/jpeg", "image/gif", "image/png"] },
    :size => {:in => 0..50.kilobytes}

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
