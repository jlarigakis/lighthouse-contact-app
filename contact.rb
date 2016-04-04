require 'csv'

# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact
  @@filename = 'contacts.csv'
  attr_accessor :name, :email
  
  # Creates a new contact object
  # @param name [String] The contact's name
  # @param email [String] The contact's email address
  def initialize(name, email)
    @name = name
    @email = email
  end

  def to_s
    @name + ": " + @email
  end

  # Provides functionality for managing contacts in the csv file.
  class << self

    # Opens 'contacts.csv' and creates a Contact object for each line in the file (aka each contact).
    # @return [Array<Contact>] Array of Contact objects
    def all
      CSV.read(@@filename).map do |name, email|
        return nil if name.nil? || email.nil?
        Contact.new(name, email)
      end.reject { |c| c.nil? }
    end

    # Creates a new contact, adding it to the csv file, returning the new contact.
    # @param name [String] the new contact's name
    # @param email [String] the contact's email
    def create(name, email)
      file = File.open(@@filename, 'a')
      file.write "#{name},#{email}\n"
      file.close # needed to guarantee consistency
      Contact.new(name, email)
    end
    
    # Find the Contact in the 'contacts.csv' file with the matching id.
    # @param id [Integer] the contact id
    # @return [Contact, nil] the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      Contact.all[id-1]
    end
    
    # Search for contacts by either name or email.
    # @param term [String] the name fragment or email fragment to search for
    # @return [Array<Contact>] Array of Contact objects.
    def search(term)
      pattern = /#{term}/
      Contact.all.find { |c| c.name =~ pattern || c.email =~ pattern }
    end

  end

end
