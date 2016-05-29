'use strict'

_ = require 'lodash'
agl = require 'api-gateway-localdev'
express = require 'express'
glob = require 'glob'
path = require 'path'

routes = []
glob.sync("#{__dirname}/routes/**/*.coffee").forEach (filename)->
#  files.forEach (filename)->
  file = path.parse filename
  routes.push _.extend require("#{file.dir}/#{file.name}.json"),
    lambda: require(filename).handler

module.exports = app = agl(express(), routes)
app.listen process.env.PORT, ()->
  console.log("Listening on #{process.env.PORT}")
