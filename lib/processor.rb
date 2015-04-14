require_relative 'entities'
require_relative 'order/builder'
require_relative 'payment'

module Processor
  class << self
    def process(json)
      order = Order::Builder.build(json)
      Payment.create(order)
    end
  end
end

