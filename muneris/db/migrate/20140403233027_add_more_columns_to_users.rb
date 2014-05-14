class AddMoreColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :tariff, :string
    add_column :users, :locale, :string
  end
end
