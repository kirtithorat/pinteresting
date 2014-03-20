require 'spec_helper.rb'

describe PinsController do

  before(:each){
    @request.env["devise.mapping"] = Devise.mappings[:member]
  }

  describe "GET #new" do
    it "renders new pin page" do
      board = create(:board)
      member = board.member
      sign_in member
      get :new, board_id: board.id
      expect(assigns(:pin)).to be_a_new(Pin)
      expect(response).to render_template :new
    end
  end

  describe "POST #create:" do

    context "with valid attributes" do

      it "creates a pin in the database" do
        board = create(:board)
        member = board.member
        sign_in member
        expect { post :create, :board_id => board.id, :pin => attributes_for(:pin, board_id: board.id) }.to change(Pin, :count).by(1)
      end

      it "and redirects to show board page" do
        board = create(:board)
        member = board.member
        sign_in member
        post :create, :board_id => board.id, :pin => attributes_for(:pin, board_id: board.id)
        expect(response).to redirect_to board_path(board)
      end

    end

    context "with invalid attributes" do

      it "does not create a pin in the database" do
        board = create(:board)
        member = board.member
        sign_in member
        expect { post :create, :board_id => board.id, :pin => attributes_for(:pin, board_id: nil) }.not_to change(Pin, :count)
      end

      it "and re-renders new pin page" do
        board = create(:board)
        member = board.member
        sign_in member
        post :create, :board_id => board.id, :pin => attributes_for(:pin, board_id: nil)
        expect(response).to render_template :new
      end

    end

  end

  describe "GET #show" do
    it "renders show pin page" do
      board = create(:board)
      pin = create(:pin, board_id: board.id, member_id: board.member.id)
      member = pin.board.member
      sign_in member
      get :show, id: pin
      expect(assigns(:pin)).to eq pin
      expect(response).to render_template :show
    end
  end

  describe "GET #edit" do

    it "renders edit pin page" do
      board = create(:board)
      pin = create(:pin, board_id: board.id, member_id: board.member.id)
      member = pin.board.member
      sign_in member
      get :edit, id: pin
      expect(assigns(:pin)).to eq pin
      expect(response).to render_template :edit
    end
  end

  describe "PATCH #update:" do

    let(:board) { FactoryGirl.create(:board) }
    let(:pin) { FactoryGirl.create(:pin, board_id: board.id, member_id: board.member.id) }

    before(:each){
      sign_in pin.board.member
    }

    context "with valid attributes" do

      it "updates the pin in the database" do
        patch :update, id: pin, :pin => attributes_for(:pin, description: "This is not Flan.")
        expect(Pin.find_by(id: pin.id, description: "This is not Flan.")).not_to be nil
      end

      it "and redirects to show pin page" do
        patch :update, id: pin, :pin => attributes_for(:pin, description: "This is not Flan.")
        expect(response).to redirect_to pin_path(pin)

      end

    end

    context "with invalid attributes" do

      it "does not update the pin in the database" do
        patch :update, id: pin, :pin => attributes_for(:pin, description: nil)
        expect(Pin.find_by(id: pin.id, description: nil)).to be nil
      end

      it "and re-renders edit pin page" do
        patch :update, id: pin, :pin => attributes_for(:pin, description: nil)
        expect(response).to render_template :edit
      end

    end

  end

  describe "DELETE #destroy" do

    let(:board) { FactoryGirl.create(:board) }
    let(:pin) { FactoryGirl.create(:pin, board_id: board.id, member_id: board.member.id) }

    before(:each){
      sign_in pin.board.member
    }

    it "deletes the pin from the database" do
      delete :destroy, id: pin
      expect(Pin.find_by(id: pin.id)).to be nil
    end

    it "and redirects to show board page" do
      delete :destroy, id: pin
      expect(response).to redirect_to board_path(pin.board)
    end

  end

end
