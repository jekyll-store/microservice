require 'sinatra'
require 'sinatra/cross_origin'
require 'json'
require_relative 'lib/order_processor'
require_relative 'lib/resources'
require_relative 'lib/mailer'

configure do
  enable :cross_origin
end

options '*' do
  response.headers['Allow'] = 'HEAD,GET,PUT,POST,DELETE,OPTIONS'
  response.headers['Access-Control-Allow-Headers'] =
    'X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept'
  200
end

post '/purchase' do
  content_type :json

  json = JSON.parse(request.body.read)
  result = OrderProcessor.process(json)

  if result.success?
    [200, { number: result.value.number }.to_json]
  else
    Mailer.error(result.value, request)
    [500, { message: result.value.message }.to_json]
  end
end

post '/reset' do
  Resources.reset
  halt 200
end

post '/test-mail' do
  Mailer.test
  halt 200
end
