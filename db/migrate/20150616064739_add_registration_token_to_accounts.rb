class AddRegistrationTokenToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :registration_token, :string
  end
end
