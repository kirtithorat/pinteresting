class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.string :name,:null => false
      t.text :description
      t.string :category,:null => false
      t.references :member, index: true

      t.timestamps
    end
  end
end
