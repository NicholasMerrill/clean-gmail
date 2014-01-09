#!/usr/bin/ruby

# Get the names of all senders of new mail in the inbox.

require 'rubygems'
require 'ruby-progressbar'
require 'set'
require 'time'

require 'gmail'
require 'inifile'


authConfig = IniFile.load('../config.ini')
config = IniFile.load('config.ini')

maxEmails = config['options']['maxEmailsToScan']
if maxEmails == nil
    maxEmails = 100
    puts "Processing %d emails. Set config.ini file to change the default." % maxEmails
end
maxEmails = maxEmails.to_i

unreadOnly = config['options']['unreadOnly'] == 'true'


Gmail.connect(authConfig['auth']['username'], authConfig['auth']['password']) do |gmail|
    if unreadOnly
        inboxCount = gmail.inbox.find(:unread).count
    else
        inboxCount = gmail.inbox.count
    end
    emailsToBeProcessed = (inboxCount < maxEmails or maxEmails == 0 ? inboxCount : maxEmails)
    print "About to process %d emails" % emailsToBeProcessed
    progressBar = ProgressBar.create(:title => "Scanning emails", :total => emailsToBeProcessed,
                                     :format => '%t (%c/%C) %E <%B>')

    i = 0
    senders = Array.new
    if unreadOnly
        mails = gmail.inbox.find(:unread)
    else
        mails = gmail.inbox.mails
    end
    mails.each do |email|
        break if i >= emailsToBeProcessed
        name = email.from[0][:name]
        senders.push(name)
        progressBar.increment
        i += 1
    end

    sendersSet = Set.new senders
    puts "\n%d senders / %d emails:" % [sendersSet.length, senders.length]
    sendersSet.each do |sender|
        puts "%s (%d)" % [sender, senders.count(sender)]
    end
end

