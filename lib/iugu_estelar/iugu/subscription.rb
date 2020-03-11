require 'iugu_estelar/iugu/invoice'

module IuguEstelar
  module Iugu
    class Subscription
      attr_reader :id, :price_cents, :invoices

      def initialize(id)
        @raw_data = IuguEstelar::Iugu.request_to_iugu(:get, "subscriptions/#{id}", {})
        @invoices = IuguEstelar::Iugu.request_to_iugu(:get, "invoices", { query: id })["items"].map do |invoice|
          IuguEstelar::Iugu::Invoice.new(invoice["id"])
        end

        @id = id
        @price_cents = @raw_data["price_cents"]
      end

      def update payload
        IuguEstelar::Iugu.request_to_iugu(:put, "subscriptions/#{@id}", payload)
      end

      def add_promotion
        promotion = {
          description: '50off_3meses_fev20',
          price_cents: -(@price_cents / 2),
          quantity: 1,
          recurrent: true
        }
        update({ subitems: [promotion] })
      end
    end
  end
end
