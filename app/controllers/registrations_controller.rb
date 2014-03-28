class RegistrationsController < Devise::RegistrationsController

  before_action :set_membername, only: [:create]

  def update
    # For Rails 4
    account_update_params = devise_parameter_sanitizer.sanitize(:account_update)

    # required for settings form to submit when password is left blank
    if account_update_params[:password].blank?
      account_update_params.delete("password")
      account_update_params.delete("password_confirmation")
    end

    @member = Member.find(current_member.id)
    if @member.update_attributes(account_update_params)
      set_flash_message :notice, :updated
      # Sign in the member bypassing validation in case his password changed
      sign_in @member, :bypass => true
      redirect_to after_update_path_for(@member)
    else
      render "edit"
    end
  end

  def edit
  end

  protected

  # Overriding this method from ApplicationController is deprecated
  # a new controller extending Devise::RegistrationsController has to be created.
  def after_update_path_for(resource)
    dashboard_path(resource.membername)
  end

  private

  def set_membername
    params[:member][:membername] ||= Time.now.to_i
  end

end
