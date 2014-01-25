class CreatePins < ActiveRecord::Migration
  def change
    create_table :pins do |t|
      t.string :name
      t.text :description
      t.attachment :image
      t.references :boards, index: true

      t.timestamps
    end
  end
end
