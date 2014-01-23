# Description:
#   See what versions are on staging/production
#
# Commands:
#   hubot version staging
#   hubot version production

module.exports = (robot) ->
  getProductionVersion = (msg) ->
    msg.http("http://app.mavenlink.com/version.txt")
      .get() (err, res, body) ->
        msg.send "#{body} - https://github.com/mavenlink/mavenlink/commit/#{body}"

  robot.hear /what's on production\?/i, getProductionVersion
  robot.respond /prod sha/i, getProductionVersion