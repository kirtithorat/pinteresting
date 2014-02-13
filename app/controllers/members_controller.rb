class MembersController < ApplicationController

  before_action :load_dashboard, only: [:dashboard]
  def dashboard
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def load_dashboard
    if current_member.nil?
      begin
        @member = Member.find(params[:id])
      rescue
        render :errors and return
      end
    else
      @member = current_member
    end
    @boards = @member.boards
  end

end
