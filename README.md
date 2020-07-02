# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

Authorize transaction:
```
curl -u user:password 'http://localhost:3000/api/payments' -X POST \
  -H 'Content-Type: application/json' \
  --data-raw '{ "merchant_email": "merchant@example.com",
    "transaction_type": "authorize",
    "transaction_params": { "customer_email": "customer@example.com", "amount": 12 } }'
```

Charge transaction:
```
curl -u user:password 'http://localhost:3000/api/payments' -X POST \
  -H 'Content-Type: application/json' \
  --data-raw '{ "merchant_email": "merchant@example.com",
    "transaction_type": "charge",
    "transaction_params": { "reference_id": "d31da0e2-b99c-4532-aa6c-b92c31b9575f" } }'
```
