# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create([{name: "admin", password: "hejsan", password_confirmation: "hejsan"}, {name: "itzy", password: "hejsan", password_confirmation: "hejsan"}])

App.create(name: "itzy's app", description: "min app", user_id: 2)

Restaurant.create([{name: "Itzy's place", description: "Jävligt snygg restaurang", position_id: 1}, 
                {name: "Mammas mat!", description: "Världens bästa!", position_id: 1},
                {name: "Anubis bistro", description: "Katten med klös", position_id: 1}])
                
Position.create([{address: "Statue of Liberty, NY"}, {address: "Värendsgatan 12, Lammhult"}])