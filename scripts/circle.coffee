# Description:
#   See the status of a branch on CircleCI
#
# Commands:
#   hubot status :branch_name

module.exports = (robot) ->
  token = process.env.HUBOT_CIRCLE_TOKEN

  robot.respond /status (.*)/i, (msg) ->
    branchName = msg.match[1]

    if token && branchName
      url = "https://circleci.com/api/v1/project/mavenlink/mavenlink/tree/#{branchName}?circle-token=#{token}"
      console.log url
      msg.http(url)
        .header('Accept', 'application/json')
        .get() (err, res, body) ->
          data = JSON.parse(body)
          msg.send """
            #{data[0].status} (#{data[0].committer_name}) - #{data[0].build_url}
            """