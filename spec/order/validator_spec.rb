require 'order/validator'
require 'entities'
require_relative '../fixtures'

module Order
  describe Validator do
    let(:order) do
      order = OrderEntity.new(total: '37.9')
      order.basket = { PRODUCTS['bag'] => 3, PRODUCTS['shoe'] => 2 }
      order.address = { 'country' => COUNTRIES['LK'] }
      order.delivery = METHODS['Express']
      order
    end

    it 'succeeds for valid order' do
      expect { Validator.validate(order) }.to_not raise_error
    end

    it 'fails if delivery method not available for country' do
      order.delivery = METHODS['Tracked']
      expect { Validator.validate(order) }.to raise_error(Undeliverable)
    end

    it 'fails if total does not match up' do
      order.total = BigDecimal('5.00')
      expect { Validator.validate(order) }.to raise_error(TotalMismatch)
    end
  end
end
