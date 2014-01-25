class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.string :name
      t.text :description
      t.string :category
      t.references :members, index: true

      t.timestamps
    end
  end
end
