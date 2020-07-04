# README

## Build
```
docker-compose build
```

## Set up database
```
docker-compose run web rails db:setup
```

## Run tests
```
docker-compose run -e "RAILS_ENV=test" web rspec
```

## Import merchants & admins
The list of imported user email with their passwords will be displayed.
```
docker-compose run web rake import:merchants FILE=db/merchants.csv
docker-compose run web rake import:admins FILE=db/admins.csv
```

## Start the app
```
docker-compose up
```

### Authorize transaction

```
curl -u user:password 'http://0.0.0.0:3000/api/payments' -X POST \
  -H 'Content-Type: application/json' \
  --data-raw '{ "merchant_email": "merchant@example.com",
    "transaction_type": "authorize",
    "transaction_params": { "customer_email": "customer@example.com", "amount": 12 } }'
```

### Charge/Refund/Reveral transaction

Change *transaction_type* to 'charge', 'refund' or 'reveral' accordingly:
```
curl -u user:password 'http://0.0.0.0:3000/api/payments' -X POST \
  -H 'Content-Type: application/json' \
  --data-raw '{ "merchant_email": "merchant@example.com",
    "transaction_type": "charge",
    "transaction_params": { "reference_id": "d31da0e2-b99c-4532-aa6c-b92c31b9575f" } }'
```
