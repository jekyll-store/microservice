require 'pony'
require_relative 'templates'

module Mailer
  class << self
    attr_accessor :purchases_email, :errors_email

    def record(order)
      Pony.mail(to: purchases_email,
                from: purchases_email,
                subject: 'Purchase',
                body: Templates.render(:record, order))
    end

    def confirm(order)
      Pony.mail(to: order.address['email'],
                from: purchases_email,
                subject: 'Jekyll-Store Order Confirmation',
                html_body: Templates.html_render(:confirm, order))
    end

    def error(error, request)
      Pony.mail(to: errors_email,
                from: errors_email,
                subject: 'Error',
                body: Templates.render(:error, error: error, request: request))
    end

    def test
      Pony.mail(to: errors_email,
                from: errors_email,
                subject: 'Test Mail',
                body: 'This is a test message.')
    end
  end
end
