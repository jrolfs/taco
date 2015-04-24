# Description:
#   Get a link to an AWS account console
#
# Commands:
#   hubot aws console :name
#   hubot aws consoles - lists all of the console links

Util = require "util"
https = require "https"

module.exports = (robot) ->
  robot.respond /aws console (.*)$/i, (msg) ->
    accountName = msg.match[1]
    accountLink = "https://#{accountName}.signin.aws.amazon.com/console"
    msg.send "#{accountLink}"

  listAwsLinks = (msg) ->
    accountLinks = {
      "mavenlink": "Billing/Core",
      "mavenlink-prod": "Production",
      "mavenlink-staging": "Staging",
      "mavenlink-demo": "Demo",
      "mavenlink-corp": "Corp",
      "mavenlink-dev": "Dev"
    }

    if not Object.keys(accountLinks).length
      response = "I don't know about any AWS consoles."
    else
      responses = []

      for key, name of accountLinks
        responses.push "#{name}: https://#{key}.signin.aws.amazon.com/console"

      response = responses.join('\n')
    msg.send response

  robot.respond /aws consoles list$/i, listAwsLinks
  robot.respond /aws consoles/i, listAwsLinks
