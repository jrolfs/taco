# Description:
#   See who is using staging
#
# Commands:
#   hubot lock :staging | all - locks the staging
#   hubot unlock :staging | all - unlocks the staging
#   hubot stagings - lists lock statuses for all stagings
#   hubot stagings list - lists lock statuses for all stagings
#   hubot stagings add :staging - adds a staging environment to memory
#   hubot stagings remove :staging - removes a staging environment from memory
#   hubot stagings clear - removes all staging environments from memory

Util = require "util"

module.exports = (robot) ->
  robot.respond /stagings add (.*)$/i, (msg) ->
    if msg.match[1]
      stagings = robot.brain.get 'stagings' || {}
      stagings[msg.match[1]] = {}
      robot.brain.set 'stagings', stagings

      msg.send "Added #{msg.match[1]} to memory."

  robot.respond /stagings remove (.*)$/i, (msg) ->
    if msg.match[1]
      stagings = robot.brain.get 'stagings' || {}
      delete stagings[msg.match[1]]
      robot.brain.set 'stagings', stagings

      msg.send "Removed #{msg.match[1]} from memory."

  robot.respond /stagings clear$/i, (msg) ->
    robot.brain.set 'stagings', {}
    msg.send 'All stagings cleared'

  listStagings = (msg) ->
    stagings = robot.brain.get 'stagings' || {}

    if not Object.keys(stagings).length
      response = "I don't know about any stagings."
    else
      responses = []

      for own key, obj of stagings
        if obj.name
          responses.push "#{key} - #{obj.name} @ #{obj.date}"
        else
          responses.push "#{key} - open"

      response = responses.join('\n')

    msg.send response

  robot.respond /stagings list$/i, listStagings
  robot.respond /stagings$/i, listStagings

  robot.respond /lock (.*)$/i, (msg) ->
    stagingName = msg.match[1]
    stagings = robot.brain.get('stagings') || {}

    lockedPacket =
      name: msg.message.user.name
      date: new Date().toString()
      locked: true

    if stagingName != 'all' && not stagings[stagingName]
      msg.send "I don't know about that staging."
      return

    if stagingName != 'all' && stagings[stagingName].locked
      msg.send "That staging is already locked by #{stagings[stagingName].name}."
      return

    if stagingName == 'all'
      for k,v of stagings
        stagings[k] = lockedPacket
    else
      stagings[stagingName] = lockedPacket

    robot.brain.set 'stagings', stagings

    msg.send "I've locked `#{stagingName}` for you #{msg.message.user.name}."

  robot.respond /unlock (.*)$/i, (msg) ->
    stagingName = msg.match[1]
    stagings = robot.brain.get('stagings') || {}

    if stagingName != 'all' && not stagings[stagingName]
      msg.send "I don't know about that staging."
    else

      if stagingName == 'all'
        for k,v of stagings
          stagings[k] = {}
      else
        stagings[stagingName] = {}

      robot.brain.set 'stagings', stagings
      msg.send "I've unlocked `#{stagingName}` for you #{msg.message.user.name}."