{robot, Adapter, TextMessage, EnterMessage, LeaveMessage, TopicMessage} = require 'hubot'

whatsapi = require('whatsapi');

class Whatsapp extends Adapter

  constructor: (@robot) ->
    @robot = robot

  run: ->
      self = @
      @wa = whatsapi.createAdapter(
        msisdn: process.env.HUBOT_WHATSAPP_PHONENUMBER,
        username: process.env.HUBOT_WHATSAPP_NICKNAME,
        password: process.env.HUBOT_WHATSAPP_PASSWORD,
        ccode: process.env.HUBOT_WHATSAPP_COUNTRYCODE
      )
      @wa.connect (err) ->
        if err
            console.log err
            return
        console.log 'Connected'
        self.wa.login self.logged()

    logged: (err) ->
        if err
            console.log err
            return
        console.log 'Logged in!'
        console.log 'I am ' + @wa.selfAddress.split('@')[0]
        @wa.sendIsOnline()


	send: (envelope, strings...) ->
        recipient = envelope.user.name.split('@')[0]
        for msg in strings
		          @wa.sendMessage recipient, msg, (err, id) ->
                      if err
                          console.log 'There was an ERROR!'
                          console.log err.message
                          return
                    console.log 'Server received message %s', id
                    return

    emote: (envelope, strings...) ->
        @send envelope, "* #{str}" for str in strings

	reply: (envelope, strings...) ->
        strings = strings.map (s) -> "#{envelope.user.name}: #{s}"
        @send envelope, strings...

    recieve: (message) ->
        @robot.recieve message

exports.use = (robot) ->
	new Whatsapp robot
