request = require 'supertest'
app = require '../app/app.coffee'

describe 'GET /', ->
  it 'will 404', (done)->
    request app
      .get '/'
      .expect 404, done

describe 'GET /users/foo', ->
  it 'will 200', (done)->
    request app
      .get '/users/foo'
      .expect 200
      .expect '"hello, foo!"', done

describe 'GET /usery/foo', ->
  it 'will 200', (done)->
    request app
      .get '/usery/foo'
      .expect 200
      .expect '"Oy, foo!"', done
