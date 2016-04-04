require_relative 'contact'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList
  class Command 
    attr_reader :description
    def initialize(description, &block)
      @description = description
      @block = block
    end
    def run(*args)
      @block.call(*args)
    end
  end

  @@commands = {
    new: Command.new("Create a new contact") do |name, email|
      newContact(name, email)
    end,
    list: Command.new("List all contacts") do
      listContacts 
    end,
    show: Command.new("Show a contact") do |name|
      showContact(name)
    end,
    search: Command.new("Search contacts") do |contact|
      searchContacts(contact)
    end
  }
    
  @@contacts = []

  class << self
    def newContact(name, email)
      # @@contacts << Contact.new(name, email)
      "new contact" #TODO
    end

    def listContacts
      # @@contacts
      "listing all contacts" #TODO
    end

    def showContact(name)
      "showing contact #{name}" #TODO
    end

    def searchContacts(contact)
      "Searching contacts for #{contact}!" #TODO
    end

    def run
      cmd = ARGV.shift&.to_sym
      puts @@commands[cmd]&.run(*ARGV) || help
    end

    def help
      output = "Here is a list of available commands:\n"
      @@commands.each do |name, command| 
        output << "\t#{name}\t- #{command.description}\n"
      end
      output
    end
  end
end

ARGV << "show" << "joe"
ContactList.run
