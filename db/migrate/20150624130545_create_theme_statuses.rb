class CreateThemeStatuses < ActiveRecord::Migration
  def change
    create_table :theme_statuses do |t|
      t.string :name, null: false, limit:20
    end
  end
end
