# Mock OAuth2 server for bootcamp

## Start server

Run the following two commmands:

```
docker build -t tw-bootcamp-mock-oauth2-server .
```

```
docker-compose up
```

The service will start in 8090 endpoint.

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
  --data code=vOH4XPs_8DTg38OtgUnNTDX9FGPPopObl6rZ2WjWjFo \
  --data grant_type=authorization_code \
  --data 'scope=openid user' \
  --data redirect_uri=http://localhost:3000 \
  --data client_id=bookshop
```

Description of important fields:
 - header `Authorization`: Base64 string of `client_id:client_secret`
 - header `origin`: Will appear in CORS response header.
 - body `code`: The code in the callback URL

Sample response:

```
HTTP/1.1 200 OK
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: http://localhost:3000
Content-Length: 1406
Content-Type: application/json;charset=UTF-8

{
  "token_type" : "Bearer",
  "id_token" : "eyJraWQiOiJkZWZhdWx0IiwidHlwIjoiSldUIiwiYWxnIjoiUlMyNTYifQ.eyJhdWQiOiJib29rc2hvcCIsIm5iZiI6MTcwMTI0MTUwNSwicm9sZSI6InVzZXIiLCJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjgwOTAvZGVmYXVsdCIsImV4cCI6MTcwMTI0NTEwNSwiaWF0IjoxNzAxMjQxNTA1LCJqdGkiOiI5ZWIzZWQ0OC1hYmE1LTQ3NjUtOTgxZC1lMjk0N2NjZmE4NjQifQ.lHkYSaCD9mn-U0w6zf9KfmjDi5HlQV5_FN-tLJeynEjn0CyALt-4PJfZusIhgZPGAU9v71UB5JyMNLOCfzCsqQ8aF6OUTSOI0TIRj5czJN8P2h98nVhHfNs-PkTd4c6B4NJ6b9LkD3n1mPq5qTWEMEGWRI-M7E2j_UyuZzU5ckiaImS6uiSgrnKQI-M5RGz2dPOGmB6m2nyMvLjBOABDK3VJPcu9Q0lL-IxYns5VpiGDLl5ZLQyt0TAYrDVmxUtLGl8yWi5ctyqsvFJAb_ax5MOq6ark8NYnnUKbvfB2lUoTmldw7goEXTFlQa9QNI_Olvv61QY2jIwpWHw-kUkFxQ",
  "access_token" : "eyJraWQiOiJkZWZhdWx0IiwidHlwIjoiSldUIiwiYWxnIjoiUlMyNTYifQ.eyJuYmYiOjE3MDEyNDE1MDUsInJvbGUiOiJ1c2VyIiwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo4MDkwL2RlZmF1bHQiLCJleHAiOjE3MDEyNDUxMDUsImlhdCI6MTcwMTI0MTUwNSwianRpIjoiY2MwMDE3N2UtOWUyYy00NWY2LWI5OTEtN2Q3YjE3Y2E4NGNjIn0.Xc9ocLXqm1UZMNkmBkAldFxzUR__tHLIis72ry4r2d8IVPggUzd8oR5wG_cUfGhDb7dQ9ceORODvpuy0mCSV-_-YC7m5K94HuJrR45JQGk7kWqWWoA8BVeNFxxI4uXcQfH32C-UCkXeUe7-JnJeajaqRT3sPMh2Tn6JJU4XzBk6AUB4QUfdoVJMRFkA39Q-k6qGnUINkdiw2p6oIQtJwL2de7WLVBtTTRyMa9fXP8WSWYYfQxQG7uB8YOmjIAGKJNcquvytbE4LVxKn7w-murzh4fHlLOjdnnpNzlbNKQyuwOsUrlG3Ljm-Oyaf7XzW96tSUr1UfOQ0dlTn_fRWadA",
  "refresh_token" : "6db7e327-feb1-47df-95f7-2da330126a62",
  "expires_in" : 3599,
  "scope" : "openid user"
}
```

## How to validate tokens

The JWKS is available  in the URL: http://localhost:8090/default/jwks

To convert to public key, paste JWK into : https://8gwifi.org/jwkconvertfunctions.jsp

To validate go to : https://gchq.github.io/CyberChef/ and use JWT Verify tool. Use `id_token` in the Input and the public key from previous step to verify.

For implementation in Spring, see [this](https://docs.spring.io/spring-security/reference/reactive/oauth2/resource-server/jwt.html) example.
