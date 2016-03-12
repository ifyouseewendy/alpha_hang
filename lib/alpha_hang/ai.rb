module AlphaHang
  class AI
    attr_reader :client, :brain

    def initialize
      @client = AlphaHang::Client.new do |config|
        config.request_url = ENV['REQUEST_URL']
        config.player_id   = ENV['PLAYER_ID']
      end

      @brain = AlphaHang::Brain.new(ENV['DICT'])
    end
  end
end
