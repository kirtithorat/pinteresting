class CreateOauthMembers < ActiveRecord::Migration
  def change
    create_table :oauth_members do |t|
      t.string :uid
      t.string :provider
      t.references :member, index: true

      t.timestamps
    end
  end
end
