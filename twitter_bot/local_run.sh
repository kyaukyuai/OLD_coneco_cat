#!/bin/bash

export HUBOT_TWITTER_KEY="zENJLaNeMcce1gP81myR3CylU"
export HUBOT_TWITTER_SECRET="tVBbU6gLowCMuXDK2UtW6mrCAKGW6FRCpwa6oCrQytlMYgp7Pu"
export HUBOT_TWITTER_TOKEN="3546734059-8oH7iEoTfmo1Cf4dO6zOF1MzAhOBk65y4rfsp7e"
export HUBOT_TWITTER_TOKEN_SECRET="5A2fX1RGSZNoSt3VTsVWjIgHLecSFXdz0ToopPsXjVsuS"

forever start -c coffee node_modules/.bin/hubot -a twitter-userstream -n coneco_cat
