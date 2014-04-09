class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.integer :consumption
      t.integer :value
      t.date :date

      t.timestamps
    end
  end
end
