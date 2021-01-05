# Projekt_Modul_426_151

## Über dieses Projekt

Eine WebApp mit DB-Anbindung zur Zeiterfassung

* FrontEnd: React
* BackEnd: dart
* DB: MongoDB

### Mitarbeiter

* ProductOwner / DevTeam: Severin Hasler
* ScrumMaster / DokuMaster: Melvin Tas
* DevTeam: Jonas Tochtermann

## REST-API

### Request-Headers

Headers:
POST /login HTTP/1.1
Host: localhost:8081
User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:84.0) Gecko/20100101 Firefox/84.0
Accept: application/json, text/plain, */*
Accept-Language: de-CH,de;q=0.8,en;q=0.5,he;q=0.3
Accept-Encoding: gzip, deflate
Content-Type: application/json;charset=utf-8
Content-Length: 37
Origin: http://localhost:3000
DNT: 1
Connection: keep-alive
Referer: http://localhost:3000/login

### Response-Headers

Headers:
HTTP/1.1 403
Vary: Origin
Vary: Access-Control-Request-Method
Vary: Access-Control-Request-Headers
Access-Control-Allow-Origin: *
Access-Control-Expose-Headers: Access-Control-Allow-Headers, Access-Control-Allow-Origin, Access-Control-Expose-Headers, Authorization, Cache-Control, Content-Type, Origin
X-Content-Type-Options: nosniff
X-XSS-Protection: 1; mode=block
Cache-Control: no-cache, no-store, max-age=0, must-revalidate
Pragma: no-cache
Expires: 0
X-Frame-Options: DENY
Content-Length: 0
Date: Thu, 31 Dec 2020 12:21:45 GMT

### Registration

Post-Request:/users/sign-up

```json
{
  "username": "test",
  "email": "ionus@gmx.ch",
  "password": "testtest"
}
```

Response:

```json
{
  "id": 2,
  "username": "test",
  "password": "$2a$10$89/SbddRzcChPVwryDpL2OgM2BQqRZqQ1DKU0o9POkf4.GqhLBye."
}
```

### Login

Post-Request:/login

```json
{
  "username": "test",
  "password": "testtest"
}
```

Response:
Authorization: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0ZXN0IiwiZXhwIjoxNjEwMjkyNDI3fQ.jIEtvAGdjjyHojB9BZ-zy-mfWIgu9r8Rd-Qa13mWr4TFALib2E6TR_FUbliD5s9dOE9uCIU-hx8f4vdGOTYLdw

200
403

### Einträge anzeigen

Get-Request:/entries

```json
[
  {
    "id": 1,
    "checkIn": "2020-03-04T08:00:00",
    "checkOut": "2020-03-04T16:00:00",
    "category": {
      "id": 1,
      "name": "Arbeit"
    },
    "applicationUser":{
      "id": 1,
      "username": "admin",
      "password": "$2a$10$oq4CEIuuePiWqTFS8vDMt.lSqAxUX.yIE64a83T9d/nxwNINy2hyO"
    }
  }
]
```

logout?
