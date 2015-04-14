require 'order_validator'
require_relative 'fixtures'

describe OrderValidator do
  let(:order) do
    order = Order.new(total: '37.9')
    order.basket = { PRODUCTS['bag'] => 3, PRODUCTS['shoe'] => 2 }
    order.address = { 'country' => COUNTRIES['LK'] }
    order.delivery = METHODS['Express']
    order
  end

  it 'succeeds for valid order' do
    expect { OrderValidator.validate(order) }.to_not raise_error
  end

  it 'fails if delivery method not available for country' do
    order.delivery = METHODS['Tracked']
    expect{ OrderValidator.validate(order) }.to raise_error(Undeliverable)
  end

  it 'fails if total does not match up' do
    order.total = BigDecimal('5.00')
    expect{ OrderValidator.validate(order) }.to raise_error(TotalMismatch)
  end
end
