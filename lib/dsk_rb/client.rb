module DskRb
  class Client
    BASE_URLS = {
      uat: 'https://uat.dskbank.bg'
    }.freeze

    def initialize(username:, password:, environment:)
      @username = username
      @password = password
      @environment = environment.to_sym

      validate_environment

      @base_url = BASE_URLS[@environment]
    end

    def payment_registration(params)
      camelized_params = params.transform_keys { |key| key.to_s.camelize(:lower) }

      response = connection.post('/payment/rest/register.do') do |req|
        req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
        req.body = URI.encode_www_form(default_params.merge(camelized_params))
      end

      JSON.parse(response.body)
    end

    private

    attr_reader :username, :password, :environment, :base_url

    ALLOWED_ENVIRONMENTS = %i[uat].freeze
    private_constant :ALLOWED_ENVIRONMENTS

    def validate_environment
      return if ALLOWED_ENVIRONMENTS.include?(environment)

      raise(
        ArgumentError,
        "Invalid environment: #{environment}. Allowed environments: #{ALLOWED_ENVIRONMENTS.join(", ")}"
      )
    end

    def connection
      @connection ||= Faraday.new(url: base_url, headers: default_headers) do |conn|
        conn.adapter Faraday.default_adapter
        conn.response :json
        conn.response :raise_error
        conn.request :url_encoded
      end
    end

    def default_headers
      {
        'Content-Type' => 'application/x-www-form-urlencoded'
      }
    end

    def default_params
      {
        'userName' => username,
        'password' => password
      }
    end
  end
end
