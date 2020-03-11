require 'mongo'

module IuguEstelar
  class Mongo
    def initialize
      uri = ::Mongo::URI.new(ENV['MONGODB'])
      @client = ::Mongo::Client.new(uri)
    end

    def save_invoices invoices
      @client[:invoices].insert_many(invoices)
    end
  end
end
