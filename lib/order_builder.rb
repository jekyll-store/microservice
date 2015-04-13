require 'consequence'
require 'consequence/core_ext/utils'
require_relative 'resources'

module OrderBuilder
  class << self
    include Consequence

    def build(order)
      Success[order] >> m(:products) >> m(:country) >> m(:delivery)
    end

    private

    def products(order)
      order.basket = order.basket.map do |name, quantity|
        product = Resources.products[name]
        return Failure[ProductNotFound.new(name)] unless product
        [product, quantity]
      end
      order
    end

    def country(order)
      iso = order.address['country']
      order.address['country'] = Resources.countries[iso]
      order.address['country'] ? order :
        Failure[CountryNotFound.new(iso)]
    end

    def delivery(order)
      method_name = order.delivery
      order.delivery = Resources.delivery_methods[method_name]
      order.delivery ? order :
        Failure[DeliveryMethodNotFound.new(method_name)]
    end
  end
end

class ProductNotFound < StandardError; end
class CountryNotFound < StandardError; end
class DeliveryMethodNotFound < StandardError; end
