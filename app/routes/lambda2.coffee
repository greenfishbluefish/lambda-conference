exports.handler = (event, context)->
  context.succeed "Oy, #{event.username}!"
