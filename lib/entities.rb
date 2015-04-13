require 'virtus'
require 'bigdecimal'
require 'securerandom'

class Order
  include Virtus.model
  attribute :number, String, default: SecureRandom.hex(8).upcase
  attribute :basket, Hash[String => Integer]
  attribute :address, Hash
  attribute :delivery, String
  attribute :token, String
  attribute :currency, String
  attribute :total, BigDecimal
end

class Product
  include Virtus.model
  attribute :name, String
  attribute :price, BigDecimal
  attribute :weight, BigDecimal
end

class Country
  include Virtus.model
  attribute :iso, String
  attribute :name, String
  attribute :zones, Array[String]
end

class DeliveryMethod
  include Virtus.model
  attribute :name, String
  attribute :zones, Array[String]
  attribute :calculator, String
  attribute :args, Hash
  attribute :eta, String
end
