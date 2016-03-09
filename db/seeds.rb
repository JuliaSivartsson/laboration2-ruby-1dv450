# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create([{name: "admin", password: "hejsan", password_confirmation: "hejsan"}, {name: "DemoUser", password: "secret", password_confirmation: "secret"}, {name: "itzy", password: "hejsan", password_confirmation: "hejsan"}])
App.create(name: "itzy's app", description: "min app", user_id: 3)


creator1 = Creator.create(name: "Julia", password: "hejsan", password_confirmation: "hejsan", email: "itzy_90@hotmail.com")
creator2 = Creator.create(name: "Itzy", password: "hejsan", password_confirmation: "hejsan", email: "bananpaj@hotmail.com")
           
Position.create([
    {address: "Värnamovägen 4, Lammhult"},
    {address: "Storgatan 1, Växjö"},
    {address: "Värendsgatan 12, Lammhult"},
    {address: "Snickarvägen 40, Lammhult"},
    {address: "Floragatan 3, Lammhult"},
    {address: "Storgatan 23, Växjö"}])

tag1 = Tag.create(name: "#vegan");
tag2 = Tag.create(name: "#raw");
tag3 = Tag.create(name: "#awesome");

restaurant1 = Restaurant.create(name: "Itzy's place", message: "Jävligt snygg restaurang", rating: 4, position_id: 1, creator_id: 1)
restaurant2 = Restaurant.create(name: "Mammas mat!", message: "Världens bästa!", rating: 5, position_id: 3, creator_id: 1)
restaurant3 = Restaurant.create(name: "Anubis bistro", message: "Katten med klös", rating: 5, position_id: 2, creator_id: 1)
restaurant4 = Restaurant.create(name: "Green Goey", message: "Så mycket grönt du kan äta!", rating: 5, position_id: 4, creator_id: 2)
restaurant5 = Restaurant.create(name: "IHOP", message: "International House Of Pancakes har kommit till Sverige!", rating: 5, position_id: 5, creator_id: 2)
restaurant6 = Restaurant.create(name: "Raw Food", message: "Naturens egna mirakel", rating: 3, position_id: 6, creator_id: 2)



restaurant1.tag_ids = [tag1.id]
restaurant1.save

restaurant2.tag_ids = [tag3.id]
restaurant2.save

restaurant3.tag_ids = [tag2.id]
restaurant3.save

restaurant4.tag_ids = [tag1.id]
restaurant4.save

restaurant5.tag_ids = [tag3.id]
restaurant5.save

restaurant6.tag_ids = [tag2.id]
restaurant6.save