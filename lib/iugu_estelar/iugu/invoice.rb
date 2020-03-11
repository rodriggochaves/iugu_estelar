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
    end
  end
end
