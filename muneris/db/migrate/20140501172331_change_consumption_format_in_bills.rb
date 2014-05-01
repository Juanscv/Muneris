class ChangeConsumptionFormatInBills < ActiveRecord::Migration
  def change
   	change_column :bills, :consumption, :float
  end
end
