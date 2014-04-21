# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'    

csv_users = File.read('db/data/Clientes.csv').force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
data_users = CSV.parse(csv_users, :headers => false)
csv_locales = File.read('db/data/Localidades.csv').force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
data_locales = CSV.parse(csv_locales, :headers => false)
i=0
data_users.each do |user|
	user = User.new
	user.email=[Faker::Internet.email,i.to_s].join
	user.tariff=user[1]
	user.address= user[0]
	data_locales.each do |locale|
		if user[2] == locale[0]
			user.locale = [locale[2].capitalize,locale[3].capitalize,"Colombia"].join(', ')
		end
	end
	i += 1
	user.save!(:validate => false)
end