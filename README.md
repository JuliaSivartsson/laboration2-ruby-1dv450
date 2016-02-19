#Laboration 2 - Webbramverk
jsigc09

----

Heroku: [laboration1-Heroku](https://arcane-harbor-88997.herokuapp.com/)

Cloud9: [laboration1-Cloud9](https://laboration2-api-juliasivartsson.c9users.io/)

##Viktigt

Om applikationen körs på egen maskin, finns det tre viktiga steg för att få den att fungera.
* Kör **bundle install**
* **rake db:schema:load**
* **rake db:seed**

För att sedan få igång applikationen att rulla och starta upp databasen behövs följande kommandon:
* rails s -p $PORT -b $IP
* sudo service postgresql start

Körs ingen seed kommer felmeddelande att visas då användaren admin måste finnas i systemet samt ha id 1.
Admin är den person som har fullständiga rättigheter i applikationen och kan se alla användares registrerade appar samt radera dem.

För att komma åt admin kontot finns följande inloggningsuppgifter:

**Användarnamn:** admin

**Lösenord:** hejsan

Dokumentation om API:et hittar ni här: [API-dokumentation](https://github.com/JuliaSivartsson/laboration2-ruby-1dv450/blob/master/API-dokumentation)
Vid problem, kontakta mig på: jsigc09@student.lnu.se
