class RemoveColumnsFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :username, :string
    remove_column :users, :neighborhood, :string
    remove_column :users, :city, :string
  end
end
