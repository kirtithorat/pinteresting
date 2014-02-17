require 'spec_helper.rb'

describe Member do

  it "is valid with a firstname, lastname, email, password and location" do
    expect(build(:member)).to be_valid
  end

  it "is valid without a gender" do
    expect(build(:member, gender: nil)).to have(0).errors_on(:gender)
  end

  it "is valid without an avatar" do
    expect(build(:member, avatar: nil)).to have(0).errors_on(:avatar)
  end

  it "is invalid without a firstname" do
    expect(build(:member, firstname: nil)).to have(2).errors_on(:firstname)
  end

  it "is invalid without a lastname" do
    expect(build(:member, lastname: nil)).to have(2).errors_on(:lastname)
  end

  it "is invalid without an email" do
    expect(build(:member, email: nil)).to have(1).errors_on(:email)
  end

  it "is invalid with a duplicate email" do
    existing_member = create(:member)
    expect(Member.new(email: existing_member.email)).to have(1).errors_on(:email)
  end

  it "is invalid without a password" do
    expect(build(:member, password: nil)).to have(1).errors_on(:password)
  end

  it "is invalid without a location" do
    expect(build(:member, location: nil)).to have(1).errors_on(:location)
  end

  it "avatar with size > 50K is invalid" do
    avatar = File.new("#{Rails.root}/spec/support/large.jpg")
    member = build(:member, avatar: avatar)
    expect(member).to have(1).errors_on(:avatar_file_size)
  end

  it "avatar with incorrect extension is invalid" do
    avatar = File.new("#{Rails.root}/spec/support/wrong.txt")
    member = build(:member, avatar: avatar)
    expect(member).to have(1).errors_on(:avatar_content_type)
  end

  it "avatar with improper image header is invalid" do
    avatar = File.new("#{Rails.root}/spec/support/test.png")
    member = Member.create( avatar: avatar)
    expect(member.errors[:avatar]).to include "is of invalid type"
  end

  it "#fullname: returns a Member's full name as a string" do
    member = build(:member)
    expect(member.fullname).to eq member.firstname + " " + member.lastname
  end

  it "#boardcount: returns the number of Board's created by a Member" do
    board = create(:board)
    member = Member.find_by(id: board.member_id)
    expect(member.boardcount).to eq 1
  end

  it "#pincount: returns the number of Pin's uploaded by a Member" do
    pin = create(:pin)
    board = Board.find_by(id: pin.board_id)
    member = Member.find_by(id: board.member_id)
    expect(member.pincount).to eq 1
  end

end
