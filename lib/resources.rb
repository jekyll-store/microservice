require 'open-uri'
require 'json'
require_relative 'entities'

module Resources
  class << self
    attr_accessor :front_url

    def products
      @products ||= parse('products', ProductEntity, 'name')
    end

    def countries
      @countries ||= parse('countries', CountryEntity, 'iso')
    end

    def delivery_methods
      @delivery_methods ||= parse('delivery-methods', DeliveryMethodEntity, 'name')
    end

    def reset
      @products = nil
      @countries = nil
      @delivery_methods = nil
    end

    private

    def parse(url, klass, key)
      full_url = "#{front_url}/#{url}.json"

      JSON.parse(open(full_url).read).reduce({}) do |hash, element|
        hash.merge!(element[key] => klass.new(element).freeze)
      end.freeze
    end
  end
end
