# Description:
#   Manage and order groceries
#
# Commands:
#   hubot groceries - current working grocery list
#   hubot groceries list - current working grocery list
#   hubot groceries add GROCERY_NAME - adds a thing you want from the grocery store
#   hubot groceries remove GROCERY_NAME - removes a thing you don't want from the grocery store
#   hubot groceries clear - removes all groceries (i.e. you went shopping)

Util = require "util"

module.exports = (robot) ->
  robot.respond /groceries add (.*)$/i, (msg) ->
    if msg.match[1]
      groceries = robot.brain.get 'groceries' || {}
      groceries[msg.match[1]] = {}
      robot.brain.set 'groceries', groceries

      msg.send "Added #{msg.match[1]} to the grocery list"

  robot.respond /groceries remove (.*)$/i, (msg) ->
    if msg.match[1]
      groceries = robot.brain.get 'groceries' || {}
      delete groceries[msg.match[1]]
      robot.brain.set 'groceries', groceries

      msg.send "Removed #{msg.match[1]} from the grocery list"

  robot.respond /groceries clear$/i, (msg) ->
    robot.brain.set 'groceries', {}
    msg.send 'Grocery list cleared'

  groceryList = (msg) ->
    groceries = robot.brain.get 'groceries' || {}

    if not Object.keys(groceries).length
      response = "You have an empty grocery list"
    else
      responses = []
      for own key of groceries
        responses.push key

      response = responses.join('\n')

    msg.send response

  robot.respond /groceries list$/i, groceryList
  robot.respond /groceries$/i, groceryList
