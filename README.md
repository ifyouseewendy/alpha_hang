# AlphaHang

A Ruby-based AI against Hangman.

## Usage

```ruby
bin/run
```

## Specification

+ *AlphaHang::Client* is an API client, starting game, making a guess, etc.
+ *AlphaHang::Brain* is the strategy maker.
+ *AlphaHang::AI* is the AI, leveraging both client and brain to fight against Hangman server.

## AI

To make AI utilizes client and brain, there is a need to pass some ENV variables. I use `dotenv` in development. (Note, I've already packed a dict file in resources/words, from [dwyl/english-words](https://github.com/dwyl/english-words))

```
# .env
REQUEST_URL={YOUR_REUQEST_URL}
PLAYER_ID={YOUR_PLAYER_ID}
DICT={DIC_FILE_PATH}
```

Start to play

```ruby
ai = AlphaHang::AI.new
ai.start
```

## Client

Initialization

```ruby
client = AlphaHang::Client.new do |config|
  config.request_url = ENV['REQUEST_URL']
  config.player_id   = ENV['PLAYER_ID']
end
```

API

```ruby
client.start_game
client.next_word
client.guess_word('P')
client.get_result
client.submit_result
```

## Brain

Initialization

```ruby
dict = '/usr/share/dict/words'
brain = AlphaHang::Brain.new(dict: dict)

brain.query('*****') # => 'e'
brain.query('*e**o') # => 'h'
```

**Strategy underground**

Brain is working based on three known conditions:

+ Length of word
+ Letters not in word
+ Letters in word and their positions

![brain](/resources/brain.png)

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

