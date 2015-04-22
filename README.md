# Jekll-Store/Microservice

[![Build Status](https://travis-ci.org/jekyll-store/microservice.svg?branch=master)](https://travis-ci.org/jekyll-store/microservice)

Jekyll-Store Microservice is a [Sinatra](https://github.com/sinatra/sinatra) based application. It exposes two POST and two GET routes:

* `/purchase` - (POST) Request to process a purchase.
* `/reset` - (POST) Request to update resources.
* `/test-mail` - (GET) Request to send test email to errors address.
* `/ping` - (GET) Notice to check response and to wake up from idle.

The `/purchase` route expects a JSON object of the following form:

```json
{
  "basket": { "bag": 3, "shoe": 2 },
  "customer": {
    "name": "George Hendrix",
    "email": "ggtop45@example.com"
  },
  "address": {
    "address1": "45 Station Road",
    "address2": "",
    "city": "Shrovesbury",
    "county": "Wessex",
    "country": "LK",
    "postcode": "WE34 9DU"
  },
  "delivery": "Express",
  "token": "FIFJ3453GFH56",
  "currency": "GBP",
  "total": "37.9"
}
```

It then will check that the basket and delivery method adds up to the total. If everything checks out, it processes the payment. If successful, it will email the store manager the details of the purchase, a confirmation email will be sent to the customer and a generated order number will be sent back, with a 200 status, in response to the original request.

If at any point this fails, an error message will be sent back to the original request and the details of the error will be sent to errors email address.

As there is no database, the emails are the only record of the purchases. It is recomended that they are archived safely.

## Environment Variables

To config, use the following environment variables:

* `JSM_FRONT_URL` - The URL of your Jekyll-Store Front instance, (or similar).
* `JSM_PURCHASES_EMAIL` - The email address to send purchase details.
* `JSM_ERRORS_EMAIL` - The email address to send errors details.
* `JSM_PAYMENT_METHOD` - The name of the payment gateway interface.

Currently available payment methods:

  * `paymill`

Gateway specific:

* `JSM_PAYMILL_PRIVATE_KEY` - [Paymill private key](https://developers.paymill.com/en/introduction/your-account/)

Mailer options:

* `JSM_SMTP_HOST` - Host
* `JSM_SMTP_ADDRESS` - Address
* `JSM_SMTP_PORT` - Port
* `JSM_SMTP_USER` - Username
* `JSM_SMTP_PASS` - Password
* `JSM_SMTP_DOMAIN` - Domain
* `JSM_SMTP_AUTH` - Authentication
* `JSM_SMTP_START_TLS_AUTO` - Enable STARTTLS Auto

## Contributing

1. [Fork it](https://github.com/jekyll-store/microservice/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
