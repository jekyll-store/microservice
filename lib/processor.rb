require_relative 'order/builder'
require_relative 'order/validator'
require_relative 'payment'
require_relative 'mailer'

module Processor
  class << self
    def process(json)
      order = Order::Builder.build(json)
      Order::Validator.validate(order)
      Payment.create(order)
      Mailer.record(order)
      Mailer.confirm(order)
    end
  end
end

