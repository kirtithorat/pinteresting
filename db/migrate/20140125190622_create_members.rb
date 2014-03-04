class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :firstname, null: false
      t.string :lastname
      t.string :membername, null: false
      t.text :description
      t.string :gender
      t.string :location, null: false, default: "United States"
      t.attachment :avatar

      t.timestamps
    end

    add_index :members, :membername, unique: true
  end
end
