#API-Dokumentation
-------------------------------

##Allmän information

Api-et finns att nå på två ställen, rekommenderat är Heroku api-et som går att nå på följande länk:

**Baslänk till api-anrop på heroku: `https://limitless-falls-33806.herokuapp.com/api/v1/`**

Om någonting skulle gå fel (alla buggar bör vara undanröjda) så finns Cloud9 att tillgå:

**Baslänk till api-anrop på Cloud9: `https://laboration2-api-juliasivartsson.c9users.io/api/v1/`**

Resultatet går att få ut i både json och xml. Json är standard och för att få ut xml lägger du helt enkelt till det i URL-en, se exempel nedan.

##API-nyckel

vid varje anrop måste en **API nyckel** skickas med, exempel:

`
https://limitless-falls-33806.herokuapp.com/api/v1/restaurants.xml?access_token=PLACERA_API_NYCKEL_HÄR
`

Nyckel skaffar du genom att skapa en användare på på [applikationens hemsida](https://limitless-falls-33806.herokuapp.com/api/v1/), loggar in och lägger till en ny app för din användare. En Api-nyckel kommer då att genereras som du kan använda dig av vid anrop mot api-et.

##Autentisering

För att få tillgång till CRUD funktionalitet behövs autentisering mot API-et, detta görs genom följande anrop:

POST https://limitless-falls-33806.herokuapp.com/knock/auth_token

Giltlig email och password måste skickas med i anropet, det finns ett testkonto att använda sig av vilket är:

* Email: **itzy_90@hotmail.com**
* Lösenord: **hejsan**

Exempel:

```
{"auth": {"email": "itzy_90@hotmail.com", "password": "hejsan"}}
```

En JWT Token kommer att generas och skickas tillbaka i responsen, kopiera denna och skicka med i headern vid ditt anrop till Api-et.

Exempel:

**Authorization: AUTH_TOKEN**

##Limit & offset

Det går att ställa in limit och offset.

Limit = Hur många ska hämtas ut, default är 20.
Offset = Hur långt från start ska hämtningen börja, default är 0.

Exempel:

GET https://limitless-falls-33806.herokuapp.com/api/v1/restaurants?limit=2&offset=3&access_token=ACCESS_TOKEN

Detta går att göra vid visning av alla restauranger, positioner, taggar samt vid visning av närliggande platser.

----------------------

##Restauranger
**Visa alla**

GET https://limitless-falls-33806.herokuapp.com/api/v1/restaurants.xml?access_token=ACCESS_TOKEN

Vid visning av samtliga restaurangen får man även ut vilken position restaurangen har samt vilka taggar den är kopplad till.

--------------

**Visa en**

GET https://limitless-falls-33806.herokuapp.com/api/v1/restaurants/:restaurantId.xml?access_token=ACCESS_TOKEN

Vid visning av en specifik restaurang får man även ut vilken position restaurangen har samt vilka taggar den är kopplad till.

--------------
**Sök med query**

GET https://limitless-falls-33806.herokuapp.com/api/v1/restaurants.xml?query=mamma&access_token=ACCESS_TOKEN

Detta kommer att söka efter restauranger i applikationen som innehåller "mamma" antingen som name, message eller rating.

--------------

*OBS! Resterande anrop för restauranger kräver autentisering*

**Skapa**

Följande egenskaper måste vara närvarande för att anropet ska godkännas:
* name
* message
* rating
* position

POST https://limitless-falls-33806.herokuapp.com/api/v1/restaurants.xml?access_token=ACCESS_TOKEN

Exempel för att skapa en restaurang med tillhörande taggar samt en position:


```
{
    "restaurant": {
        "name": "Dalek's Diner",
        "message": "Exterminate!",
        "rating": "5",
    
        "tags": [
            {"name": "#doctorwho"},
            {"name": "#awesome"}
        ],
    
        "position": {
            "address": "Storgatan 1 Växjö"
        }
    }
}
```

--------------

**Uppdatera**

PUT https://limitless-falls-33806.herokuapp.com/api/v1/restaurants/:restaurantId.xml?access_token=ACCESS_TOKEN

Exempel:

```
{
    "restaurant": {
        "name": "Min nya restaurang",
        "message": "Nytt namn, ny look",
        "rating": "4"
    }
}
```

--------------

**Radera**

DELETE https://limitless-falls-33806.herokuapp.com/api/v1/restaurants/:restaurantId.xml?access_token=ACCESS_TOKEN

--------------

##Taggar
**Visa alla**

GET https://limitless-falls-33806.herokuapp.com/api/v1/tags.xml?access_token=ACCESS_TOKEN

Vid visning av samtliga taggar får man även ut vilka restauranger som är kopplade till respektive tagg.

--------------

**Visa en**

GET https://limitless-falls-33806.herokuapp.com/api/v1/tags/:tagId.xml?access_token=ACCESS_TOKEN

Vid visning av en specifik tagg får man även ut vilka restauranger som är kopplade till taggen.

--------------

*OBS! Resterande anrop för taggar kräver autentisering*

**Skapa**

POST https://limitless-falls-33806.herokuapp.com/api/v1/tags.xml?access_token=ACCESS_TOKEN

Följande egenskaper måste vara närvarande för att anropet ska godkännas:
* name

Exempel:

```
{
    "tag": {
        "name": "#awesomefood"
    }
}
```

--------------

**Uppdatera**

PUT https://limitless-falls-33806.herokuapp.com/api/v1/tags/:tagId.xml?access_token=ACCESS_TOKEN

```
{
    "tag": {
        "name": "#evenmoreawesomefood"
    }
}
```

--------------

**Radera**

DELETE https://limitless-falls-33806.herokuapp.com/api/v1/tags/:tagId.xml?access_token=ACCESS_TOKEN

--------------

##Platser
**Visa alla**

GET https://limitless-falls-33806.herokuapp.com/api/v1/positions?access_token=ACCESS_TOKEN

Vid visning av samtliga platser får man även ut vilka restauranger som finns på respektiva plats.

--------------

**Visa en**

GET https://limitless-falls-33806.herokuapp.com/api/v1/positions/:positionId.xml?access_token=ACCESS_TOKEN

Vid visning av en specifik position får man även ut vilka restauranger som finns på platsen.

--------------

**Visa närliggande restauranger**

Att läsa ut närliggande platser med restauranger går att göra på tre sätt i api-et.

**Alternativ 1:**

Via address

GET https://limitless-falls-33806.herokuapp.com/api/v1/restaurants?address_and_city=Storgatan1Växjö.xml&access_token=ACCESS_TOKEN

**Alternativ 2:**

Via longitude och latitude

GET https://limitless-falls-33806.herokuapp.com/api/v1/restaurants?longitude=:longitude&latitude=:latitude.xml&access_token=ACCESS_TOKEN

**Alternativ 3:**

GET https://limitless-falls-33806.herokuapp.com/api/v1/positions/nearby/:longitude/:latitude.xml?access_token=ACCESS_TOKEN

OBS! Tänk på att longitude och latitude måste skrivas med komma (,) och inte punkt (.) i url-en. Tillexempel:

GET https://limitless-falls-33806.herokuapp.com/api/v1/positions/nearby/14,5860588/57,1650635.xml?access_token=ACCESS_TOKEN

Vid visning av platser i närheten får man även ut de restauranger som finns på närliggande platser samt hur långt ifrån sökningen som platsen ligger.

--------------

*OBS! Resterande anrop för platser kräver autentisering*

POST https://limitless-falls-33806.herokuapp.com/api/v1/positions?access_token=ACCESS_TOKEN

**Skapa**

Följande egenskaper måste vara närvarande för att anropet ska godkännas:
* address

Exempel:
```
{
    "position": {
        "address": "Storgatan 1 Växjö"
    }
}
```

--------------

**Uppdatera**

PUT https://limitless-falls-33806.herokuapp.com/api/v1/positions/:positionId.xml?access_token=ACCESS_TOKEN
```
{
    "position": {
        "address": "Värendsgatan 1 Lammhult"
    }
}
```

--------------

**Radera**

DELETE https://limitless-falls-33806.herokuapp.com/api/v1/positions/:positionId.xml?access_token=ACCESS_TOKEN

--------------
