require 'processor'

describe Processor do
  let(:order) { double() }

  it 'processes' do
    expect(Order::Builder).to receive(:build).and_return(order)
    expect(Order::Validator).to receive(:validate).with(order)
    expect(Payment).to receive(:create).with(order)
    expect(Mailer).to receive(:record).with(order)
    expect(Mailer).to receive(:confirm).with(order)
    Processor.process({})
  end
end
