#!/usr/bin/ruby

require 'rubygems'
require 'time'

require 'gmail'
require 'inifile'

config = IniFile.load('config.ini')

gmail = Gmail.connect(config['auth']['username'], config['auth']['password']) do |gmail|
    puts gmail.inbox.count
    puts gmail.inbox.count(:unread)
end

