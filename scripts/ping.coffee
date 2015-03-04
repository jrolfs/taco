# Description:
#   Utility commands surrounding Hubot uptime.
#
# Commands:
#   hubot ping - Reply with pong
#   hubot echo <text> - Reply back with <text>
#   hubot time - Reply with current time
#   hubot die - End hubot process

module.exports = (robot) ->
  robot.respond /PING$/i, (msg) ->
    msg.send "PONG"

  robot.respond /WELCOME BACK$/i, (msg) ->
    msg.send "Glad to be here"

  robot.respond /ECHO (.*)$/i, (msg) ->
    msg.send msg.match[1]

  robot.respond /TIME$/i, (msg) ->
    msg.send "Server time is: #{new Date()}"

  robot.respond /wa(z+)up/i, (msg) ->
    msg.send ("wa" + (Array((2 + msg.match[1].lastIndexOf('z')) * 4).join("z")) + "up")

  robot.respond /(.*)love slack(.*)/i, (msg) ->
    msg.send "OOOMMMMMGGGGG I LOOOOOOOOOOOOOOVVEEEEE IT SO MUCH"

  robot.respond /DIE$/i, (msg) ->
    msg.send "Goodbye, cruel world."
    process.exit 0
