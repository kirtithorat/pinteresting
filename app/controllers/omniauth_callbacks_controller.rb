class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def all
    member = Member.from_omniauth(request.env["omniauth.auth"])
    if member.persisted?
      flash.notice = "Welcome! You have Logged In successfully..."
      sign_in_and_redirect member
    else
      session["devise.member_attributes"] = member.attributes
      redirect_to new_member_registration_url
    end
    # raise request.env["omniauth.auth"].to_yaml  ### See the Twitter response details
  end

  alias_method :twitter, :all
  alias_method :facebook, :all
  alias_method :google_oauth2, :all

end
