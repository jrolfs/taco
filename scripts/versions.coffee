# Description:
#   See what versions are on staging/production
#
# Commands:
#   mavbot prod sha
#   mavbot prod diff
#   mavbot mobile sha
#   mavbot mobile diff
#   mavbot announce deploy SHA - this will announce the deploy to @here and print the git compare link to the current sha in production

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

  sendAnnouncement = (msg) ->
    deployed_sha = msg.match[1]
    deployed_sha = deployed_sha.trim()

    if deployed_sha? && deployed_sha != ''
      getProductionVersion msg, (production_sha) ->
        msg.send "@here Deploying to production\nhttps://github.com/mavenlink/mobile/compare/#{production_sha}...#{deployed_sha}"
    else
      msg.send "Please provide the sha that is being deployed ex. announce deploy 60c629782dc062af7d52a93993e6c3ef3ee20624"


  robot.respond /prod sha/i, sendProdCommitUrl
  robot.respond /prod diff/i, sendProdCompareUrl
  robot.respond /announce deploy(.*)/i, sendAnnouncement

  robot.respond /mobile sha/i, sendMobileCommitUrl
  robot.respond /mobile diff/i, sendMobileCompareUrl