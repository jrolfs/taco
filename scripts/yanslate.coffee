# Description:
#   Translate using Yandex API
#
# Commands:
#   hubot yanslate me <phrase> - searches for a translation for <phrase> and prints it out in English.
#   hubot yanslate from <source> into <target> <phrase> - Translates <phrase> from <source> into <target>.
#   hubot yandex languages - Returns list of languages that can be used in 'translate from <source> to <target>

module.exports = (robot) ->

  api_key = 'trnsl.1.1.20150815T045801Z.13f710eabe10414e.cae8360606ec2ee471275e70d2a259c8eecdb4d8'

  robot.respond /translate me (.*)/i, (msg) ->
    lang = 'en'
    text = "#{msg.match[1]}".split(' ').join('+')
    msg.http("https://translate.yandex.net/api/v1.5/tr.json/translate?key=#{api_key}&lang=#{lang}&text=#{text}")
      .get() (err, res, body) ->
        msg.send JSON.parse(body).text

  robot.respond /translate from ([\w .\-_]+) to ([\w .\-_]+) this (.*)/i, (msg) ->
    lang = "#{msg.match[1]}-#{msg.match[2]}"
    text = "#{msg.match[3]}".split(' ').join('+')
    msg.http("https://translate.yandex.net/api/v1.5/tr.json/translate?key=#{api_key}&lang=#{lang}&text=#{text}")
    .get() (err, res, body) ->
      msg.send JSON.parse(body).text

  robot.respond /yandex languages/i, (msg) ->
    msg.http("https://translate.yandex.net/api/v1.5/tr.json/getLangs?key=#{api_key}")
    .get() (err, res, body) ->
      msg.send JSON.parse(body).dirs
      msg.send("For more info on languages: https://tech.yandex.com/translate/doc/dg/concepts/langs-docpage/")
