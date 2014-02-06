require 'spec_helper.rb'

describe Member do

  it "is valid with a firstname, lastname, email, password and location" do
    expect(Member.new(firstname: "Kirti", lastname: "Thorat", email: "kirti@gmail.com",
                      password: "12345678", location: "India")).to be_valid
  end

  it "is valid without an avatar" do
    expect(Member.new(gender: nil)).to have(0).errors_on(:gender)
  end

  it "is valid without a gender" do
    expect(Member.new(avatar: nil)).to have(0).errors_on(:avatar)
  end

  it "is invalid without a firstname" do
    expect(Member.new(firstname: nil)).to have(1).errors_on(:firstname)
  end

  it "is invalid without a lastname" do
    expect(Member.new(lastname: nil)).to have(1).errors_on(:lastname)
  end

  it "is invalid without an email" do
    expect(Member.new(email: nil)).to have(1).errors_on(:email)
  end

  it "is invalid with a duplicate email" do
    existing_member = create(:member)
    expect(Member.new(email: existing_member.email)).to have(1).errors_on(:email)
  end

  it "is invalid without a password" do
    expect(Member.new(password: nil)).to have(1).errors_on(:password)
  end

  it "is invalid without a location" do
    expect(Member.new(location: nil)).to have(1).errors_on(:location)
  end

  it "avatar with size > 20K is invalid" do
    avatar = File.new("#{Rails.root}/spec/support/large.jpg")
    member = Member.new(avatar: avatar)
    expect(member).to have(1).errors_on(:avatar_file_size)
  end

  it "avatar with incorrect extension is invalid" do
    avatar = File.new("#{Rails.root}/spec/support/wrong.txt")
    member = Member.new(avatar: avatar)
    expect(member).to have(1).errors_on(:avatar_content_type)
  end

  it "avatar with improper image header is invalid" do
    avatar = File.new("#{Rails.root}/spec/support/test.png")
    member = Member.create( avatar: avatar)
    expect(member.errors[:avatar]).to include "is of invalid type"
  end

  it "#fullname: returns a Member's full name as a string" do
    expect(Member.new(firstname: "Kirti", lastname: "Thorat").fullname).to eq "Kirti Thorat"
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
