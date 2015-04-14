require 'environment'

describe Environment do
  env_store = ENV
  tmp = $VERBOSE
  $VERBOSE = nil

  before do
    ENV = {}
    ENV['JSM_SMTP_HOST'] = 'localhost'
    ENV['JSM_SMTP_PORT'] = '1024'
    ENV['JSM_PURCHASES_EMAIL'] = 'purchases@example.com'
    ENV['JSM_ERRORS_EMAIL'] = 'errors@example.com'
    ENV['JSM_PAYMENT_METHOD'] = 'paymill'
    ENV['JSM_PAYMILL_PRIVATE_KEY'] = 'DODFJ354tsDFG459df'
    ENV['JSM_FRONT_URL'] = 'http://my-front-domain.com'
  end

  after(:all) do
    ENV = env_store
    $VERBOSE = tmp
  end

  it 'sets environment' do
    Environment.set
    expected_opts = { via: :smtp,
                      via_options: { host: 'localhost', port: '1024' } }
    expect(Pony.options).to eql(expected_opts)
    expect(Mailer.purchases_email).to eql('purchases@example.com')
    expect(Mailer.errors_email).to eql('errors@example.com')
    expect(Payment.method).to eql('paymill')
    expect(Paymill.api_key).to eql('DODFJ354tsDFG459df')
    expect(Resources.front_url).to eql('http://my-front-domain.com')
  end

  it 'raise error if no email settings are set' do
    ENV['JSM_SMTP_HOST'] = nil
    ENV['JSM_SMTP_PORT'] = nil
    expect { Environment.set }.to raise_error(EmailOptionsNotSet)
  end

  it 'raise error if purchase email not set' do
    ENV['JSM_PURCHASES_EMAIL'] = nil
    expect { Environment.set }.to raise_error(PurchasesEmailNotSet)
  end

  it 'raise error if errors email not set' do
    ENV['JSM_ERRORS_EMAIL'] = nil
    expect { Environment.set }.to raise_error(ErrorsEmailNotSet)
  end

  it 'raise error if payment method not set' do
    ENV['JSM_PAYMENT_METHOD'] = nil
    expect { Environment.set }.to raise_error(PaymentMethodNotSet)
  end

  it 'raise error if payment method not set' do
    ENV['JSM_PAYMENT_METHOD'] = 'paypal'
    expect { Environment.set }.to raise_error(PaymentMethodNotFound)
  end

  it 'raise error if paymill and private key not set' do
    ENV['JSM_PAYMILL_PRIVATE_KEY'] = nil
    expect { Environment.set }.to raise_error(PaymillKeyNotSet)
  end

  it 'raise error if front url not set' do
    ENV['JSM_FRONT_URL'] = nil
    expect { Environment.set }.to raise_error(FrontURLNotSet)
  end
end
