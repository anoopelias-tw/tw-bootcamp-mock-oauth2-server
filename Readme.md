# Mock OAuth2 server for bootcamp

## Start server

Run the following two commmands:

```
$ docker build -t tw-bootcamp-mock-oauth2-server .
```

```
$ docker-compose up
```

The service will start in 8090 endpoint.

## How to use

For user login, we will use Authorization Code flow.

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

Description of some fields:
 - header `Authorization`: Base64 string of `client_id:client_secret`
 - header `origin`: Will appear in CORS response header.
 - body `code`: The code in the callback URL


