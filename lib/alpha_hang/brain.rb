module AlphaHang
  class Brain
    attr_reader :dictionary, :word_length
    attr_accessor :data_set, :choices, :exclusions

    def initialize(dict)
      @dictionary = File.read(dict).split

      clear!
    end

    def query(guess)
      set_word_length(guess.length) if word_length.nil?

      yield_letter(guess)
    end

    def confirm(guess)
      filter_by_matching!(guess)
    end

    def exclude(char)
      filter_by_exclusion!(char)
    end

    def clear!
      set_word_length(nil)
    end

    private

      def set_word_length(length)
        @word_length = length
        @data_set    = filter_by_length
      end

      def filter_by_length
        return dictionary if word_length.nil?

        dictionary.select{|word| word.length == word_length}.map(&:upcase).uniq
      end

      def yield_letter(guess)
        positions = find_star_postions_from(guess)
        choices   = make_analysis_on(positions)
        choices.first
      end

      def filter_by_exclusion!(char)
        ch = char.upcase
        self.data_set = data_set.reject{|word| word.index(ch) }
      end

      def filter_by_matching!(guess)
        chars   = guess.upcase.chars
        charset = chars.reject{|c| c == '*'}.uniq

        self.data_set = data_set.select do |word|
          flag = true

          word.chars.each_with_index do |char, idx|
            if '*' == chars[idx]
              flag = false if charset.include?(char)
            else
              flag = false unless char == chars[idx]
            end

            break unless flag
          end

          flag
        end
      end

      def find_star_postions_from(str)
        str.chars.each_with_index.reduce([]) do |ar, (char,idx)|
          char == '*' ? ar << idx : ar
        end
      end

      def make_analysis_on(positions)
        hash = Hash.new(0)

        self.data_set.each do |word|
          word.chars.each_with_index do |char, idx|
            hash[char] += 1 if positions.include? idx
          end
        end

        # Sort by frequency first, then alphabetic
        hash\
          .sort{|a,b| a[1] == b[1] ? a[0] <=> b[0] : b[1] <=> a[1]}
          .map(&:first)
      end

  end
end
