whatsapi = require('whatsapi');

class Whatsapp extends Adapter

  constructor: ->
    @robot = robot

	send: (envelope, strings...) ->
		@robot.logger.info "Send"

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

    connect: () ->
        options = @options

        @wa = whatsapi.createAdapter(
            msisdn: options.username,
            username: options.nickname,
            password: options.password,
            ccode: options.countrycode
        );
        @wa.connect (err) ->
            if err
                console.log err
                return
            console.log 'Connected'
            @wa.login @wa.sendIsOnline()
            return

exports.use = (robot) ->
	new Sample robot
