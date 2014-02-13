class RegistrationsController < Devise::RegistrationsController

  protected

  # Overriding this method from ApplicationController is deprecated 
  # a new controller extending Devise::RegistrationsController has to be created.
    def after_update_path_for(resource)
      dashboard_path
    end
end