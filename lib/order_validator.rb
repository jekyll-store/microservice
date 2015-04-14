require_relative 'order_totaller'

module OrderValidator
  class << self
    def validate(order)
      delivery_available(order)
      total_matches(order)
    end

    private

    def delivery_available(order)
      return unless (order.address['country'].zones & order.delivery.zones).empty?
      fail Undeliverable, order.delivery.name
    end

    def total_matches(order)
      return unless OrderTotaller.total(order) != order.total
      fail TotalMismatch, order.total.to_f
    end
  end
end

class Undeliverable < StandardError; end
class TotalMismatch < StandardError; end
