#Laboration 2 - Webbramverk
jsigc09

----

Heroku: [laboration2-Heroku](https://limitless-falls-33806.herokuapp.com/)

Cloud9: [laboration2-Cloud9](https://laboration2-api-juliasivartsson.c9users.io)

##Installation på cloud9

```
Skapa ett konto på https://c9.io/ eller logga in med ditt befintliga konto.
Välj "Create a new workspace"
Fyll i name på ditt nya workspace
Under rubriken "Clone from Git or Mercurial URL" klistra in följande: 
https://github.com/JuliaSivartsson/laboration2-ruby-1dv450.git

Klicka på "Create workspace"

I terminalfönstret skriver du följande kommandon:
bundle update
rake db:reset


För att starta igång servern skriver du in följande:
sudo service postgresql start
rails s -p $PORT -b $IP

```

Se till så att seeds.rb verkligen körs, annars kommer felmeddelande att visas då användaren admin måste finnas i systemet samt ha id 1.
Admin är den person som har fullständiga rättigheter i applikationen och kan se alla användares registrerade appar samt radera dem.

För att komma åt admin kontot finns följande inloggningsuppgifter:

**Användarnamn:** admin

**Lösenord:** hejsan

Dokumentation om API:et hittar ni här: [API-dokumentation](https://github.com/JuliaSivartsson/laboration2-ruby-1dv450/blob/master/API-dokumentation)

Postman-collection:

```
https://www.getpostman.com/collections/6c39b4ee459566d4c536
```

Vid problem, kontakta mig på: jsigc09@student.lnu.se
