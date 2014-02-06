require 'spec_helper.rb'

describe Board do

  let(:member) { FactoryGirl.create(:member) }

  it "is valid with a name, category and associated member" do
    expect(Board.new(name: "Food Board", category: "Food", member_id: member.id)).to be_valid
  end

  it "is valid without a description" do
    expect(Board.new(description: nil)).not_to have(1).errors_on(:description)
  end

  it "is invalid without a name" do
    expect(Board.new(name: nil)).to have(1).errors_on(:name)
  end

  it "is invalid with a duplicate name" do
    existing_board = create(:board)
    expect(Board.new(name: existing_board.name)).to have(1).errors_on(:name)
  end

  it "is invalid without an category" do
    expect(Board.new(category: nil)).to have(1).errors_on(:category)
  end

  it "is invalid without an associated member" do
    expect(Board.new(member_id: nil)).to have(1).errors_on(:member_id)
  end

end
