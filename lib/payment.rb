require 'paymill'

module Payment
  class << self
    attr_accessor :method

    def create(order)
      case method
      when 'Paymill'
        paymill(order)
      else
        fail(PaymentMethodNotFound, method)
      end
    end

    private

    def paymill(order)
      Paymill::Transaction.create(amount: amount_in_cents(order),
                                  currency: order.currency,
                                  token: order.token)
    end

    def amount_in_cents(order)
      (order.total * 100).to_i
    end
  end
end

Paymill.api_key = ENV['JSM_PAYMILL_PRIVATE_KEY']
Payment.method = ENV['JSM_PAYMENT_METHOD']

class PaymentMethodNotFound < StandardError; end
