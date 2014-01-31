class MembersController < ApplicationController

  before_action :load_dashboard, only: [:dashboard]
  def dashboard
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def load_dashboard
    @mymember = current_member
   # @boards = Board.where(members_id: @mymember.id)
  end

end
