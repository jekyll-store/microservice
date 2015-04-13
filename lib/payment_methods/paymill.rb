require 'paymill'

Paymill.api_key = ENV['JSM_PAYMILL_PRIVATE_KEY']

module PaymentMethods
  module Paymill
    class << self
      def process(order)
        ::Paymill::Transaction.create(amount: amount_in_cents(order),
                                      currency: order.currency,
                                      token: order.token)
      end

      private

      def amount_in_cents(order)
        (order.total * 100).to_i
      end
    end
  end
end
