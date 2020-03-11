require 'json'
require 'rest-client'
require 'dotenv/load'

module IuguEstelar
  module Iugu
    def self.request_to_iugu(method, url, params)
      payload = params.merge({
        api_token: ENV['IUGU']
      })
      response = RestClient::Request.execute(
        url: "https://api.iugu.com/v1/#{url}",
        method: method,
        headers: {
          "Content-Type": "application/json"
        },
        payload: payload
      )
      JSON.parse(response.body)
    end

    def self.count_invoices
      request_to_iugu(:get, 'invoices', {})["totalItems"]
    end

    def self.list_invoices_page page
      request_to_iugu(:get, 'invoices',  { start: page })["items"]
    end

    def self.list_all_invoices
      (0..count_invoices).to_a.select { |n| n % 100 == 0 }.flat_map do |page|
        list_invoices_page(page)
      end
    end

    def self.count_all_subscriptions
      request_to_iugu(:get, 'subscriptions', {})["totalItems"]
    end

    def self.list_subscriptions_page(page)
      request_to_iugu(:get, 'subscriptions',  { start: page })["items"]
    end

    def self.list_all_subscriptions
      (0..count_all_subscriptions).to_a.select { |n| n % 100 == 0 }.flat_map do |page|
        list_subscriptions_page(page)
      end
    end
  end
end
