{robot, Adapter, TextMessage, EnterMessage, LeaveMessage, TopicMessage} = require 'hubot'

whatsapi = require('whatsapi');

class Whatsapp extends Adapter

  constructor: ->
    self = @
    console.log 'Starting'
    @robot = robot
    options =
        username: process.env.HUBOT_WHATSAPP_PHONENUMBER
        password: process.env.HUBOT_WHATSAPP_PASSWORD
        nickname: process.env.HUBOT_WHATSAPP_NICKNAME
        countrycode: process.env.HUBOT_WHATSAPP_COUNTRYCODE

    @options = options
    console.log @options
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
        self.emit 'connected'
        return

	send: (envelope, strings...) ->
        recipient = envelope.user.name
        for msg in strings
		          @wa.sendMessage recipient, msg, (err, id) ->
                      if err
                          console.log 'There was an ERROR!'
                          console.log err.message
                          return
                    console.log 'Server received message %s', id
                    return


	reply: (envelope, strings...) ->
		@robot.logger.info "Reply"

	run: ->
        console.log @options


exports.use = (robot) ->
	new Whatsapp robot
