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

    # Filter data set by word length after first query
    assert_equal 'A', brain.query(guess)
    assert_equal 2,   brain.word_length
    assert_equal 139, brain.data_set.count

    # Filter data set by excluding letter
    brain.exclude 'A'
    assert_equal 104, brain.data_set.count

    # Frequency
    #
    # {
    #   "O" => 30,
    #   "E" => 25,
    #   "I" => 20,
    #   "U" => 20,

    assert_equal  'O', brain.query(guess)
    brain.exclude 'O'

    assert_equal  'E', brain.query(guess)
    brain.exclude 'E'

    assert_equal  'U', brain.query(guess)
    brain.exclude 'U'

    assert_equal  'I', brain.query(guess)

    guess = '*i'
    brain.confirm(guess)

    # Reduce data_set after confirmation
    assert_equal 13, brain.data_set.count

    # Frequency
    #
    # {
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
end
