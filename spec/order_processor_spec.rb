require 'order_processor'
require_relative 'fixtures'
include Consequence

describe OrderProcessor do
  let(:params) do
    {
      'basket' => { 'bag' => 3, 'shoe' => 2 },
      'address' => {
        'name' => 'George Hendrix',
        'email' => 'ggtop45@example.com',
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
    ENV['JSM_PAYMENT_METHOD'] = 'Paymill'
  end

  it 'process succesfully' do
    expect(PaymentMethods::Paymill).to receive(:process)
    expect(Mailer).to receive(:record)
    expect(Mailer).to receive(:confirm)
    expect(OrderProcessor.process(params)).to be_a(Success)
  end

  it 'handles errors' do
    params['basket'].merge!('tractor' => 10)
    expect(OrderProcessor.process(params)).to be_a(Failure)
  end
end
