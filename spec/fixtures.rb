require 'entities'

PRODUCTS = {
  'bag'  => Product.new('name' => 'bag',  'price' => '4.58',  'weight' => '145'),
  'shoe' => Product.new('name' => 'shoe', 'price' => '8.29',  'weight' => '78'),
  'hat'  => Product.new('name' => 'hat',  'price' => '10.25', 'weight' => '250')
}.freeze

COUNTRIES = {
  'JM' => Country.new('iso' => 'JM',
                      'name' => 'Jamaica',
                      'zones' => ['International', 'North America']),

  'PK' => Country.new('iso' => 'PK',
                      'name' => 'Pakistan',
                      'zones' => %w(Domestic Asia)),

  'LK' => Country.new('iso' => 'LK',
                      'name' => 'Sri Lanka',
                      'zones' => %w(International Asia))
}.freeze

METHODS = {
  'Standard' => DeliveryMethod.new('name' => 'Standard',
                                   'zones' => ['Domestic'],
                                   'eta' => '2 to 3 working days',
                                   'calculator' => 'Fixed',
                                   'args' => { 'amount' => '5.34' }),

  'Express' => DeliveryMethod.new('name' => 'Express',
                                  'zones' => %w(Asia International),
                                  'eta' => '1 day',
                                  'calculator' => 'Percent',
                                  'args' => { 'field' => 'order', 'percent' => '25' }),

  'Tracked' => DeliveryMethod.new('name' => 'Tracked',
                                  'zones' => ['North America', 'Domestic'],
                                  'eta' => '24 hours',
                                  'calculator' => 'Tiered',
                                  'args' => {
                                    'field' => 'weight',
                                    'tiers' => [['0', '3.56'], ['750', '5.35'], ['2000']]
                                  })
}.freeze
