require 'order/builder'
require_relative '../fixtures'

module Order
  describe Builder do
    let(:json) do
      {
        'basket' => { 'bag' => 3, 'shoe' => 2 },
        'customer' => {
          'name' => 'George Hendrix',
          'email' => 'ggtop45@example.com'
        },
        'address' => {
          'address1' => '45 Station Road',
          'address2' => '',
          'city' => 'Shrovesbury',
          'county' => 'Wessex',
          'country' => 'LK',
          'postcode' => 'WE34 9DU'
        },
        'delivery' => 'Express',
        'token' => 'FIFJ3453GFH56',
        'currency' => 'GBP',
        'total' => '37.9'
      }
    end

    before do
      allow(Resources).to receive(:products).and_return(PRODUCTS)
      allow(Resources).to receive(:countries).and_return(COUNTRIES)
      allow(Resources).to receive(:delivery_methods).and_return(METHODS)
    end

    it 'build for valid order' do
      order = Builder.build(json)
      expect(order.basket).to eql(PRODUCTS['bag'] => 3, PRODUCTS['shoe'] => 2)
      expect(order.address['country']).to eql(COUNTRIES['LK'])
      expect(order.delivery).to eql(METHODS['Express'])
    end

    it 'returns failure if product not recognized' do
      json['basket'].merge!('trolley' => 1)
      expect { Builder.build(json) }.to raise_error(ProductNotFound)
    end

    it 'returns failure if country not recognized' do
      json['address'].merge!('country' => 'YOLO')
      expect { Builder.build(json) }.to raise_error(CountryNotFound)
    end

    it 'returns failure if delivery method not recognized' do
      json['delivery'] = 'Snail Mail'
      expect { Builder.build(json) }.to raise_error(DeliveryMethodNotFound)
    end
  end
end
