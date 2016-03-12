require 'httparty'
require 'active_support/core_ext/hash/indifferent_access'
require 'json'

module AlphaHang
  module WebProxy
    def post(host, body, headers)
      response = HTTParty.post(host, body: body.to_json, headers: headers)

      validate!(response)

      parse(response)
    end

    private

      def validate!(response)
        raise response unless response.code == 200
      end

      def parse(response)
        JSON.parse(response.body).with_indifferent_access
      end
  end
end
