require 'IRC'
require 'cerberus/notifier/base'

class Cerberus::Notifier::IRC < Cerberus::Notifier::Base
  def self.notify(state, build, options)
    irc_options = options[:notifier, :irc]
    subject,body = Cerberus::Notifier::Base.formatted_message(state, build, options)
    message = subject + "\n" + '*' * subject.length + "\n" + body

    bot = IRC.new(irc_options[:nick], irc_options[:serevr], irc_options[:port], 'Cerberus continuous builder').add_channel(irc_options[:recipients])
    IRCEvent.add_callback('join') {|event|
      bot.send_message(event.channel, message)
    }
    bot.connect
  end
end