# Description:
#   Silly call and responses
#
# Commands:
#   hubot die - End hubot process

module.exports = (robot) ->
  robot.respond /WELCOME BACK$/i, (msg) ->
    msg.send "Glad to be here"

  robot.respond /wa(z+)up/i, (msg) ->
    msg.send ("wa" + (Array((2 + msg.match[1].lastIndexOf('z')) * 4).join("z")) + "up")

  robot.respond /(.*)love (.*)/i, (msg) ->
    msg.send "OOOMMMMMGGGGG I LOOOOOOOOOOOOOOVVEEEEE " + (msg.match[2]) + " SO MUCH"

  robot.respond /DIE$/i, (msg) ->
    msg.send "Goodbye, cruel world."
    process.exit 0

  robot.respond /GOOD MORNING$/i, (msg) ->
    msg.send "Good Morning #{msg.message.user.name}"
