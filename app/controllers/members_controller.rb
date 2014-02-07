class MembersController < ApplicationController

  before_action :load_dashboard, only: [:dashboard]
  def dashboard
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def load_dashboard
    @member = current_member
    @boards = @member.boards
  end

end
