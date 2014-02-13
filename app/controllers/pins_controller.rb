class PinsController < ApplicationController

  before_action :set_pin, only: [:show, :edit, :update, :destroy]

  def new
    @pin = Pin.new(board_id: params[:board_id])
    @boards = Board.where(member_id: current_member.id)
  end

  def show

  end

  def edit
    @boards = Board.where(member_id: current_member.id)
  end

  def create
    @pin = Pin.new(pin_params)

    if @pin.save
      redirect_to board_path(@pin.board_id), notice: 'Pin was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @pin.update(pin_params)
      redirect_to pin_path(@pin), notice: 'Pin was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    board = @pin.board
    @pin.destroy
    redirect_to board_path(board.id)
  end

  private
  def set_pin
    @pin = Pin.find(params[:id])
  end

  def pin_params
    params.require(:pin).permit(:description, :image, :board_id)
  end

end
