#!/usr/bin/ruby

# Archive email as specified by configuration file.

require 'rubygems'
require 'time'

require 'gmail'
require 'inifile'

authConfig = IniFile.load('../config.ini')
config = IniFile.load('config.ini')

archiveDateString = config['dates']['archive']
archiveDate = Date.parse(archiveDateString)

Gmail.connect(authConfig['auth']['username'], authConfig['auth']['password']) do |gmail|
    labelName = "Archived " + Time.new.strftime('%Y-%m-%d')

    puts gmail.inbox.count().to_s + " in inbox"
    puts gmail.inbox.count(:unread).to_s + " unread in inbox"
    puts
    puts gmail.inbox.count(:before => archiveDate).to_s + " total to be archived"
    puts gmail.inbox.count(:unread, :before => archiveDate).to_s + " unread to be archived"
    gmail.inbox.find(:before => archiveDate).each do |email|
        puts "archiving email from " + email.date
        email.label!(labelName)
        email.archive!
    end
end

