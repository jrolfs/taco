# Description:
#   See what versions are on staging/production
#
# Commands:
#   mavbot prod sha
#   mavbot prod diff

module.exports = (robot) ->
  getProductionVersion = (msg, cb) ->
    msg.http("http://app.mavenlink.com/version.txt")
      .get() (err, res, body) ->
        cb(body.trim())

  sendCommitUrl = (msg) ->
    getProductionVersion msg, (sha) ->
      msg.send "#{sha}\nhttps://github.com/mavenlink/mavenlink/commit/#{sha}"

  sendCompareUrl = (msg) ->
    getProductionVersion msg, (sha) ->
      msg.send "#{sha}\nhttps://github.com/mavenlink/mavenlink/compare/#{sha}...master"

  robot.respond /prod sha/i, sendCommitUrl
  robot.respond /prod diff/i, sendCompareUrl