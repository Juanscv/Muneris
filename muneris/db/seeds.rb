# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'    

csv_users = File.read('db/data/Clientes.csv')
data_users = CSV.parse(csv_users, :headers => false)
csv_locales = File.read('db/data/Locales.csv')
data_locales = CSV.parse(csv_locales, :headers => false)
data_users.each do |row|
	users = User.new(row.to_hash)
	data_locales.each do |row|
		if users.locale == row[0]
			users.locale = [row[3],row[4],row[5]].join(', ')
		end
	end
end
