require 'test_helper'

class AlphaHangTest < Minitest::Test
  attr_reader :ai
  def setup
    @ai = AlphaHang::AI.new
  end

  def test_client_setup
    assert_instance_of AlphaHang::Client, ai.client
  end

  def test_brain_setup
    assert_instance_of AlphaHang::Brain, ai.brain
  end

  def test_that_it_has_a_version_number
    refute_nil ::AlphaHang::VERSION
  end
end
