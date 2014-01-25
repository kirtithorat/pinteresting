class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :firstname
      t.string :lastname
      t.text :description
      t.string :gender
      t.string :location
      t.attachment :avatar

      t.timestamps
    end
  end
end
