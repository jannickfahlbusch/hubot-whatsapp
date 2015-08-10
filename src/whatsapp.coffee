{robot, Adapter, TextMessage, EnterMessage, LeaveMessage, TopicMessage} = require 'hubot'

whatsapi = require('whatsapi');

class Whatsapp extends Adapter

  constructor: (@robot) ->
    super
    @robot = robot
    self = @
    options =
        username: process.env.HUBOT_WHATSAPP_PHONENUMBER
        password: process.env.HUBOT_WHATSAPP_PASSWORD
        nickname: process.env.HUBOT_WHATSAPP_NICKNAME
        countrycode: process.env.HUBOT_WHATSAPP_COUNTRYCODE

    @options = options
    @wa = whatsapi.createAdapter(
        msisdn: options.username,
        username: options.nickname,
        password: options.password,
        ccode: options.countrycode
    )
    @wa.connect (err) ->
        if err
            console.log 'There was an error'
            console.log err
            return
        console.log 'Connected'
        self.wa.login ->
            if err
                console.log err
                return
            self.wa.sendIsOnline()
    return @robot


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

	run: ->
        self = @
        # Create our WhatsApp-Object
        @wa.on 'receivedMessage', (message) ->
            console.log message
            self.recieve new TextMessage message.from.split('@')[0], message.body, message.id
        #@emit 'connected'


exports.use = (robot) ->
	new Whatsapp robot
