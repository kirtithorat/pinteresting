require 'spec_helper'

describe BoardsController do

  before(:each){
    @request.env["devise.mapping"] = Devise.mappings[:member]
  }

  describe "GET #new" do
    it "renders new board page" do
      get :new
      expect(assigns(:board)).to be_a_new(Board)
      expect(response).to render_template :new
    end
  end

  describe "POST #create:" do

    before(:each){
      sign_in FactoryGirl.create(:member)
    }

    context "with valid attributes" do

      it "creates a board in the database" do
        # post :create, :board => attributes_for(:board)
        # expect(Board.find_by(name: "Food Board")).not_to be nil
        expect { post :create, :board => attributes_for(:board) }.to change(Board, :count).by(1)
      end

      it "and redirects to dashboard page" do
        post :create, :board => attributes_for(:board)
        expect(response).to redirect_to :dashboard
      end

    end

    context "with invalid attributes" do

      it "does not create a board in the database" do
        expect { post :create, :board => attributes_for(:board, category: nil) }.not_to change(Board, :count)
      end

      it "and re-renders new board page" do
        post :create, :board => attributes_for(:board, category: nil)
        expect(response).to render_template :new
      end

    end

  end

  describe "GET #show" do
    it "renders show board page" do
      board = create(:board)
      get :show, id: board
      expect(assigns(:board)).to eq board
      expect(response).to render_template :show
    end
  end

  describe "GET #edit" do
    it "renders edit board page" do
      board = create(:board)
      get :edit, id: board
      expect(assigns(:board)).to eq board
      expect(response).to render_template :edit
    end
  end

  describe "PATCH #update:" do

    let(:board) { FactoryGirl.create(:board) }

    before(:each){
      sign_in board.member
    }

    context "with valid attributes" do

      it "updates the board in the database" do
        patch :update, id: board, :board => attributes_for(:board, category: "Fashion")
        expect(Board.find_by(name: board.name, category: "Fashion")).not_to be nil
      end

      it "and redirects to dashboard page" do
        patch :update, id: board, :board => attributes_for(:board, category: "Fashion")
        expect(response).to redirect_to board_path(board)
      end

    end

    context "with invalid attributes" do

      it "does not update the board in the database" do
        patch :update, id: board, :board => attributes_for(:board, category: nil)
        expect(Board.find_by(name: board.name, category: nil)).to be nil
      end

      it "and re-renders edit board page" do
        patch :update, id: board, :board => attributes_for(:board, category: nil)
        expect(response).to render_template :edit
      end

    end

  end

  describe "DELETE #destroy" do

    let(:board) { FactoryGirl.create(:board) }

    before(:each){
      sign_in board.member
    }

    it "deletes the board from the database" do
      delete :destroy, id: board
      expect(Board.find_by(name: board.name)).to be nil
    end

    it "and redirects to dashboard page" do
      delete :destroy, id: board
      expect(response).to redirect_to :dashboard
    end

  end

end
