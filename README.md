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

Find the letter which has most frequencies in all '*' positions.

Suppose we are guessing `'hello'`. After serveral guesses, we got `'*e**o'` confirmed, and `'abc'` exclueded. Now there are 10 words located in our dictionary:

```
'cello'
'cento'
'gecko'
'hello'
'lento'
'mezzo'
'negro'
'recco'
'serio'
'sexto'
```

*What should we guess now?*

First, we'll scan each `'*'` position, sort by occurences

```
position 0 | c - 2 |   position 2 | c - 2 |  position 3 | t - 3 |
           | s - 2 |              | l - 2 |             | l - 2 |
           | g - 1 |              | n - 2 |             | c - 1 |
           | h - 1 |              | g - 1 |             | i - 1 |
           | l - 1 |              | r - 1 |             | k - 1 |
           | m - 1 |              | x - 1 |             | r - 1 |
           | n - 1 |              | z - 1 |             | z - 1 |
           | r - 1
```

Second, filter the exclusion

```
position 0 | s - 2 |   position 2 | l - 2 |  position 3 | t - 3 |
           | g - 1 |              | n - 2 |             | l - 2 |
           | h - 1 |              | g - 1 |             | i - 1 |
           | l - 1 |              | r - 1 |             | k - 1 |
           | m - 1 |              | x - 1 |             | r - 1 |
           | n - 1 |              | z - 1 |             | z - 1 |
           | r - 1 |
```

Third, return the letter has the most occurences, `'t'`. If not fitted, try the second occurenced letter, `'l'`.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

