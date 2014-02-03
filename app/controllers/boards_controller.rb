class BoardsController < ApplicationController

  def new
  	@board = Board.new
  end

end
