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
csv_bills = File.read('db/data/Consumos.csv').force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
data_bills= CSV.parse(csv_bills, :headers => true)
data_bills.to_a!

i = 0

data_users.each do |user|
	data_locales.each do |locale|
		if user[2] == locale[0]
			
			new_user = User.create({
				:email => [i.to_s,Faker::Internet.email].join,
				:password => "12345678",
				:password_confirmation => "12345678",
				:tariff => user[1],
				:address => user[0],
				:locale => [locale[2].capitalize,locale[3].capitalize,"Colombia"].join(', '),
				:familyname => ["User",i.to_s].join,
				:admin => 0
				})

			i += 1

			1.upto(44) do |j|

				new_bill = Bill.create({   
					:consumption => data_bills[i][j],
					:value => data_bills[i][j].to_f*Random.rand(200 .. 500),
					:date => Date.parse(data_bills[0][j]),
					:service => 1
					})

				new_user.userbills.create!(bill_id: new_bill.id)
			end
		end
	end
end

User.create!({:email => "eadmin@gmail.com", :admin => 1, :password => "12345678", :password_confirmation => "12345678", :address => "Calle 93 # 46", :name => "E_Admin", :locale => "Barranquilla, Atlantico, Colombia"})
User.create!({:email => "wadmin@gmail.com", :admin => 2, :password => "12345678", :password_confirmation => "12345678", :address => "Calle 93 # 46", :name => "W_Admin", :locale => "Barranquilla, Atlantico, Colombia"})
User.create!({:email => "gadmin@gmail.com", :admin => 3, :password => "12345678", :password_confirmation => "12345678", :address => "Calle 93 # 46", :name => "G_Admin", :locale => "Barranquilla, Atlantico, Colombia"})


