require 'pony'
require 'paymill'
require_relative 'mailer'
require_relative 'payment'
require_relative 'resources'

module Environment
  class << self
    def set
      pony_config

      Resources.front_url = ENV['JSM_FRONT_URL']
      Mailer.purchases_email = ENV['JSM_PURCHASES_EMAIL']
      Mailer.errors_email = ENV['JSM_ERRORS_EMAIL']
      Payment.method = ENV['JSM_PAYMENT_METHOD']
      Paymill.api_key = ENV['JSM_PAYMILL_PRIVATE_KEY']

      fail(FrontURLNotSet) unless Resources.front_url
      fail(PurchasesEmailNotSet) unless Mailer.purchases_email
      fail(ErrorsEmailNotSet) unless Mailer.errors_email
      fail(PaymentMethodNotSet) unless Payment.method
      fail(PaymentMethodNotFound, Payment.method) unless Payment.method_exists?
      fail(PaymillKeyNotSet) if Payment.method == 'paymill' && !Paymill.api_key
    end

    private

    def pony_config
      opts = {
        host: ENV['JSM_SMTP_HOST'],
        address: ENV['JSM_SMTP_ADDRESS'],
        port: ENV['JSM_SMTP_PORT'],
        user_name: ENV['JSM_SMTP_USER'],
        password: ENV['JSM_SMTP_PASS'],
        domain: ENV['JSM_SMTP_DOMAIN'],
        authentication: ENV['JSM_SMTP_AUTH'],
        enable_starttls_auto: ENV['JSM_SMTP_START_TLS_AUTO']
      }.select { |_k, v| !v.nil? }

      fail(EmailOptionsNotSet) if opts.empty?
      Pony.options = { via: :smtp, via_options: opts }
    end
  end
end

class EmailOptionsNotSet < StandardError; end
class PurchasesEmailNotSet < StandardError; end
class ErrorsEmailNotSet < StandardError; end
class PaymentMethodNotSet < StandardError; end
class PaymentMethodNotFound < StandardError; end
class PaymillKeyNotSet < StandardError; end
class FrontURLNotSet < StandardError; end
