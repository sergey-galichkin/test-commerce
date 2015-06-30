class CreateThemes < ActiveRecord::Migration
  def change
    create_table :themes do |t|
      t.string :name, null:false, limit:100
      t.string :zip_file_url, null:false, limit:2000
      t.integer :status, null:false, default: 0
    end
  end
end
