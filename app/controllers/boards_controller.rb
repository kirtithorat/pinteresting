class BoardsController < ApplicationController

  before_action :set_board, only: [:show, :edit, :update, :destroy]

  def index
  end

  def new
    @board = Board.new
  end

  def show
    @pins = @board.pins.order(created_at: :desc).paginate(:page => params[:page], :per_page => 10)
  end

  def edit
  end

  def create
    @board = Board.new(board_params)
    @board.member_id = current_member.id
    if @board.save
      redirect_to dashboard_path(@board.member.membername), notice: 'Board was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @board.update(board_params)
      redirect_to board_path(@board), notice: 'Board was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    membername = @board.member.membername
    @board.destroy
    redirect_to dashboard_path(membername)
  end

  private

  def set_board
    @board = Board.find(params[:id])
  end

  def board_params
    params.require(:board).permit(:name, :description, :category, :member_id)
  end
end