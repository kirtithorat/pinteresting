require 'spec_helper.rb'

describe Pin do

  let(:board) { FactoryGirl.create(:board) }

  it "is valid with a description, image and associated board" do
    image = File.new("#{Rails.root}/spec/support/google.png")
    expect(Pin.new(description: "First Pin", image: image, board_id: board.id)).to be_valid
  end

  it "is uploaded at specified location" do
    image = File.new("#{Rails.root}/spec/support/google.png")
    pin = Pin.create(description: "First Pin",image: image, board_id: board.id)
    expect(pin.image.path).to eq "#{Rails.root}/spec/support/uploads/pins/images/#{pin.id}/original/#{pin.image_file_name}"
  end

  it "is invalid without a description" do
    expect(Pin.new(description: nil)).to have(1).errors_on(:description)
  end

  it "is invalid without an image" do
    pin =Pin.new(image: nil)
    expect(pin).to have(1).errors_on(:image)
  end

  it "is invalid without an associated board" do
    expect(Pin.new(board_id: nil)).to have(1).errors_on(:board_id)
  end

  it "is invalid if size > 20K" do
    image = File.new("#{Rails.root}/spec/support/large.jpg")
    expect(Pin.new(image: image)).to have(1).errors_on(:image_file_size)
  end

  it "is invalid for an image with incorrect extension" do
    image = File.new("#{Rails.root}/spec/support/wrong.txt")
    expect(Pin.new(image: image)).to have(1).errors_on(:image_content_type)
  end
 
  it "is invalid with improper image header" do
    image = File.new("#{Rails.root}/spec/support/test.png")
    pin = Pin.create( image: image)
    # expect(pin).not_to have(:no).errors_on(:image)
    expect(pin.errors[:image]).to include "is of invalid type"
  end

end
