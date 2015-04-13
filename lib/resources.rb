require 'open-uri'
require 'json'
require_relative 'entities'

module Resources
  class << self
    def products
      @products ||= parse('products', Product, 'name')
    end

    def countries
      @countries ||= parse('countries', Country, 'iso')
    end

    def delivery_methods
      @delivery_methods ||= parse('delivery-methods', DeliveryMethod, 'name')
    end

    def reset
      @products = nil
      @countries = nil
      @delivery_methods = nil
    end

    private

    def parse(url, klass, key)
      full_url = "#{ENV['JSM_FRONT_URL']}/#{url}.json"

      JSON.parse(open(full_url).read).reduce({}) do |hash, element|
        hash.merge!(element[key] => klass.new(element).freeze)
      end.freeze
    end
  end
end
