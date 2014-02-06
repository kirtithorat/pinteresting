class CreatePins < ActiveRecord::Migration
  def change
    create_table :pins do |t|
      t.text :description, null: false
      t.attachment :image
      t.references :board, index: true, null: false

      t.timestamps
    end
  end
end
