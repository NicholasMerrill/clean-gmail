#!/usr/bin/ruby

require 'rubygems'
require 'time'

require 'gmail'
require 'inifile'

config = IniFile.load('config.ini')

Gmail.connect(config['auth']['username'], config['auth']['password']) do |gmail|
    # puts gmail.inbox.count
    # puts gmail.inbox.count(:unread)

    labelName = "Archived 2013-11-28"

    gmail.inbox.find(:before => Date.parse("2013-09-01")).each do |email|
        puts "archiving email from " + email.date
        email.label!(labelName)
        email.archive!
    end
end

