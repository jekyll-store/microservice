require 'consequence'
require 'consequence/core_ext/utils'
require_relative 'order_totaller'

module OrderValidator
  class << self
    include Consequence

    def validate(order)
      Success[order] >> m(:delivery_available) >> m(:total_matches)
    end

    private

    def delivery_available(order)
      !(order.address['country'].zones & order.delivery.zones).empty? ? order :
        Failure[Undeliverable.new(order.delivery.name)]
    end

    def total_matches(order)
      OrderTotaller.total(order) == order.total ? order :
        Failure[TotalMismatch.new(order.total.to_f)]
    end
  end
end

class Undeliverable < StandardError; end
class TotalMismatch < StandardError; end
