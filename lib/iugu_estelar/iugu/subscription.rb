require 'json'

require 'iugu_estelar/iugu/invoice'
require 'iugu_estelar/iugu/customer'

module IuguEstelar
  module Iugu
    class Subscription

      attr_reader :id, :price_cents, :invoices, :raw_data, :customer

      def initialize(id)
        @raw_data = IuguEstelar::Iugu.request_to_iugu(:get, "subscriptions/#{id}", {})
        @invoices = IuguEstelar::Iugu.request_to_iugu(:get, "invoices", { query: id })["items"].map do |invoice|
          IuguEstelar::Iugu::Invoice.new(invoice["id"])
        end
        @customer = Customer.new(@raw_data["customer_id"])

        @id = id
        @price_cents = @raw_data["price_cents"]
        @customer_email = @raw_data["customer_email"]
        @plan_identifier = @raw_data["plan_identifier"]
        @plan_name = @raw_data["plan_name"]
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

      def create_invoice
        begin
          invoice = IuguEstelar::Iugu.request_to_iugu(:post, "invoices", {
            email: @email,
            subscription_id: @id,
            items: [{
              description: "Assinatura: #{@plan_name}",
              price_cents: @price_cents,
              quantity: 1
            }, {
              description: '50off_3meses_fev20',
              price_cents: -(@price_cents / 2),
              quantity: 1,
            }],
            due_date: (Time.now + (2 * 24 * 60 * 60)).to_s
          })

          IuguEstelar::Iugu::Invoice.new(invoice["id"])
        rescue RestClient::UnprocessableEntity => e
          JSON.parse(e.response.body)
        end
      end
    end
  end
end
