# Description:
#   See who is using staging
#
# Commands:
#   hubot lock :staging | all - locks the staging
#   hubot lock :staging with:subject for:assignee | `with:subject`, `for:assignee` are optional, but should be in this order
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
          subjectMsg = if obj.subject then " with:#{obj.subject}" else ''
          responses.push "#{key} - #{obj.name} @ #{obj.date}#{subjectMsg}"
        else
          responses.push "#{key} - open"

      response = responses.join('\n')

    msg.send response

  robot.respond /stagings list$/i, listStagings
  robot.respond /stagings$/i, listStagings

  robot.respond /commandeer (.*)$/i, (msg) ->
    stagingName = msg.match[1]
    stagings = robot.brain.get('stagings') || {}
    username = msg.message.user.name
    isOps = username.toLowerCase().indexOf('jon bardin') != -1

    if isOps
      lockedPacket =
        name: username
        date: new Date().toString()
        locked: true

      stagings[stagingName] = lockedPacket

      robot.brain.set 'stagings', stagings
      msg.send "I've locked `#{stagingName}` for you #{msg.message.user.name}."
    else
      msg.send "#{msg.message.user.name} you are not the O.P.S."

  robot.respond /lock (staging\d{1,3})( with:\w+)?( for:.+)?$/i, (msg) ->
    stagingName = msg.match[1]
    subject = msg.match[2]
    assignee = msg.match[3]

    subject = subject.split(' with:')[1] if subject
    assignee = assignee.split(' for:')[1] if assignee

    stagings = robot.brain.get('stagings') || {}

    username = msg.message.user.name
    username = assignee if assignee

    lockedPacket =
      name: username
      date: new Date().toString()
      locked: true
      subject: subject

    if stagingName != 'all' && not stagings[stagingName]
      msg.send "I don't know about that staging."
      return

    if stagingName != 'all' && stagings[stagingName].locked && stagings[stagingName].name != username
      msg.send "That staging is already locked by #{stagings[stagingName].name}."
      return

    if stagingName == 'all'
      for k,v of stagings
        stagings[k] = lockedPacket
    else
      stagings[stagingName] = lockedPacket

    robot.brain.set 'stagings', stagings

    subjectMsg = if subject then " with:#{subject}" else ''
    msg.send "I've locked `#{stagingName}` for:#{username}#{subjectMsg}."

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
