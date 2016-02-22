#API-Dokumentation
-------------------------------

Baslänk till api-anrop: `https://laboration2-api-juliasivartsson.c9users.io/api/v1/`

Resultatet går att få ut i både json och xml. Json är standard och för att få ut xml lägger du helt enkelt till det i URL-en, se exempel nedan.

vid varje anrop måste en **API nyckel** skickas med, exempel:

`
https://laboration2-api-juliasivartsson.c9users.io/api/v1/restaurants.xml?access_token=PLACERA_API_NYCKEL_HÄR
`

##Restauranger
**Visa alla**

GET https://laboration2-api-juliasivartsson.c9users.io/api/v1/restaurants.xml?access_token=ACCESS_TOKEN

Vid visning av samtliga restaurangen får man även ut vilken position restaurangen har samt vilka taggar den är kopplad till.

--------------

**Visa en**

GET https://laboration2-api-juliasivartsson.c9users.io/api/v1/restaurants/:restaurantId.xml?access_token=ACCESS_TOKEN

Vid visning av en specifik restaurang får man även ut vilken position restaurangen har samt vilka taggar den är kopplad till.

--------------

*OBS! Resterande anrop för restauranger kräver autentisering*

**Skapa**

Följande egenskaper måste vara närvarande för att anropet ska godkännas:
* name
* message
* rating
* position

POST https://laboration2-api-juliasivartsson.c9users.io/api/v1/restaurants.xml?access_token=ACCESS_TOKEN

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

PUT https://laboration2-api-juliasivartsson.c9users.io/api/v1/restaurants/:restaurantId.xml?access_token=ACCESS_TOKEN

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

DELETE https://laboration2-api-juliasivartsson.c9users.io/api/v1/restaurants/:restaurantId.xml?access_token=ACCESS_TOKEN

--------------

##Taggar
**Visa alla**

GET https://laboration2-api-juliasivartsson.c9users.io/api/v1/tags.xml?access_token=ACCESS_TOKEN

Vid visning av samtliga taggar får man även ut vilka restauranger som är kopplade till respektive tagg.

--------------

**Visa en**

GET https://laboration2-api-juliasivartsson.c9users.io/api/v1/tags/:tagId.xml?access_token=ACCESS_TOKEN

Vid visning av en specifik tagg får man även ut vilka restauranger som är kopplade till taggen.

--------------

*OBS! Resterande anrop för taggar kräver autentisering*

**Skapa**

POST https://laboration2-api-juliasivartsson.c9users.io/api/v1/tags.xml?access_token=ACCESS_TOKEN

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

PUT https://laboration2-api-juliasivartsson.c9users.io/api/v1/tags/:tagId.xml?access_token=ACCESS_TOKEN

```
{
    "tag": {
        "name": "#evenmoreawesomefood"
    }
}
```

--------------

**Radera**

DELETE https://laboration2-api-juliasivartsson.c9users.io/api/v1/tags/:tagId.xml?access_token=ACCESS_TOKEN

--------------

##Platser
**Visa alla**

GET https://laboration2-api-juliasivartsson.c9users.io/api/v1/positions?access_token=ACCESS_TOKEN

Vid visning av samtliga platser får man även ut vilka restauranger som finns på respektiva plats.

--------------

**Visa en**

GET https://laboration2-api-juliasivartsson.c9users.io/api/v1/positions/:positionId.xml?access_token=ACCESS_TOKEN

Vid visning av en specifik position får man även ut vilka restauranger som finns på platsen.

--------------

*OBS! Resterande anrop för platser kräver autentisering*

POST https://laboration2-api-juliasivartsson.c9users.io/api/v1/positions?access_token=ACCESS_TOKEN

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

PUT https://laboration2-api-juliasivartsson.c9users.io/api/v1/tags/:tagId.xml?access_token=ACCESS_TOKEN
```
{
    "position": {
        "address": "Värendsgatan 1 Lammhult"
    }
}
```

--------------

**Radera**

DELETE https://laboration2-api-juliasivartsson.c9users.io/api/v1/positions/:positionId.xml?access_token=ACCESS_TOKEN

--------------
