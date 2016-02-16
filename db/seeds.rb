# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create([{name: "admin", password: "hejsan", password_confirmation: "hejsan"}, {name: "itzy", password: "hejsan", password_confirmation: "hejsan"}])

App.create(name: "itzy's app", description: "min app", user_id: 2)

Restaurant.create([{name: "Itzy's place", message: "Jävligt snygg restaurang", rating: 4, position_id: 1}, 
                {name: "Mammas mat!", message: "Världens bästa!", rating: 5, position_id: 1},
                {name: "Anubis bistro", message: "Katten med klös", rating: 5, position_id: 1}])
                
Position.create([{address: "Statue of Liberty, NY"}, {address: "Värendsgatan 12, Lammhult"}])

tag = Tag.create(name: "#vegan")
restaurant = Restaurant.create(name: "Bananpaj", message: "Massa bananer", rating: 4, position_id: 2)



restaurant.tag_ids = [tag.id]
restaurant.save