# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'    

csv_users = File.read('db/data/Clientes-o.csv').force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
data_users = CSV.parse(csv_users, :headers => false)
csv_locales = File.read('db/data/Localidades.csv').force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
data_locales = CSV.parse(csv_locales, :headers => false)
i=0
data_users.each do |row|
	user = User.new
	user.email=["user",i.to_s,"@gmail.com"].join
	user.address=row[0]
	user.tariff=row[1]
	data_locales.each do |row2|
		if row[2] == row2[0]
			user.locale = [row2[2].capitalize,row2[3].capitalize,"Colombia"].join(', ')
		end
	end
	i += 1
	user.save!(:validate => false)
end
