class RenameColumnTypeInBills < ActiveRecord::Migration
  def change
  	rename_column :bills, :type, :service
  end
end
