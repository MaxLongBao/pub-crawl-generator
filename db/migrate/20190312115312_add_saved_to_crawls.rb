class AddSavedToCrawls < ActiveRecord::Migration[5.2]
  def change
    add_column :crawls, :saved, :boolean, default: false
  end
end
