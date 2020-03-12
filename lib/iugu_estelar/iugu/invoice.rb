module IuguEstelar
  module Iugu
    class Invoice
      attr_reader :raw_data, :id

      def initialize(id)
        @raw_data = IuguEstelar::Iugu.request_to_iugu(:get, "invoices/#{id}", {})
        @id = @raw_data["id"]
      end

      def refund
        IuguEstelar::Iugu.request_to_iugu(:post, "invoices/#{id}/refund", {})
        true
      end

      def charge(payment_method_id)
        IuguEstelar::Iugu.request_to_iugu(:post, "charge", {
          invoice_id: @id,
          customer_payment_method_id: payment_method_id
        })
      end
    end
  end
end
