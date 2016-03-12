require 'test_helper'

class BrainTest < Minitest::Test
  attr_reader :brain

  def setup
    @brain = AlphaHang::Brain.new(ENV['DICT'])
  end

  def test_that_it_has_a_version_number
    refute_nil ::AlphaHang::VERSION
  end

  def test_strategy_manually
    assert_equal 235886, brain.data_set.count

    word   = 'hi'
    guess  = word.tr('a-zA-Z', '*')

    # Frequency
    #
    # {
    #   "A" => 36,
    #   "O" => 31,
    #   "E" => 27,
    #   "I" => 21,
    #   "U" => 20,
    #   ...

    assert_equal  'A', brain.query(guess)
    brain.exclude 'A'

    # Set word_length and filter data_set after first query
    assert_equal 2,   brain.word_length
    assert_equal 139, brain.data_set.count

    assert_equal  'O', brain.query(guess)
    brain.exclude 'O'

    assert_equal  'E', brain.query(guess)
    brain.exclude 'E'

    assert_equal  'I', brain.query(guess)

    guess = '*i'
    brain.confirm(guess)

    # Reduce data_set after confirmation
    assert_equal 14, brain.data_set.count

    # Frequency
    #
    # {
    #   "A" => 1, # exclude
    #   "D" => 1,
    #   "F" => 1,
    #   "G" => 1,
    #   "H" => 1,

    assert_equal  'D', brain.query(guess)
    brain.exclude 'D'

    assert_equal  'F', brain.query(guess)
    brain.exclude 'F'

    assert_equal  'G', brain.query(guess)
    brain.exclude 'G'

    assert_equal  'H', brain.query(guess)

    guess = 'hi'
    brain.confirm(guess)

    # BINGO!
  end

  def test_word_length_less_than_5
    skip
  end

  def test_word_length_less_than_8
    skip
  end

  def test_word_length_less_than_12
    skip
  end

  def test_word_length_more_than_12
    skip
  end
end
