class AddTelegramIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :telegram_id, :string
  end
end
