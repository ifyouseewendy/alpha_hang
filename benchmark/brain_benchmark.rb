# 2015-03-12 Avg: 10.6 (data set: 50)

require 'terminal-table'
require File.expand_path('../../lib/alpha_hang', __FILE__)

def print(result)
  data = result.sort_by{|ar| ar[1]}

  table = Terminal::Table.new :headings => ['Word', 'Length', 'Query Count'], :rows => data
  puts table

  avg_count = (data.map(&:last).reduce(:+).to_f / data.count).round(1)
  puts "--> Avg: #{avg_count}"
end

def guess(brain, word)
  brain.clear!
  word.upcase!

  count = 0
  guess  = word.tr('a-zA-Z', '*')

  loop do
    break if guess == word

    letter = brain.query(guess)

    unless word.index(letter)
      brain.exclude(letter)
    else
      word.chars.each_with_index do |char, idx|
        guess[idx] = letter if char == letter
      end

      brain.confirm(guess)
    end

    count += 1
  end

  count
end

words  = DATA.read.split
result = []

dict  = File.expand_path('../../resources/words', __FILE__)
brain = AlphaHang::Brain.new(dict)

words.each do |word|
  count = guess(brain, word)

  result << [word, word.length, count]
end

print(result)

__END__
lavacre
semibarbarous
Deino
presettlement
unpolemically
benting
foredeck
macracanthrorhynchiasis
overcape
imputable
Witbooi
noumenalist
cape
woodruff
technism
enarched
immensive
vociferous
caudices
microcosmical
commissionership
foundationer
interversion
antipatriarchal
merrythought
gaudless
pyramidoattenuate
coarbitrator
belcher
bargoose
Palaeoniscus
knock
collectedly
jowel
expressiveness
crochet
spongiose
limitedness
Abasgi
regentess
semestral
Avesta
unshivering
topsailite
demiracle
zenithward
topesthesia
cathetometer
grouseward
Furlan
