# Description:
#   Inspect the data in redis easily
#
# Commands:
#   hubot show users - Display all users that hubot knows about
#   hubot show storage - Display the contents that are persisted in the brain


Util = require "util"

module.exports = (robot) ->
  robot.respond /show storage$/i, (msg) ->
    output = Util.inspect(robot.brain.data, false, 4)
    msg.send output

  robot.respond /show users$/i, (msg) ->
    response = ""

    for own key, user of robot.brain.data.users
      response += "#{user.id} #{user.name}"
      response += " <#{user.email_address}>" if user.email_address
      response += "\n"

    msg.send response

  robot.respond /did you know (.*)about (.*)/i, (msg) ->
    fact = msg.match[1]
    article = msg.match[2]

    if not (facts = robot.brain.get('facts'))
      robot.brain.set('facts', {})

    brain_article = facts[article]

    if brain_article
      brain_fact = brain_article[brain_article.indexOf(fact) > -1]
      if brain_fact
        output = 'Yeah I know that ' + brain_fact
      else
        facts[article].push(fact)
        output = 'I did not know ' + fact
    else
      facts[article] = []
      facts[article].push(fact)
      output = 'I did not know anything about ' + article + '. Thanks now I know ' + fact

    robot.brain.set 'facts', facts
    msg.send output

  robot.respond /tell me something about (.*)/i, (msg) ->
    article = msg.match[1]

    if not (facts = robot.brain.get('facts'))
      robot.brain.set('facts', {})

    brain_article = facts[article]

    if brain_article
      random_brain_fact = brain_article[Math.floor(Math.random()*brain_article.length)];
      output = "Did you know " + random_brain_fact
    else
      output = 'I do not know anything about ' + article

    msg.send output

  robot.respond /clear facts$/i, (msg) ->
    username = msg.message.user.name
    isOps = username.toLowerCase().indexOf('jon bardin') != -1
    isBen = username.toLowerCase().indexOf('ben nappier') != -1

    if isOps || isBen
      robot.brain.set('facts', {})
