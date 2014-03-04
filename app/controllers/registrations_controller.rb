class RegistrationsController < Devise::RegistrationsController

  before_action :set_membername, only: [:create]

  protected

  # Overriding this method from ApplicationController is deprecated
  # a new controller extending Devise::RegistrationsController has to be created.
  def after_update_path_for(resource)
    dashboard_path(resource.membername)
  end

  def set_membername
    params[:member][:membername] ||= Time.now.to_i
  end

end
