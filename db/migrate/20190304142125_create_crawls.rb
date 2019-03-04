class CreateCrawls < ActiveRecord::Migration[5.2]
  def change
    create_table :crawls do |t|
      t.string :start_location
      t.string :end_location
      t.integer :pub_number
      t.string :latitute
      t.string :longitude
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
