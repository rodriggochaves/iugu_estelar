require 'mongo'

module IuguEstelar
  class Mongo
    def initialize
      @client = ::Mongo::Client.new(ENV['MONGODB'])
    end

    def save_invoices invoices
      @client[:invoices].insert_many(invoices)
    end
  end
end
