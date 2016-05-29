exports.handler = (event, context)->
  context.succeed "hello, #{event.username}!!"
