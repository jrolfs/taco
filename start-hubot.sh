#!/bin/sh

export PATH=$PATH:node_modules/.bin:node_modules/hubot/node_modules/.bin
hubot --adapter hipchat
