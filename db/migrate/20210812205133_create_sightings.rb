class CreateSightings < ActiveRecord::Migration[6.1]
  def change
    create_table :sightings do |t|
      t.datetime :date
      t.float :latitude
      t.float :longitude
      t.belongs_to :animal

      t.timestamps
    end
  end
end
