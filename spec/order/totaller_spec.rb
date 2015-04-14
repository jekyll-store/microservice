require 'order/totaller'
require_relative '../fixtures'

module Order
  describe Totaller do
    let(:order) do
      order = OrderEntity.new
      order.basket = { PRODUCTS['bag'] => 3, PRODUCTS['shoe'] => 2 }
      order.delivery = METHODS['Standard']
      order
    end

    it 'calculates total with fixed calculator' do
      expect(Totaller.total(order)).to eql(35.66)
    end

    it 'calculates total with percent calculator' do
      order.delivery = METHODS['Express']
      expect(Totaller.total(order)).to eql(37.9)
    end

    describe 'tiered calcualtor' do
      before { order.delivery = METHODS['Tracked'] }

      it 'calculates' do
        expect(Totaller.total(order)).to eql(33.88)
      end

      it 'exclusive upperbounds, inclusive lowerbounds' do
        order.basket = { PRODUCTS['hat'] => 3 }
        expect(Totaller.total(order)).to eql(36.1)
      end

      it 'raise if not available' do
        order.basket = { PRODUCTS['hat'] => 25 }
        expect { Totaller.total(order) }.to raise_error(DeliveryNotApplicable)
      end
    end
  end
end
