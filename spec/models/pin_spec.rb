require 'spec_helper.rb'

describe Pin do

  it "is valid with a description, image and associated board" do
    expect(build(:pin)).to be_valid
  end

  it "is uploaded at specified location" do
    pin = create(:pin)
    expect(pin.image.path).to eq "#{Rails.root}/public/uploads/pins/images/#{pin.id}/original/#{pin.image_file_name}"
  end

  it "is invalid without a description" do
    expect(build(:pin, description: nil)).to have(1).errors_on(:description)
  end

  it "is invalid without an image" do
    expect(build(:pin, image: nil)).to have(1).errors_on(:image)
  end

  it "is invalid without an associated board" do
    expect(build(:pin, board_id: nil)).to have(1).errors_on(:board_id)
  end

  it "is invalid if size > 50K" do
    image = File.new("#{Rails.root}/spec/support/large.jpg")
    expect(build(:pin, image: image)).to have(1).errors_on(:image_file_size)
  end

  it "is invalid for an image with incorrect extension" do
    image = File.new("#{Rails.root}/spec/support/wrong.txt")
    expect(build(:pin, image: image)).to have(1).errors_on(:image_content_type)
  end

  it "is invalid with improper image header" do
    image = File.new("#{Rails.root}/spec/support/test.png")
    board = create(:board)
    pin = Pin.create( image: image, board_id: board.id, description: "Pin 1")
    #expect(pin).not_to have(:no).errors_on(:image)
    #  expect(pin.errors[:image]).to eq "hello"
    expect(pin.errors[:image]).to include "is of invalid type"
  end

end
