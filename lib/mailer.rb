require 'pony'
require_relative 'templates'

pony_opts = {
  host: ENV['JSM_SMTP_HOST'],
  address: ENV['JSM_SMTP_ADDRESS'],
  port: ENV['JSM_SMTP_PORT'],
  user_name: ENV['JSM_SMTP_USER'],
  password: ENV['JSM_SMTP_PASS'],
  domain: ENV['JSM_SMTP_DOMAIN'],
  authentication: ENV['JSM_SMTP_AUTH'],
  enable_starttls_auto: ENV['JSM_SMTP_START_TLS_AUTO']
}

Pony.options = { via: :smtp, via_options: pony_opts.select { |_k, v| !v.nil? } }

module Mailer
  class << self
    def record(order)
      Pony.mail(to: 'purchases@jekyll-store.com',
                from: 'purchases@jekyll-store.com',
                subject: 'Purchase',
                body: Templates.render(:record, order))
    end

    def confirm(order)
      Pony.mail(to: order.address['email'],
                from: 'purchases@jekyll-store.com',
                subject: 'Jekyll-Store Order Confirmation',
                html_body: Templates.html_render(:confirm, order))
    end

    def error(error, request)
      Pony.mail(to: 'errors@jekyll-store.com',
                from: 'errors@jekyll-store.com',
                subject: 'Error',
                body: Templates.render(:error, error: error, request: request))
    end
  end
end
