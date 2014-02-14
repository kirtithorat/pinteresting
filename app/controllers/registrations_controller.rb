class RegistrationsController < Devise::RegistrationsController

  before_action :set_membername, only: [:create]

  protected

  # Overriding this method from ApplicationController is deprecated
  # a new controller extending Devise::RegistrationsController has to be created.
  def after_update_path_for(resource)
    dashboard_path
  end

  private

  def set_membername
    # if email is provided while signing up
    unless params[:member][:email].empty?
=begin
     Setting membername using email address can also be achieved using Regex
       params[:member][:membername] = /(\w+.\w+)@/.match(params[:member][:email]).to_s
       params[:member][:membername] = /(\w+.\w+)/.match(params[:member][:membername]).to_s.downcase
=end
      # 0th index value refers to the part of email before @
      params[:member][:membername] = params[:member][:email].split("@")[0]
      # if membername is already taken
      unless Member.find_by(membername: params[:member][:membername] ).nil?
        params[:member][:membername] << rand(100..1000).to_s
      end
    end
  end

end
