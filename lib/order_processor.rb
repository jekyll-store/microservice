require 'consequence'
require 'consequence/core_ext/utils'
require_relative 'entities'
require_relative 'order_builder'
require_relative 'order_validator'
require_relative 'payment_methods/paymill'
require_relative 'mailer'

module OrderProcessor
  class << self
    include Consequence

    def process(json)
      Success[Order.new(json)] >>
        OrderBuilder.m(:build) >>
        OrderValidator.m(:validate) >>
        m(:process_transaction) <<
        Mailer.m(:record) <<
        Mailer.m(:confirm)
    end

    private

    def process_transaction(order)
      case ENV['JSM_PAYMENT_METHOD']
      when 'Paymill'
        PaymentMethods::Paymill.process(order)
        order
      else
        Failure[PaymentMethodNotSet.new]
      end
    end
  end
end

class PaymentMethodNotSet < StandardError; end
