# BleacherReport

A MicroService that stores cache of user actions using OTPs ETS. The service exposes two endpoints.

- `GET /` for Health checks
- `POST /api/reaction` for updating reactions
- `GET /api/reaction_counts/{content_id}` for getting current reactions on an content_id

## Generate Token

Get an interactive shell

```shell
iex -S mix
```

Then generate toke

```shell
Elixir|iex|2▶ BleacherReport.Auth.Token.gen_token("me")
"SFMyNTY.g3QAAAACZAAEZGF0YW0AAAACbWVkAAZzaWduZWRuBgArTyP4bwE.abaBU4v4R8xKYSVdLmpBzQYKHE4Ju6s3upU5dj74PB8"
Elixir|iex|3▶
```

## New user reaction

```shell
curl -X POST \
  http://localhost:4000/api/reaction \
  -H 'Accept: */*' \
  -H 'Accept-Encoding: gzip, deflate' \
  -H 'Cache-Control: no-cache' \
  -H 'Connection: keep-alive' \
  -H 'Content-Length: 61' \
  -H 'Content-Type: application/json' \
  -H 'Host: localhost:4000' \
  -H 'Postman-Token: f6fa682c-5dfb-4d0d-bb06-dfac30ac5175,88453e0e-2db2-4d7c-b922-4d7222e23c42' \
  -H 'User-Agent: PostmanRuntime/7.15.2' \
  -H 'api-token: SFMyNTY.g3QAAAACZAAEZGF0YW0AAAACbWVkAAZzaWduZWRuBgArTyP4bwE.abaBU4v4R8xKYSVdLmpBzQYKHE4Ju6s3upU5dj74PB8' \
  -H 'cache-control: no-cache' \
  -d '{
	"action": "added",
	"content_id": "333",
	"user_id": "3"
}'
```

### Response 

```json
{
    "data": "ok"
}
```

## Get count of reactions on a content id

```shell
curl -X GET \
  http://localhost:4000/api/reaction_counts/333 \
  -H 'Accept: */*' \
  -H 'Accept-Encoding: gzip, deflate' \
  -H 'Cache-Control: no-cache' \
  -H 'Connection: keep-alive' \
  -H 'Content-Length: 48' \
  -H 'Content-Type: application/json' \
  -H 'Host: localhost:4000' \
  -H 'Postman-Token: a6c6a10a-5302-42cd-9a58-7dc2f9ef9495,762d596b-2bcf-47c4-831b-7957ed05dd45' \
  -H 'User-Agent: PostmanRuntime/7.15.2' \
  -H 'api-token: SFMyNTY.g3QAAAACZAAEZGF0YW0AAAACbWVkAAZzaWduZWRuBgArTyP4bwE.abaBU4v4R8xKYSVdLmpBzQYKHE4Ju6s3upU5dj74PB8' \
  -H 'cache-control: no-cache'
```

### Response

```json
{
    "data": {
        "content_id": "333",
        "reaction_count": {
            "fire": 1
        }
    }
}
```