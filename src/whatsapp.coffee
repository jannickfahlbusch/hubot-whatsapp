{Robot, Adapter, TextMessage, EnterMessage, LeaveMessage, TopicMessage} = require 'hubot'

whatsapi = require('whatsapi');

class Whatsapp extends Adapter

  constructor: (@robot) ->
    @robot = robot

  receive: (message) ->
    @robot.receive message

  run: ->
      self = @
      @wa = whatsapi.createAdapter({
        msisdn: process.env.HUBOT_WHATSAPP_PHONENUMBER
        username: process.env.HUBOT_WHATSAPP_NICKNAME
        password: process.env.HUBOT_WHATSAPP_PASSWORD
        ccode: process.env.HUBOT_WHATSAPP_COUNTRYCODE
      }, false)
      @wa.connect (err) ->
        if err
            console.log err
            return
        console.log 'Connected'
        self.wa.login self.logged()

      @wa.on 'receivedMessage', (message) ->
          from = message.from.split('@')[0]
          self.receive new TextMessage from, message.body, message.id
          return
      @emit 'connected'

    logged: (err) ->
        if err
            console.log err
            return
        console.log 'Logged in'
        @wa.sendMessage process.env.HUBOT_WHATSAPP_OWNERNUMBER, 'I started successfully', (err, id) ->
            if err
                console.log err
                return
            console.log 'Server recieved message ' + id
            @sendIsOnline()

	send: (envelope, strings...) ->
        console.log 'Sending reply'
        console.log envelope
        console.log strings
        recipient = envelope.user
        for msg in strings
		          @wa.sendMessage recipient, msg, (err, id) ->
                      if err
                          console.log 'There was an ERROR!'
                          console.log err.message
                          return
                    console.log 'Server received message %s', id
                    return

    emote: (envelope, strings...) ->
        console.log 'emote'
        @send envelope, "* #{str}" for str in strings

	reply: (envelope, strings...) ->
        console.log 'reply'
        strings = strings.map (s) -> "#{envelope.user.name}: #{s}"
        @send envelope, strings...

exports.use = (robot) ->
	new Whatsapp robot
