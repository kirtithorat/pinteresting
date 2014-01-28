class MembersController < ApplicationController

  def dashboard
  	load_dashboard
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def load_dashboard
    @member = current_member
  end

end
