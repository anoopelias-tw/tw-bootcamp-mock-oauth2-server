# Mock OAuth2 server for bootcamp

## Start server

Run the following two commmands:

```
docker build -t tw-bootcamp-mock-oauth2-server .
```

```
docker-compose up
```

The service will start in 8090 port.

## How to use

For user login, we will use Authorization Code flow.

All urls: http://localhost:8090/default/.well-known/openid-configuration

To play with this, use this URL: http://localhost:8090/default/debugger

For login URL as a user:

http://localhost:8090/default/authorize?client_id=debugger&scope=openid+user&response_type=code&response_mode=query&state=1234&nonce=5678&redirect_uri=http%3A%2F%2Flocalhost%3A3000

For login URL as an admin:

http://localhost:8090/default/authorize?client_id=debugger&scope=openid+admin&response_type=code&response_mode=query&state=1234&nonce=5678&redirect_uri=http%3A%2F%2Flocalhost%3A3000

Once login is complete, we should get the code in the callback URL. For example:

http://localhost:3000/?code=fe51AYv1t15OJwZqGBhbCPCo0Z6GL3hSF-x-p7VJDSo&state=1234

## How to generate tokens

To generate tokens, we need to use `/token` endpoint. Sample request below,

```
curl --request POST \
  --url http://localhost:8090/default/token \
  --header 'Authorization: Ym9va3Nob3A6c29tZVNlY3JldA==' \
  --header 'Content-Type: application/x-www-form-urlencoded' \
  --header 'origin: http://localhost:3000' \
  --data code=Jpob93h6_fr89y71ZvW1bM03dZn8u4qqOvPQRKO43Hc \
  --data grant_type=authorization_code \
  --data 'scope=openid user' \
  --data redirect_uri=http://localhost:3000 \
  --data client_id=bookshop
```

Description of important fields:
 - header `Authorization`: Base64 string of `<client_id>:<client_secret>`
 - header `origin`: Will appear in CORS response header.
 - body `code`: The code in the callback URL

Sample response:

```
HTTP/1.1 200 OK
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: http://localhost:3000
Content-Length: 1550
Content-Type: application/json;charset=UTF-8

{
  "token_type" : "Bearer",
  "id_token" : "eyJraWQiOiJkZWZhdWx0IiwidHlwIjoiSldUIiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiJhbm9vcCIsImF1ZCI6ImJvb2tzaG9wIiwibmJmIjoxNzAxMjQ0NzQyLCJyb2xlIjoidXNlciIsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3Q6ODA5MC9kZWZhdWx0IiwiZXhwIjoxNzAxMjQ4MzQyLCJpYXQiOjE3MDEyNDQ3NDIsIm5vbmNlIjoiNTY3OCIsImp0aSI6IjEwYjJmZTE4LWUwMjMtNDhiNS1iOWRhLTkxY2RiMDMyZWQ5NiJ9.mhpaG9HVSqg9nw4cCe1o43mkIrIhuo9adVqJ1ibyCFsTLKG4xP-6ymuXSef5Jzp44li8tIifgIZ2NPHM6qUgPNHoD1BCYIsfAaTLJYFkcKAbVJN58bwJYLk4-gn0bqVoh11R1hqb-TXUcJtNPkYMyQAFgnD_tT69MIbbJLPojahmH2hK8RHBV_gjWRVA_koI2nr_pN0474dNDDmPm9FTD_o02ONTcICUwu-eZxeInp52lAFvX3z92LG2vZG2X17cY-0Pk-xfyvvMOwZfs0FWRyNPo_SR3I6ryClu4k8qHeETz4eTnavsE0vIRoExAYC4sy0bFwZD2cXjssLP4i-G3w",
  "access_token" : "eyJraWQiOiJkZWZhdWx0IiwidHlwIjoiSldUIiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiJhbm9vcCIsIm5iZiI6MTcwMTI0NDc0Miwicm9sZSI6InVzZXIiLCJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjgwOTAvZGVmYXVsdCIsImV4cCI6MTcwMTI0ODM0MiwiaWF0IjoxNzAxMjQ0NzQyLCJub25jZSI6IjU2NzgiLCJqdGkiOiJjM2E2MjQ1MS0yM2QxLTRjNzgtODJiOC02MTllYjAxNjQ5YjMifQ.NHf95AfDLG9gRtvHjc24BZfY6WyvtIXBfetZgRlmceaXIbS3d8cIy8Oh7Z8m50ZWwO_UxmK5ODCY997qvuei29Mxr1Mcb2lC6TNIJEGPhHI0HEGzHXGxYxSOYE6PfadyvPhFHendn3TIluYaM1H4NDUdbu12cNiX--kQmRVbp8K1tQlxiplroy_Otz-jDru58pWWr0zaknNB0jsQd8gALGmYl207HArsw0GkYpSTjEyjEku08yGTxeyc44FckVh5irOQ_BDmgnpH2lnHoLFktewNM8bUWwEsjYJUZVN324_YLq7nIPR-VEhfvrGmAXjgd9Xrps2lG__lc-g_tvRUNQ",
  "refresh_token" : "eyJhbGciOiJub25lIn0.eyJub25jZSI6IjU2NzgiLCJqdGkiOiI2NmYyMzdkYS0wNGUxLTQyZmUtYmYzMi1mMGQzZGZjZWJhY2QifQ.",
  "expires_in" : 3599,
  "scope" : "openid user"
}
```

## How to validate tokens

The JWKS is available  in the URL: http://localhost:8090/default/jwks

To convert to public key, paste JWK into : https://8gwifi.org/jwkconvertfunctions.jsp

To validate go to : https://gchq.github.io/CyberChef/ and use JWT Verify tool. Use `id_token` in the Input and the public key from previous step to verify.

For implementation in Spring, see [this](https://docs.spring.io/spring-security/reference/reactive/oauth2/resource-server/jwt.html) example.
