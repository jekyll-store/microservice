require 'order_validator'
require_relative 'fixtures'
include Consequence

describe OrderValidator do
  let(:order) do
    order = Order.new(total: '37.9')
    order.basket = { PRODUCTS['bag'] => 3, PRODUCTS['shoe'] => 2 }
    order.address = { 'country' => COUNTRIES['LK'] }
    order.delivery = METHODS['Express']
    order
  end

  it 'succeeds for valid order' do
    expect(OrderValidator.validate(order)).to be_a(Success)
  end

  it 'fails if delivery method not available for country' do
    order.delivery = METHODS['Tracked']
    expect(OrderValidator.validate(order))
      .to eq(Failure[Undeliverable.new('Tracked')])
  end

  it 'fails if total does not match up' do
    order.total = BigDecimal('5.00')
    expect(OrderValidator.validate(order))
      .to eq(Failure[TotalMismatch.new(5.00)])
  end
end
