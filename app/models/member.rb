class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
    :recoverable, :rememberable, :trackable, :validatable
  has_many :boards, dependent: :destroy
  has_many :pins, through: :boards

  validates :firstname, :location, presence: true
  validates :membername, presence: true, uniqueness: true,
    length: { maximum: 25 },
    format: { with: /\A([A-Za-z0-9_.]+)+\z/, message: "invalid : only allows letters, numbers, underscore and dot" }

  ## /\A([A-Za-z0-9_.]*[A-Za-z]+[A-Za-z0-9_.]*)+\z/    only allows atleast one letter, numbers and underscore
  validates :firstname, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }
  validates :lastname, format: { with: /\A[a-zA-Z\s.]*\z/, message: "only allows letters" }
  validates :description, length: { maximum: 280 }
  validates :firstname, :lastname, length: { maximum: 25 }

  has_attached_file :avatar,
    :styles => { :thumb => "100x100>" },
    :path => '/Users/kirti/Dropbox/Projects/RubyonRails/pinteresting/public/uploads/:class/:attachment/:id/:style/:basename.:extension',
    :url => '/uploads/:class/:attachment/:id/:style/:basename.:extension'


  validates :avatar, image_encoding: true
  validates_attachment :avatar,
    content_type:  { content_type: ["image/jpg", "image/jpeg", "image/gif", "image/png"] },
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

  def self.from_omniauth(auth)
    ### handle for unique membername
    where(auth.slice(:provider, :uid)).first_or_create do |member|
      member.provider = auth.provider
      member.uid = auth.uid
      member.membername = Time.now.to_i
      name = auth.info.name.split(" ",2)
      member.firstname = name[0]
      member.lastname = name[1]
      unless auth.info.location.nil?
        member.location = auth.info.location.split(",")[1].strip
      end
      if auth.provider == 'twitter'
        member.email = "#{auth.info.nickname}@startupora.com"
      else
        member.email = auth.info.email
      end
    end
  end

  def self.new_with_session(params, session)
    if session["devise.member_attributes"]
      new(session["devise.member_attributes"], without_protection: true) do |member|
        member.attributes = params
        member.valid?
      end
    else
      super
    end
  end

  def password_required?
    super && provider.blank?
  end

end
