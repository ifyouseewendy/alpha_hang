require_relative 'web_proxy'

module AlphaHang
  class Client
    include WebProxy

    Configuration = Struct.new(:request_url, :player_id)

    attr_reader :config
    attr_accessor :session_id

    def initialize
      @config = Configuration.new
      yield @config
    end

    def start_game
      body = {
        playerId: config.player_id,
        action: "startGame"
      }
      resp = post(host, body, headers)

      self.session_id = resp[:sessionId]

      resp
    end

    def next_word
      body = {
        sessionId: session_id,
        action: "nextWord"
      }
      post(host, body, headers)
    end

    def guess_word(letter)
      body = {
        sessionId: session_id,
        action: "guessWord",
        guess: letter.upcase
      }
      post(host, body, headers)
    end

    def get_result
      body = {
        sessionId: session_id,
        action: "getResult",
      }
      post(host, body, headers)
    end

    def submit_result
      body = {
        sessionId: session_id,
        action: "submitResult",
      }
      post(host, body, headers)
    end

    private

      def host
        config.request_url
      end

      def headers
        @_headers ||= { "Content-Type" => 'application/json' }
      end

  end
end
