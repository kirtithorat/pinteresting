class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable
  has_many :boards, dependent: :destroy

  validates :firstname, :lastname, :location ,  presence: true

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
