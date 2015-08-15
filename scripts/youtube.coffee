# Description
#   A hubot script for searching YouTube with the YouTube Data API v3.
#   Based off the original hubot-youtube script.
#
# Commands:
#   hubot youtube me <query> - Searches YouTube for the query and returns the video embed link.
#
# Notes:
#   Make sure you don't go over your daily quota for API usage.

module.exports = (robot) ->

  ytApiKey = 'AIzaSyALhQd1fGRMIlScLLUbTW2guO5y2fBApCc'

  robot.respond /(?:youtube|yt)(?: me)?\s(.*)/i, (msg) ->
    query = msg.match[1]
    ytSearchUrl = "https://www.googleapis.com/youtube/v3/search"
    searchParams = {
      order: "relevance"
      part: "snippet",
      maxResults: 1,
      type: "video",
      key: ytApiKey,
      q: query
    }

    robot.http(ytSearchUrl)
    .query(searchParams)
    .get() (err, res, body) ->
      videos = JSON.parse(body).items

      if videos == undefined || videos.length == 0
        msg. send "No video results for \"#{query}\""
        return

      videoId = videos[0].id.videoId
      msg.send "http://www.youtube.com/watch?v=#{videoId}"
