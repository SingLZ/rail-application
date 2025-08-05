class CreatePlants < ActiveRecord::Migration[8.0]
  def change
    create_table :plants do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :species
      t.string :location
      t.integer :watering_frequency
      t.datetime :last_watered_at

      t.timestamps
    end
  end
end
