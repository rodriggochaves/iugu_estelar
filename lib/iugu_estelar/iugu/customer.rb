
module IuguEstelar
  module Iugu
    class Customer
      attr_reader :raw_data, :default_payment_method_id

      def initialize(id)
        @raw_data = IuguEstelar::Iugu.request_to_iugu(:get, "customers/#{id}", {})

        @default_payment_method_id = @raw_data["default_payment_method_id"]
      end

    end
  end
end
