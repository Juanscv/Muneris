class CreateUserbills < ActiveRecord::Migration
  def change
    create_table :userbills do |t|
      t.belongs_to :user
      t.belongs_to :bill

      t.timestamps
    end
  end
end
