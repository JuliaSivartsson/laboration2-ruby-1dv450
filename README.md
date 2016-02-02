Jag hade en hel del problem med att få upp min laboration på webben, även om jag använder mig av Cloud9 där det genereras en URL så ville jag lära mig lite om hur Heroku fungerar. Lättare sagt än gjort.
Det slutade med att jag gjorde om hela min laboration, och fick på så sätt göra ett nytt repo, så för original commits kolla gärna [1dv450-laboration1 repository](https://github.com/JuliaSivartsson/1dv450-laboration1).

Vad jag gjort efter att jag flyttade över koden var att ändra databas från mysql till postsql då Heroku inte verkade godkänna något annat (jag fick det inte att fungera i alla fall).
Så jag kommer här nedan att länka till Heroku url-en samt Cloud9, ifall något skulle gå fel med Heroku.

Heroku: [laboration1-Heroku](https://evening-wildwood-30690.herokuapp.com)

Cloud9: [laboration1-Cloud9](https://testforheroku-juliasivartsson.c9users.io/)

##Viktigt

Om applikationen körs på egen maskin, finns det två viktiga steg för att få den att fungera.
* Kör **bundle install**
* **rake db:migrate**
* **rake db:seed**

Körs ingen seed kommer felmeddelande att visas då användaren admin måste finnas i systemet samt ha id 1.
Vid problem, kontakta mig på: jsigc09@student.lnu.se
