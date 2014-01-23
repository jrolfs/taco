# Description:
#   See who is using staging
#
# Commands:
#   hubot staging

Util = require "util"

module.exports = (robot) ->
  robot.respond /stagings list$/i, (msg) ->
    stagings = robot.brain.get 'stagings' || {}
    response = ""

    if not Object.keys(stagings).length
      response = "I don't know about any stagings."
    else
      for own key, obj of stagings
        if obj.locked
          response += "#{key} - #{obj.name} @ #{obj.date}"
        else
          response += "#{key} - open"

    msg.send response

  # robot.hear /deploying to (staging\d+)/, (msg) ->
  #   stagingName = msg.match[1]
  #   stagings = robot.brain.get('stagings') || {}

  #   if staging = stagings[stagingName] && staging.locked
  #     if staging.name != msg.message.user.name
  #       msg.send "#{stagingName} is currently locked by #{staging.name}"

  robot.respond /stagings lock (.*)$/i, (msg) ->
    stagingName = msg.match[1]
    stagings = robot.brain.get('stagings') || {}

    stagings[stagingName] =
      name: msg.message.user.name
      locked: true
      date: new Date().toString()

    robot.brain.set 'stagings', stagings

    msg.send "I've locked #{stagingName} for you #{msg.message.user.name}."

  robot.respond /stagings unlock (.*)$/i, (msg) ->
    stagingName = msg.match[1]
    stagings = robot.brain.get('stagings') || {}

    if not stagings[stagingName]
      msg.send "I don't know that staging."
    else
      stagings[stagingName].locked = false
      robot.brain.set 'stagings', stagings
      msg.send "I've unlocked #{stagingName} for you #{msg.message.user.name}."