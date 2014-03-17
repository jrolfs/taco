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

  getMobileVersion = (msg, cb) ->
    msg.http("http://m.mavenlink.com/version.txt")
      .get() (err, res, body) ->
        cb(body.trim())

  sendProdCommitUrl = (msg) ->
    getProductionVersion msg, (sha) ->
      msg.send "#{sha}\nhttps://github.com/mavenlink/mavenlink/commit/#{sha}"

  sendProdCompareUrl = (msg) ->
    getProductionVersion msg, (sha) ->
      msg.send "#{sha}\nhttps://github.com/mavenlink/mavenlink/compare/#{sha}...master"

  sendMobileCommitUrl = (msg) ->
    getMobileVersion msg, (sha) ->
      msg.send "#{sha}\nhttps://github.com/mavenlink/mobile/commit/#{sha}"

  sendMobileCompareUrl = (msg) ->
    getMobileVersion msg, (sha) ->
      msg.send "#{sha}\nhttps://github.com/mavenlink/mobile/compare/#{sha}...master"

  robot.respond /prod sha/i, sendProdCommitUrl
  robot.respond /prod diff/i, sendProdCompareUrl

  robot.respond /mobile sha/i, sendMobileCommitUrl
  robot.respond /mobile diff/i, sendMobileCompareUrl