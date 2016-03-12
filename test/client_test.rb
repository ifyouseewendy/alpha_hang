require 'test_helper'

class ClientTest < Minitest::Test
  attr_reader :client

  def setup
    @client = AlphaHang::Client.new do |config|
      config.request_url = ENV['REQUEST_URL']
      config.player_id   = ENV['PLAYER_ID']
    end
  end

  def test_start_game
    VCR.use_cassette("test_start_game") do
      response = client.start_game

      assert_instance_of Hash, response
      assert_instance_of String, response[:sessionId]
      assert response.has_key?(:data)
    end
  end

  def test_next_word
    VCR.use_cassette("test_start_game") do
      client.start_game

      VCR.use_cassette("test_next_word") do
        response = client.next_word

        assert_instance_of Hash, response
        assert_instance_of client.session_id, response[:sessionId]
        assert response.has_key?(:data)
      end
    end
  end

  def test_guess_word
    VCR.use_cassette("test_start_game") do
      client.start_game

      VCR.use_cassette("test_next_word") do
        client.next_word

        VCR.use_cassette("test_guess_word") do
          response = client.guess_word('P')

          assert_instance_of Hash, response
          assert_instance_of client.session_id, response[:sessionId]
          assert response.has_key?(:data)
        end
      end
    end
  end

  def test_get_result
    VCR.use_cassette("test_start_game") do
      client.start_game

      VCR.use_cassette("test_next_word") do
        client.next_word

        VCR.use_cassette("test_get_result") do
          response = client.get_result

          assert_instance_of Hash, response
          assert_instance_of client.session_id, response[:sessionId]
          assert response.has_key?(:data)
        end
      end
    end
  end

  def test_submit_result
    VCR.use_cassette("test_start_game") do
      client.start_game

      VCR.use_cassette("test_next_word") do
        client.next_word

        VCR.use_cassette("test_get_result") do
          response = client.submit_result

          assert_instance_of Hash, response
          assert_instance_of client.session_id, response[:sessionId]
          assert response.has_key?(:data)
        end
      end
    end
  end
end
