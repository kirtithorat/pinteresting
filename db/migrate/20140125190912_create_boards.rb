class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.string :name, null: false
      t.text :description
      t.string :category, null: false
      t.references :member, index: true, null: false

      t.timestamps
    end

    add_index :boards, [:name, :member_id], unique: true

  end
end
