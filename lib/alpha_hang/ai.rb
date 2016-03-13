module AlphaHang
  class AI
    attr_reader :client, :brain
    attr_accessor :info

    def initialize
      @client = AlphaHang::Client.new do |config|
        config.request_url = ENV['REQUEST_URL']
        config.player_id   = ENV['PLAYER_ID']
      end

      @brain = AlphaHang::Brain.new(ENV['DICT'])

      @info = {}
    end

    def start
      resp = client.start_game
      data = resp[:data]

      self.info[:rounds]        = data[:numberOfWordsToGuess]
      self.info[:guess_allowed] = data[:numberOfGuessAllowedForEachWord]

      self.info[:rounds].times do |idx|
        puts "--> Round ##{idx}"
        play_a_round
      end

      info[:score]
    end

    def submit
      client.submit_result
    end

    private

      def play_a_round
        brain.clear!

        word = fetch_word

        guess_tried     = 0
        guess_incorrect = 0

        # Guess word
        loop do
          puts "----> ##{guess_tried} word: #{word}"
          begin
            letter = brain.query(word)
            if letter.nil?
              puts "--> Failed on brain burns, word: #{word}, #{guess_incorrect}/#{guess_tried}"
              break
            end

            resp   = client.guess_word(letter)
            data   = resp[:data]
            guess_tried += 1

            if word == data[:word]
              # Incorrect guess
              brain.exclude(letter)
            else
              # Correct guess
              word = data[:word]
              brain.confirm(word)
            end

            guess_incorrect = data[:wrongGuessCountOfCurrentWord]

            if word.index('*').nil?
              # Succeed
              puts "--> Succeed on word #{word}, #{guess_incorrect}/#{guess_tried}"
              break
            end

            if guess_incorrect >= info[:guess_allowed]
              # Boomed
              puts "--> Failed on word #{word}, #{guess_incorrect}/#{guess_tried}"
              break
            end
          rescue => e
            puts "--> Retried when guessing word: #{e.message}"
            retry
          end
        end

        data = client.get_result[:data]
        self.info[:score] = data[:score]

        puts data
      end

      def fetch_word
        # Fetch next word
        begin
          resp = client.next_word
          word = resp[:data][:word]
        rescue => e
          puts "--> Retried when fetching next_word: #{e.message}"
          retry
        end

        word
      end

  end
end
