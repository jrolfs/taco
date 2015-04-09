# Description:
#   Get a link to a Google Hangout meeting room
#
# Commands:
#   hubot hangout :name
#   hubot hangouts - lists all of the hangouts today (TODO)

Util = require "util"
https = require "https"

module.exports = (robot) ->
  downloadUrl = (url, callback) ->
     https.get url, (res) ->
      data = ""
      res.on 'data', (chunk) ->
        data += chunk
        return
      res.on 'end', ->
        if res.statusCode is 200
          callback null, data
        else
          callback(new Error("Response status code: " + res.statusCode), data)
        return
      return

  robot.respond /hangout (.*)$/i, (msg) ->
    hangoutName = msg.match[1]
    hangoutLink = "https://plus.google.com/hangouts/_/mavenlink.com/#{hangoutName}"
    user = msg.message.user.name
    downloadUrl 'https://gender-api.com/get?name=' + user, (res, data) ->
      sirVar = "come one come all! "
      sirVar = "Miss" if data.gender == "female"
      sirVar = "Sir" if data.gender == "male"
      sirVar = "Sir" if data.name == "racerpeter"

      msg.send "Your Hangout, #{sirVar}: #{hangoutLink}"

  listHangouts = (msg) ->
    hangouts = {
      "monday-kickoff": "Monday Kickoff",
      "wip-demos": "WIP Demos & Maven Talks",
      "pentagon-bobby": "The Pentagon Standup",
      "ds5-standup": "Deep Space 5 Standup",
      "5loko-ben": "5Loko Standup",
      "mi6-standup": "MI6 Standup"
    }

    if not Object.keys(hangouts).length
      response = "I don't know about any hangouts."
    else
      responses = []

      for key, name of hangouts
        responses.push "#{name}: https://plus.google.com/hangouts/_/mavenlink.com/#{key}"

      response = responses.join('\n')
    msg.send response

  robot.respond /hangouts list$/i, listHangouts
  robot.respond /hangouts$/i, listHangouts
