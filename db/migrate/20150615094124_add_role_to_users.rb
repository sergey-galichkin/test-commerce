class AddRoleToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :role, index: true, null: false
  end
end
