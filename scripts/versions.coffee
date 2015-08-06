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

  class Site
    getVersion: (msg, cb) ->
      msg.http("http://#{@prefix}.mavenlink.com/version.txt")
      .get(err, res, body) ->
        cb(body.trim())

    sendCommitUrl: (msg) ->
      @getVersion msg, (sha) ->
        msg.send "#{sha}\nhttps://github.com/mavenlink/mavenlink/commit/#{sha}"

    sendAnnouncement: (msg) ->
      deployedSha = msg.match[1]
      deployedSha = deployedSha.trim()

      if deployedSha? && deployedSha != ''
        @getVersion msg, (sha) ->
          msg.send "@group Deploying to production\nhttps://github.com/mavenlink/#{@gitHubRepo}/compare/#{sha}...#{deployedSha}"
      else
        msg.send "Please provide the sha that is being deployed ex. announce deploy 60c629782dc062af7d52a93993e6c3ef3ee20624"

    sendCompareUrl: (msg) ->
      @getVersion msg, (sha) ->
        msg.send "#{sha}\nhttps://github.com/mavenlink/#{@gitHubRepo}/compare/#{sha}...master"

  class Mobile extends Site
    prefix: "m"
    gitHubRepo: "mobile"

  class Production extends Site
    prefix: "app"
    gitHubRepo: "mavenlink"

  class Marketing extends Site
    prefix: "www"
    gitHubRepo: "marketing"


  robot.respond /prod sha/i, (new Production).sendCommitUrl
  robot.respond /prod diff/i, (new Production).sendCompareUrl
  robot.respond /announce deploy(.*)/i, (new Production).sendAnnouncement

  robot.respond /mobile sha/i, (new Mobile).sendCommitUrl
  robot.respond /mobile diff/i, (new Mobile).sendCompareUrl
  robot.respond /mobile announce deploy(.*)/i, (new Mobile).sendAnnouncement

  robot.respond /marketing sha/i, (new Marketing).sendCommitUrl
  robot.respond /marketing diff/i, (new Marketing).sendCompareUrl
  robot.respond /marketing announce deploy(.*)/i, (new Marketing).sendAnnouncement
