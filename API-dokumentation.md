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

**Visa en**

OBS! Följande anrop kräver autentisering

**Skapa**

Exempel för att skapa en restaurang med tillhörande taggar samt en position:


`
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
`

**Uppdatera**

**Radera**

##Taggar
**Visa alla**

**Visa en**

OBS! Följande anrop kräver autentisering

**Skapa**

**Uppdatera**

**Radera**

##Platser
**Visa alla**

**Visa en**

OBS! Följande anrop kräver autentisering

**Skapa**

**Uppdatera**

**Radera**
