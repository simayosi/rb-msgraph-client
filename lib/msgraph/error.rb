# frozen_string_literal: true

module MSGraph
  # Error from Microsoft Graph.
  class Error < StandardError
    # @return [Net::HTTPResponse] the HTTP response.
    attr_reader :response
    # @return [String, Hash] the parsed body of the response in JSON case,
    #   otherwise the raw body.
    attr_reader :body
    # @return [Hash] the parsed error property.
    attr_reader :error

    # @param [Net::HTTPResponse] res the HTTP response
    def initialize(res)
      @response = res
      if res.content_type&.start_with? 'application/json'
        @body = JSON.parse(res.body, symbolize_names: true)
        @error = @body[:error]
      else
        @body = res.body
      end
      super("#{res.code}: #{res.message}\n#{@body}")
    end
  end
end
