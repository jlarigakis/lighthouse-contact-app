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
      throw ArgumentError if name.nil? || email.nil?
      (Contact.create(name, email) && "Created contact #{name}.") ||
        "Contact creation failed."
    end,
    list: Command.new("List all contacts") do
      paginate Contact.all
    end,
    show: Command.new("Show a contact") do |id|
      Contact.find(id.to_i) || "Contact #{id} not found."
    end,
    search: Command.new("Search contacts") do |contact|
      Contact.search(contact) || "No matching contact found."
    end
  }

  class << self
    def paginate(contacts)
      return "No contacts found." if contacts.nil? || contacts.empty?
      while contacts.length > 5 do
        puts contacts.shift(5)
        print "[ <Enter> to continue: ]"
        gets
      end
      contacts
    end

    def run(my_argv)
      cmd = my_argv.shift&.to_sym
      cmd_args = my_argv
      begin
        puts @@commands[cmd]&.run(*cmd_args) || help
      rescue ArgumentError
        puts "Invalid number of arguments for #{cmd}."
      end
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
