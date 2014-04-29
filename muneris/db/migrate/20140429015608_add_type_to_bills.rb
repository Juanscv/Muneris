class AddTypeToBills < ActiveRecord::Migration
  def change
    add_column :bills, :type, :integer
  end
end
