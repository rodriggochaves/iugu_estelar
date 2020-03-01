require 'json'
require 'rest-client'

module IuguEstelar
  module Iugu
    def self.request_to_iugu(params)
      payload = params.merge({
        api_token: ENV['IUGU']
      })
      response = RestClient::Request.execute(
        url: 'https://api.iugu.com/v1/invoices',
        method: :get,
        headers: {
          "Content-Type": "application/json"
        },
        payload: payload
      )
      JSON.parse(response.body)
    end

    def self.count_invoices
      request_to_iugu({})["totalItems"]
    end

    def self.list_invoices_page page
      request_to_iugu({ start: page })["items"]
    end

    def self.list_all_invoices
      (0..count_invoices).to_a.select { |n| n % 100 == 0 }.flat_map do |page|
        list_invoices_page(page)
      end
    end
  end
end
