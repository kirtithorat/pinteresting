class MembersController < ApplicationController

  before_action :load_dashboard, only: [:dashboard]
  def dashboard
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def load_dashboard
    if current_member.nil?
      @member = Member.find(params[:id])
    else
      @member = current_member
    end
    @boards = @member.boards
  end

end
