require "iugu_estelar/version"
require "iugu_estelar/mongo"
require "iugu_estelar/iugu"

module IuguEstelar
  class Error < StandardError; end

  def self.main
    invoices = IuguEstelar::Iugu.list_all_invoices
    mongo = IuguEstelar::Mongo.new
    mongo.save_invoices(invoices)
  end
end
