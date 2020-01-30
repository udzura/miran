require "prometheus/api_client"
require "json"

module Miran
  class ClientError < StandardError
  end

  class Client
    def initialize(query, params: {})
      api = params["api"] || "http://localhost:9090"
      @client = Prometheus::ApiClient.client(url: api)
      @query = query
      @duration = params["duration"]&.to_i || 3600 # in seconds
      @step = params["step"] || "120s"
    end

    def prom_data
      now = Time.now
      r = @client.get(
        'query_range',
        query: @query,
        start: now.to_i,
        end: (now - @duration).to_i,
        step: @step
      )
      if r.status != 200
        raise ClientError, "Request to prom API failed: #{r.body}"
      end

      JSON.parse(r.body)
    end
  end
end
