'use strict'

_ = require 'lodash'
agl = require 'api-gateway-localdev'
express = require 'express'
glob = require 'glob'
path = require 'path'

glob "#{__dirname}/routes/**/*.coffee", (err, files)->
  routes = []
  files.forEach (filename)->
    file = path.parse filename
    routes.push _.extend require("#{file.dir}/#{file.name}.json"),
      lambda: require(filename).handler

  agl(express(), routes).listen process.env.PORT, ()->
    console.log("listening on #{process.env.PORT}")
