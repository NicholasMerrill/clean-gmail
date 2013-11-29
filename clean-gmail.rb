#!/usr/bin/ruby

require 'rubygems'
require 'time'

require 'gmail'
require 'inifile'

config = IniFile.load('config.ini')

cleanStart = Date.parse(config['times']['archive'])

Gmail.connect(config['auth']['username'], config['auth']['password']) do |gmail|
    # puts gmail.inbox.count
    # puts gmail.inbox.count(:unread)

    labelName = "Archived 2013-11-29"

    gmail.inbox.find(:before => cleanStart.each) do |email|
        puts "archiving email from " + email.date
        email.label!(labelName)
        email.archive!
    end
end

