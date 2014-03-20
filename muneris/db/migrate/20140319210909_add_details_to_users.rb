class AddDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
    add_column :users, :familyname, :string
    add_column :users, :address, :string
    add_column :users, :neighborhood, :string
    add_column :users, :city, :string
  end
end
