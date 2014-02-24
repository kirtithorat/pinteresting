class MembersController < ApplicationController

  before_action :load_dashboard, only: [:dashboard]
  def dashboard
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def load_dashboard
    if current_member.nil?
      @member = Member.find_by(membername: params[:id])
      if @member.nil?
        render :errors and return
      end
    else
      @member = current_member
    end
    @boards = @member.boards.order(created_at: :desc).paginate(:page => params[:page], :per_page => 10)
  end

end
