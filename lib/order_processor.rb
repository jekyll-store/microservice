require_relative 'entities'
require_relative 'order_builder'
require_relative 'order_validator'
require_relative 'payment_methods/paymill'
require_relative 'mailer'

module OrderProcessor
  class << self
    def process(json)
      order = Order.new(json)
      OrderBuilder.build(order)
      OrderValidator.validate(order)
      process_transaction(order)
      Mailer.record(order)
      Mailer.confirm(order)
    end

    private

    def process_transaction(order)
      case ENV['JSM_PAYMENT_METHOD']
      when 'Paymill'
        PaymentMethods::Paymill.process(order)
        order
      else
        fail PaymentMethodNotSet
      end
    end
  end
end

class PaymentMethodNotSet < StandardError; end
