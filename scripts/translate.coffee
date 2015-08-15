# Description:
#   Allows Hubot to know many languages.
#
# Commands:
#   hubot translate me <phrase> - searches for a translation for <phrase> and prints it out in English.

module.exports = (robot) ->

  api_key = 'trnsl.1.1.20150815T045801Z.13f710eabe10414e.cae8360606ec2ee471275e70d2a259c8eecdb4d8'

  robot.respond /translate me (.*)/i, (msg) ->
    lang = 'en'
    text = msg.match[1]
    msg.http("https://translate.yandex.net/api/v1.5/tr.json/translate?key=#{api_key}&lang=#{lang}&text=#{text}")
      .get() (err, res, body) ->
         msg.send JSON.parse(body).text

