#!/usr/bin/ruby

require 'rubygems'
require 'time'

require 'gmail'
require 'inifile'

config = IniFile.load('config.ini')

archiveDateString = config['dates']['archive']
archiveDate = Date.parse(archiveDateString)

Gmail.connect(config['auth']['username'], config['auth']['password']) do |gmail|
    labelName = "Archived " + Time.new.strftime('%Y-%m-%d')

    puts gmail.inbox.count(:before => archiveDate).to_s + " total to be archived"
    puts gmail.inbox.count(:unread, :before => archiveDate).to_s + " unread to be archived"
    gmail.inbox.find(:before => archiveDate).each do |email|
        puts "archiving email from " + email.date
        email.label!(labelName)
        email.archive!
    end
end

