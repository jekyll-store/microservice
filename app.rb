require 'sinatra'
require 'sinatra/cross_origin'
require 'json'
require_relative 'lib/processor'
require_relative 'lib/resources'
require_relative 'lib/mailer'
require_relative 'lib/environment'

Environment.set

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
  order = Processor.process(json)
  { number: order.number }.to_json
end

post '/reset' do
  Resources.reset
  halt 200
end

get '/test-mail' do
  Mailer.test
  halt 200
end

get '/ping' do
  halt 200
end

error do
  content_type :json
  Mailer.error(env['sinatra.error'], request)
  { message: env['sinatra.error'].message }.to_json
end
