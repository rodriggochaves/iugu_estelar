require 'json'

module IuguEstelar
  module Iugu
    class Invoice
      attr_reader :raw_data, :id, :status

      def initialize(id)
        @raw_data = IuguEstelar::Iugu.request_to_iugu(:get, "invoices/#{id}", {})
        @id = @raw_data["id"]
        @status = @raw_data["status"]
      end

      def refund
        begin
          IuguEstelar::Iugu.request_to_iugu(:post, "invoices/#{id}/refund", {})
          true
        rescue RestClient::BadRequest => e
          JSON.parse(e.response.body)
        end
      end

      def charge(payment_method_id)
        begin
          IuguEstelar::Iugu.request_to_iugu(:post, "charge", {
            invoice_id: @id,
            customer_payment_method_id: payment_method_id
          })
        rescue RestClient::BadRequest => e
          JSON.parse(e.response.body)
        end
      end
    end
  end
end
