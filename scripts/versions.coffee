# Description:
#   See what versions are on staging/production
#
# Commands:
#   mavbot prod sha
#   mavbot prod diff
#   mavbot mobile sha
#   mavbot mobile diff
#   mavbot marketing sha
#   mavbot marketing diff
#   mavbot announce deploy SHA - this will announce the deploy to @group and print the git compare link to the current sha in production
#   mavbot mobile announce deploy SHA

module.exports = (robot) ->
  getProductionVersion = (msg, cb) ->
    msg.http("http://app.mavenlink.com/version.txt")
    .get() (err, res, body) ->
      cb(body.trim())

  getMobileVersion = (msg, cb) ->
    msg.http("http://m.mavenlink.com/version.txt")
    .get() (err, res, body) ->
      cb(body.trim())

  getMarketingVersion = (msg, cb) ->
    msg.http("http://www.mavenlink.com/version.txt")
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

  sendMarketingCommitUrl = (msg) ->
    getMarketingVersion msg, (sha) ->
      msg.send "#{sha}\nhttps://github.com/mavenlink/marketing/commit/#{sha}"

  sendMarketingCompareUrl = (msg) ->
    getMarketingVersion msg, (sha) ->
      msg.send "#{sha}\nhttps://github.com/mavenlink/marketing/compare/#{sha}...master"

  sendAnnouncement = (msg) ->
    deployedSha = msg.match[1]
    deployedSha = deployedSha.trim()

    if deployedSha? && deployedSha != ''
      getProductionVersion msg, (productionSha) ->
        msg.send "@group Deploying to production\nhttps://github.com/mavenlink/mavenlink/compare/#{productionSha}...#{deployedSha}"
    else
      msg.send "Please provide the sha that is being deployed ex. announce deploy 60c629782dc062af7d52a93993e6c3ef3ee20624"

  sendMobileAnnouncement = (msg) ->
    deployedSha = msg.match[1]
    deployedSha = deployedSha.trim()

    if deployedSha? && deployedSha != ''
      getMobileVersion msg, (productionSha) ->
        msg.send "@group Deploying mobile to production\nhttps://github.com/mavenlink/mobile/compare/#{productionSha}...#{deployedSha}"
    else
      msg.send "Please provide the sha that is being deployed ex. announce deploy 14c0f16ff0fddfcf65db43bd10860ba0e69fdd15"

  sendMarketingAnnouncement = (msg) ->
    deployedSha = msg.match[1]
    deployedSha = deployedSha.trim()

    if deployedSha? && deployedSha != ''
      getMarketingVersion msg, (productionSha) ->
        msg.send "@group Deploying marketing to production\nhttps://github.com/marketing/mobile/compare/#{productionSha}...#{deployedSha}"
    else
      msg.send "Please provide the sha that is being deployed ex. announce deploy 14c0f16ff0fddfcf65db43bd10860ba0e69fdd15"


  robot.respond /prod sha/i, sendProdCommitUrl
  robot.respond /prod diff/i, sendProdCompareUrl
  robot.respond /announce deploy(.*)/i, sendAnnouncement

  robot.respond /mobile sha/i, sendMobileCommitUrl
  robot.respond /mobile diff/i, sendMobileCompareUrl
  robot.respond /mobile announce deploy(.*)/i, sendMobileAnnouncement

  robot.respond /marketing sha/i, sendMarketingCommitUrl
  robot.respond /marketing diff/i, sendMarketingCompareUrl
  robot.respond /marketing announce deploy(.*)/i, sendMarketingAnnouncement
