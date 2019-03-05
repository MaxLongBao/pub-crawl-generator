class CreateCrawls < ActiveRecord::Migration[5.2]
  def change
    create_table :crawls do |t|
      t.string :start_location
      t.string :end_location
      t.integer :pub_number
      t.float :start_latitude
      t.float :start_longitude
      t.float :end_latitude
      t.float :end_longitude
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
