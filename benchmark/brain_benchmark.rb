# 2015-03-12 Avg: 10.6 (data set: 50)

require 'terminal-table'
require File.expand_path('../../lib/alpha_hang', __FILE__)

def print(result)
  data = result.sort_by{|ar| ar[1]}

  total_wronged = data.map{|ar| ar[2]}.reduce(:+)
  total_tried   = data.map{|ar| ar[3]}.reduce(:+)
  total_rate    = "%s %" % (total_wronged*100.0/total_tried).round(1)

  avg_wronged = (total_wronged.to_f/data.count).round(1)
  avg_tried   = (total_tried.to_f/data.count).round(1)

  data << :separator
  data << [nil, nil, avg_wronged, avg_tried, total_rate]

  table = Terminal::Table.new :headings => ['Word', 'Length', 'Wrong', 'Tried', 'Rate'], :rows => data
  puts table
end

def guess(brain, word)
  brain.clear!
  word.upcase!

  guess  = word.tr('a-zA-Z', '*')

  tried = 0
  wronged = 0

  loop do
    break if guess == word

    letter = brain.query(guess)

    unless word.index(letter)
      brain.exclude(letter)
      wronged += 1
    else
      word.chars.each_with_index do |char, idx|
        guess[idx] = letter if char == letter
      end

      brain.confirm(guess)
    end

    tried += 1
  end

  [wronged, tried]
end

words  = DATA.read.split
result = []

dict  = File.expand_path('../../resources/words', __FILE__)
brain = AlphaHang::Brain.new(dict)

words.each do |word|
  wronged, tried = guess(brain, word)
  rate = "%s %" % (wronged*100.0/tried).round(1)

  result << [word, word.length, wronged, tried, rate]
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
