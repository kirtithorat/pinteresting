class AddOauthFlagToMembers < ActiveRecord::Migration
  def change
    add_column :members, :oauth_flag, :boolean, default: false
  end
end
