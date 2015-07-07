class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name, null: false, limit:50
      t.boolean :can_create_users, null: false, default: false
      t.boolean :can_update_users_password, null: false, default: false
      t.boolean :can_update_users_role, null: false, default: false
      t.boolean :can_delete_users, null: false, default: false

      t.timestamps null: false
    end

    add_index :roles, :name, unique: true
  end
end
