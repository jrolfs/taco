# Description:
# Grumpycat doesn't put up with it
#
# Commands:
# hubot grump me - Receive a grumpycat

module.exports = (robot) ->

  robot.respond /grump me/i, (msg) ->
    msg.send "http://i.imgur.com/Cxagv.jpg"
