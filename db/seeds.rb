# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(name: "admin", password: "hejsan", password_confirmation: "hejsan")
Restaurant.create([{name: "Itzy's place", description: "Jävligt snygg restaurang", longitude: "14.5", latitude: "20.5"}, 
                {name: "Mammas mat!", description: "Världens bästa!", longitude: "14.5", latitude: "20.5"},
                {name: "Anubis bistro", description: "Katten med klös", longitude: "14.5", latitude: "20.5"}])