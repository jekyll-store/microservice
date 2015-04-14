require 'paymill'

module Payment
  class << self
    attr_accessor :method

    def create(order)
      send(method, order)
    end

    def methods
      ['paymill']
    end

    def method_exists?
      methods.include?(method)
    end

    private

    def paymill(order)
      Paymill::Transaction.create(amount: amount_in_cents(order),
                                  currency: order.currency,
                                  token: order.token)
    end

    def amount_in_cents(order)
      (order.total * 100).to_i
    end
  end
end
