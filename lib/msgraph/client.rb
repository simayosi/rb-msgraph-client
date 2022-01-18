# frozen_string_literal: true

require 'net/http'
require 'json'

require 'msgraph/error'

module MSGraph
  SCOPE = 'https://graph.microsoft.com/.default'
  NEXT_LINK_KEY = :'@odata.nextLink'

  # Simple client for Microsoft Graph.
  class Client
    # Create a new client object.
    #
    # @param [Boolean] symbolize_names whether hash keys of API responses are
    #     symbolized.
    def initialize(symbolize_names: true)
      @symbolize_names = symbolize_names
    end

    # @return [Boolean] whether hash keys of API responses are symbolized.
    attr_accessor :symbolize_names

    # Calls an API and returns the parsed response.
    #
    # @param [String, Symbol] command the HTTP method used on the request.
    # @param [String] path the path of the calling endpoint, and query if
    #     necessary.
    # @param [#to_s] token an access token.
    # @param [Object] data an object to be converted to JSON for the request
    #     body.
    # @param [Hash] header optional headers.
    def request(command, path, token, data = nil, header = nil)
      req = Net::HTTPGenericRequest.new(
        command.to_s.upcase, !data.nil?, true, url(path), header
      )
      res = http_request(req, token, data)
      raise Error, res unless res.is_a? Net::HTTPSuccess
      raise Error, res unless res.content_type&.start_with? 'application/json'

      JSON.parse(res.body, symbolize_names: @symbolize_names)
    end

    private

    BASE_URL = URI.parse('https://graph.microsoft.com').freeze
    private_constant :BASE_URL

    def url(path)
      BASE_URL.merge(path)
    end

    def http_request(request, token, data = nil)
      request['Authorization'] = "Bearer #{token}"
      request['Accept'] = 'application/json'
      if data
        request.content_type = 'application/json; charset=utf-8'
        body = JSON.generate(data)
      else
        body = nil
      end
      http.request(request, body)
    end

    def http
      @http ||= Net::HTTP.new(BASE_URL.host, BASE_URL.port).tap do |http|
        http.use_ssl = true
        http.min_version = OpenSSL::SSL::TLS1_2_VERSION
      end
    end
  end
end
