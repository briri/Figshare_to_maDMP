# frozen_string_literal: true

require 'httparty'

# This module retrieves JSON from the FigShare API
module Figshare
  def authenticate
    # TODO: need some logic to pay attention to token expiration
    return @token unless @token.nil?

    target = "#{settings.figshare[:base_api_url]}#{settings.figshare[:token_path]}"
    resp = HTTParty.post(target, body: credentials)
    return false unless resp.code == 200

    json = JSON.parse(resp.body)
    @token = { Authorization: "token #{json['token']}" }
    true
  rescue JSON::ParserError => e
    p "Unable to parse the JSON response! #{e.message}"
    false
  end

  def search(term:)
    authenticate if @token.nil?
    target = "#{settings.figshare[:base_api_url]}#{settings.figshare[:search_path]}"
    resp = HTTParty.post(target, body: { search_for: term }.to_json, headers: @token)
    return resp.body unless resp.code == 200

    JSON.parse(resp.body)
  rescue JSON::ParserError => e
    p "Unable to parse the JSON response! #{e.message}"
    resp.body
  end

  def fetch_item(url:)
    authenticate if @token.nil?
    resp = HTTParty.get(url, headers: @token)
    return [] unless resp.code == 200

    JSON.parse(resp.body)
  rescue JSON::ParserError => e
    p "Unable to parse the JSON response! #{e.message}"
    []
  end

  def credentials
    {
      grant_type: 'password',
      username: settings.figshare[:username],
      password: settings.figshare[:password],
      client_id: settings.figshare[:client_id],
      client_secret: settings.figshare[:client_secret]
    }
  end
end
