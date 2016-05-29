'use strict'

express = require 'express'
agl = require 'api-gateway-localdev'
_ = require 'lodash'

app = agl express(), [
  _.extend require('./routes/lambda.json'),
    lambda: require('./routes/lambda.coffee').handler
  _.extend require('./routes/lambda2.json'),
    lambda: require('./routes/lambda2.coffee').handler
]

app.listen process.env.PORT, ()->
  console.log("listening on #{process.env.PORT}")
