class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :firstname,:null => false
      t.string :lastname,:null => false
      t.text :description
      t.string :gender
      t.string :location,:null => false
      t.attachment :avatar

      t.timestamps
    end
  end
end
