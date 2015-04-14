require 'resources'

describe Resources do
  let(:json) do
    '[
      { "name": "bag", "price": "4.58", "weight": "145" },
      { "name": "shoe", "price": "8.29", "weight": "78" },
      { "name": "hat", "price": "10.25", "weight": "250" }
    ]'
  end

  before do
    allow(Resources).to receive(:open).and_return(double(read: json))
  end

  it 'parses json and returns lookup of entities' do
    expect(Resources.products['bag'].name).to eql('bag')
    expect(Resources.products['bag'].price).to eql(BigDecimal('4.58'))
    expect(Resources.products['bag'].weight).to eql(BigDecimal('145'))
    expect(Resources.products['shoe'].name).to eql('shoe')
    expect(Resources.products['shoe'].price).to eql(BigDecimal('8.29'))
    expect(Resources.products['shoe'].weight).to eql(BigDecimal('78'))
    expect(Resources.products['hat'].name).to eql('hat')
    expect(Resources.products['hat'].price).to eql(BigDecimal('10.25'))
    expect(Resources.products['hat'].weight).to eql(BigDecimal('250'))
  end
end
