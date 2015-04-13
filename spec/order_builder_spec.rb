require 'order_builder'
require_relative 'fixtures'
include Consequence

describe OrderBuilder do
  let(:order) { Order.new(basket: basket, address: address, delivery: 'Express') }
  let(:basket) { { 'bag' => 3, 'shoe' => 2 } }
  let(:address) { { 'country' => 'LK' } }

  before do
    allow(Resources).to receive(:products).and_return(PRODUCTS)
    allow(Resources).to receive(:countries).and_return(COUNTRIES)
    allow(Resources).to receive(:delivery_methods).and_return(METHODS)
  end

  it 'build for valid order' do
    result = OrderBuilder.build(order)
    value = result.value
    expect(result).to be_a(Success)
    expect(value.basket).to eql(PRODUCTS['bag'] => 3, PRODUCTS['shoe'] => 2)
    expect(value.address['country']).to eql(COUNTRIES['LK'])
    expect(value.delivery).to eql(METHODS['Express'])
  end

  it 'returns failure if product not recognized' do
    basket.merge!('trolley' => 1)
    expect(OrderBuilder.build(order))
      .to eq(Failure[ProductNotFound.new('trolley')])
  end

  it 'returns failure if country not recognized' do
    address.merge!('country' => 'YOLO')
    expect(OrderBuilder.build(order))
      .to eq(Failure[CountryNotFound.new('YOLO')])
  end

  it 'returns failure if delivery method not recognized' do
    order.delivery = 'Snail Mail'
    expect(OrderBuilder.build(order))
      .to eq(Failure[DeliveryMethodNotFound.new('Snail Mail')])
  end
end
