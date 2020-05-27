# frozen_string_literal: true

require 'sinatra'
require 'sinatra/config_file'

require_relative './services/figshare'
require_relative './services/rda_madmp'

config_file 'config/settings.yml'

include Figshare
include RdaMadmp

# Homepage
get '/' do
  erb :index
end

post '/search' do
  @results = []
  search(term: params['term']).each do |result|
    next unless result['url_public_api'].is_a?(String)

    @results << fetch_item(url: result['url_public_api'])
  end
  @results = @results.sort { |a, b| a['defined_type_name'] <=> b['defined_type_name'] }
  erb :results
end

get '/convert' do
  JSON.pretty_generate(transform(json: fetch_item(url: params['url'])))
end
