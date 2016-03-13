# AlphaHang

A Ruby-based AI against Hangman.

## Usage

```ruby
bin/run
```

### Specification

+ *AlphaHang::Client* is an API client, starting game, making a guess, etc.
+ *AlphaHang::Brain* is a strategy maker.
+ *AlphaHang::AI* is an AI, leveraging both client and brain to fight against Hangman server.

### AI

To make AI utilizes client and brain, there is a need to pass some ENV variables. I use `dotenv` in development. (I've already packed a dict file in resources/words, from [dwyl/english-words](https://github.com/dwyl/english-words))

```
# .env
REQUEST_URL={YOUR_REUQEST_URL}
PLAYER_ID={YOUR_PLAYER_ID}
DICT={DICT_FILE_PATH}
```

Start to play

```ruby
ai = AlphaHang::AI.new
ai.start
```

### Client

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

### Brain

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

## Changelog

*v0.2.0*

+ Set up code structure
+ Set up workflow

```
{
  "totalWordCount"=>80,
  "correctWordCount"=>45,
  "totalWrongGuessCount"=>247,
  "score"=>653
}
```

*v1.0.0*

+ Optimize brain strategy and workflow
+ Use a bigger dictionary

```
{
  "totalWordCount"=>80,
  "correctWordCount"=>77,
  "totalWrongGuessCount"=>203,
  "score"=>1337
}
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

