whatsapi = require('whatsapi');

class Whatsapp extends Adapter

  constructor: ->
    @robot = robot

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
		options =
            username: process.env.HUBOT_WHATSAPP_PHONENUMBER
            password: process.env.HUBOT_WHATSAPP_PASSWORD
            nickname: process.env.HUBOT_WHATSAPP_NICKNAME
            countrycode: process.env.HUBOT_WHATSAPP_COUNTRYCODE

        @options = options
        @connected = false

        @wa = whatsapi.createAdapter(
            msisdn: options.username,
            username: options.nickname,
            password: options.password,
            ccode: options.countrycode
        ).connect (err) ->
            if err
                console.log 'There was an error'
                console.log err
                return
            console.log 'Connected'
            @wa.login @wa.sendIsOnline()
            @connected = true
            return

exports.use = (robot) ->
	new Whatsapp robot
