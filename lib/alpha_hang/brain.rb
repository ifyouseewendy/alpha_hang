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
      make_choices_from(guess) if choices.empty?

      choices.first
    end

    def confirm(guess)
      self.data_set     = get_candidates_from(guess)
      self.choices      = []
      self.exclusions  += guess.chars.map(&:upcase).delete_if{|c| c == '*'}
    end

    def exclude(char)
      self.exclusions << char
      self.choices = choices - exclusions
    end

    def clear!
      set_word_length(nil)
      @choices     = []
      @exclusions  = []
    end

    private

      def set_word_length(length)
        @word_length = length
        @data_set    = filter_dictionary_by_length
      end

      def filter_dictionary_by_length
        return dictionary if word_length.nil?

        dictionary.select{|word| word.length == word_length}.map(&:upcase).uniq
      end

      def make_choices_from(guess)
        candidates   = get_candidates_from(guess)
        positions    = find_star_postions_from(guess)
        self.choices = make_analysis_on(candidates, positions)
      end

      def get_candidates_from(guess)
        regexp = make_regexp(guess)
        data_set.select{|word| word =~ regexp}
      end

      def find_star_postions_from(str)
        str.chars.each_with_index.reduce([]) do |ar, (char,idx)|
          char == '*' ? ar << idx : ar
        end
      end

      def make_regexp(str)
        Regexp.new str.gsub('*', '.').upcase
      end

      def make_analysis_on(words, positions)
        hash = Hash.new(0)

        words.each do |word|
          word.chars.each_with_index do |char, idx|
            next if exclusions.include?(char) or !(positions.include? idx)

            hash[char] += 1
          end
        end

        # Sort by frequency first, then alphabetic
        hash.sort{|a,b| a[1] == b[1] ? a[0] <=> b[0] : b[1] <=> a[1]}.map(&:first)
      end

  end
end
