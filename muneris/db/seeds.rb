# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'

=begin
User.create!({:email => "eadmin@gmail.com", :admin => 1, :password => "12345678", :password_confirmation => "12345678", :address => "Calle 93 # 46", :name => "E_Admin", :locale => "Barranquilla, Atlantico, Colombia"})
User.create!({:email => "wadmin@gmail.com", :admin => 2, :password => "12345678", :password_confirmation => "12345678", :address => "Calle 93 # 46", :name => "W_Admin", :locale => "Barranquilla, Atlantico, Colombia"})
User.create!({:email => "gadmin@gmail.com", :admin => 3, :password => "12345678", :password_confirmation => "12345678", :address => "Calle 93 # 46", :name => "G_Admin", :locale => "Barranquilla, Atlantico, Colombia"})
=end


csv_locales = File.read('db/data/Localidades.csv').force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
data_locales = CSV.parse(csv_locales, :headers => false)

csv_users1 = File.read('db/data/clientes_part1.csv').force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
data_users1 = CSV.parse(csv_users1, :headers => false)
puts "Got users"
csv_bills1 = File.read('db/data/Consumos_part1.csv').force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
data_bills1= CSV.parse(csv_bills1, :headers => false)
puts "Got bills"

# csv_users2 = File.read('db/data/clientes_part2.csv').force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
# data_users2 = CSV.parse(csv_users2, :headers => false)
# csv_bills2 = File.read('db/data/Consumos_part2.csv').force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
# data_bills2= CSV.parse(csv_bills2, :headers => false)

# csv_users3 = File.read('db/data/clientes_part3.csv').force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
# data_users3 = CSV.parse(csv_users3, :headers => false)
# csv_bills3 = File.read('db/data/Consumos_part3.csv').force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
# data_bills3= CSV.parse(csv_bills3, :headers => false)

# csv_users4 = File.read('db/data/clientes_part4.csv').force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
# data_users4 = CSV.parse(csv_users4, :headers => false)
# csv_bills4 = File.read('db/data/Consumos_part4.csv').force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
# data_bills4= CSV.parse(csv_bills4, :headers => false)

# csv_users5 = File.read('db/data/clientes_part5.csv').force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
# data_users5 = CSV.parse(csv_users5, :headers => false)
# csv_bills5 = File.read('db/data/Consumos_part5.csv').force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
# data_bills5= CSV.parse(csv_bills5, :headers => false)

# csv_users6 = File.read('db/data/clientes_part6.csv').force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
# data_users6 = CSV.parse(csv_users6, :headers => false)
# csv_bills6 = File.read('db/data/Consumos_part6.csv').force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
# data_bills6= CSV.parse(csv_bills6, :headers => false)

# csv_users7 = File.read('db/data/clientes_part7.csv').force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
# data_users7 = CSV.parse(csv_users7, :headers => false)
# csv_bills7 = File.read('db/data/Consumos_part7.csv').force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
# data_bills7= CSV.parse(csv_bills7, :headers => false)


# i = 0

# data_users7.each do |user|
# 	data_locales.each do |locale|
# 		if user[2] == locale[0]
			
# 			new_user = User.create({
# 				:email => [i.to_s,Faker::Internet.email].join,
# 				:password => "12345678",
# 				:password_confirmation => "12345678",
# 				:tariff => user[0],
# 				:address => user[1],
# 				:locale => [locale[2].capitalize,locale[3].capitalize,"Colombia"].join(', '),
# 				:familyname => ["User",i.to_s].join,
# 				:name => ["user",i.to_s," administrator"].join
# 				})

# 			i += 1

# 			1.upto(44) do |j|

# 				new_bill = Bill.create({   
# 					:consumption => data_bills7[i][j],
# 					:value => data_bills7[i][j].to_f*Random.rand(200 .. 500),
# 					:date => Date.parse(data_bills7[0][j]),
# 					:service => 1
# 					})

# 				new_user.userbills.create!(bill_id: new_bill.id)
# 			end
# 		end
# 	end
# end

# i = 0

# data_users6.each do |user|
# 	data_locales.each do |locale|
# 		if user[2] == locale[0]
			
# 			new_user = User.create({
# 				:email => [i.to_s,Faker::Internet.email].join,
# 				:password => "12345678",
# 				:password_confirmation => "12345678",
# 				:tariff => user[0],
# 				:address => user[1],
# 				:locale => [locale[2].capitalize,locale[3].capitalize,"Colombia"].join(', '),
# 				:familyname => ["User",i.to_s].join,
# 				:name => ["user",i.to_s," administrator"].join
# 				})

# 			i += 1

# 			1.upto(44) do |j|

# 				new_bill = Bill.create({   
# 					:consumption => data_bills6[i][j],
# 					:value => data_bills6[i][j].to_f*Random.rand(200 .. 500),
# 					:date => Date.parse(data_bills6[0][j]),
# 					:service => 1
# 					})

# 				new_user.userbills.create!(bill_id: new_bill.id)
# 			end
# 		end
# 	end
# end

# i = 0

# data_users5.each do |user|
# 	data_locales.each do |locale|
# 		if user[2] == locale[0]
			
# 			new_user = User.create({
# 				:email => [i.to_s,Faker::Internet.email].join,
# 				:password => "12345678",
# 				:password_confirmation => "12345678",
# 				:tariff => user[0],
# 				:address => user[1],
# 				:locale => [locale[2].capitalize,locale[3].capitalize,"Colombia"].join(', '),
# 				:familyname => ["User",i.to_s].join,
# 				:name => ["user",i.to_s," administrator"].join
# 				})

# 			i += 1

# 			1.upto(44) do |j|

# 				new_bill = Bill.create({   
# 					:consumption => data_bills5[i][j],
# 					:value => data_bills5[i][j].to_f*Random.rand(200 .. 500),
# 					:date => Date.parse(data_bills5[0][j]),
# 					:service => 1
# 					})

# 				new_user.userbills.create!(bill_id: new_bill.id)
# 			end
# 		end
# 	end
# end

# i = 0

# data_users4.each do |user|
# 	data_locales.each do |locale|
# 		if user[2] == locale[0]
			
# 			new_user = User.create({
# 				:email => [i.to_s,Faker::Internet.email].join,
# 				:password => "12345678",
# 				:password_confirmation => "12345678",
# 				:tariff => user[0],
# 				:address => user[1],
# 				:locale => [locale[2].capitalize,locale[3].capitalize,"Colombia"].join(', '),
# 				:familyname => ["User",i.to_s].join,
# 				:name => ["user",i.to_s," administrator"].join
# 				})

# 			i += 1

# 			1.upto(44) do |j|

# 				new_bill = Bill.create({   
# 					:consumption => data_bills4[i][j],
# 					:value => data_bills4[i][j].to_f*Random.rand(200 .. 500),
# 					:date => Date.parse(data_bills4[0][j]),
# 					:service => 1
# 					})

# 				new_user.userbills.create!(bill_id: new_bill.id)
# 			end
# 		end
# 	end
# end

# i = 0

# data_users3.each do |user|
# 	data_locales.each do |locale|
# 		if user[2] == locale[0]
			
# 			new_user = User.create({
# 				:email => [i.to_s,Faker::Internet.email].join,
# 				:password => "12345678",
# 				:password_confirmation => "12345678",
# 				:tariff => user[0],
# 				:address => user[1],
# 				:locale => [locale[2].capitalize,locale[3].capitalize,"Colombia"].join(', '),
# 				:familyname => ["User",i.to_s].join,
# 				:name => ["user",i.to_s," administrator"].join
# 				})

# 			i += 1

# 			1.upto(44) do |j|

# 				new_bill = Bill.create({   
# 					:consumption => data_bills3[i][j],
# 					:value => data_bills3[i][j].to_f*Random.rand(200 .. 500),
# 					:date => Date.parse(data_bills3[0][j]),
# 					:service => 1
# 					})

# 				new_user.userbills.create!(bill_id: new_bill.id)
# 			end
# 		end
# 	end
# end

# i = 0

# data_users2.each do |user|
# 	data_locales.each do |locale|
# 		if user[2] == locale[0]
			
# 			new_user = User.create({
# 				:email => [i.to_s,Faker::Internet.email].join,
# 				:password => "12345678",
# 				:password_confirmation => "12345678",
# 				:tariff => user[0],
# 				:address => user[1],
# 				:locale => [locale[2].capitalize,locale[3].capitalize,"Colombia"].join(', '),
# 				:familyname => ["User",i.to_s].join,
# 				:name => ["user",i.to_s," administrator"].join
# 				})

# 			i += 1

# 			1.upto(44) do |j|

# 				new_bill = Bill.create({   
# 					:consumption => data_bills2[i][j],
# 					:value => data_bills2[i][j].to_f*Random.rand(200 .. 500),
# 					:date => Date.parse(data_bills2[0][j]),
# 					:service => 1
# 					})

# 				new_user.userbills.create!(bill_id: new_bill.id)
# 			end
# 		end
# 	end
# end

i = 0

data_users1.each do |user|
	data_locales.each do |locale|
		if user[2] == locale[0]
			
			new_user = User.create({
				:email => [i.to_s,Faker::Internet.email].join,
				:password => "12345678",
				:password_confirmation => "12345678",
				:tariff => user[0],
				:address => user[1],
				:locale => [locale[2].capitalize,locale[3].capitalize,"Colombia"].join(', '),
				:familyname => ["User",i.to_s].join,
				:name => ["user",i.to_s," administrator"].join
				})

			i += 1

			1.upto(44) do |j|

				new_bill = Bill.create({   
					:consumption => data_bills1[i][j],
					:value => data_bills1[i][j].to_f*Random.rand(200 .. 500),
					:date => Date.parse(data_bills1[0][j]),
					:service => 1
					})

				new_user.userbills.create!(bill_id: new_bill.id)
			end
		end
	end
end
