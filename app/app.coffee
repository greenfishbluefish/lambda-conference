'use strict'

express = require 'express'
agl = require 'api-gateway-localdev'

app = agl express(), [
  {
    lambda: require('./lambda').handler,
    method: 'GET',
    path: '/users/{username}',
    responses:
      "200":
        "responseTemplates": {},
        "responseModels": {}
      "404":
        "selectionPattern": ".*404.*",
        "responseTemplates": {},
        "responseModels": {}
    requestTemplates:
      'application/json': '{"username":"$input.params(\'username\')"}',
  },
]

app.listen process.env.PORT, ()->
  console.log("listening on #{process.env.PORT}")
