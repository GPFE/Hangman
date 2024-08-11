require_relative 'lib/class.rb'

def clean_array(array)
  array.map do |element|
    element.gsub!(/\n/, "")
  end
  array = array.filter do |element|
    element.size >= 5 && element.size <= 12
  end
end
def get_random_words(array, word_list, count = 5)
  count.times do
    array << word_list[rand(word_list.size)]
  end
end

file = File.readlines("google-10000-english-no-swears.txt")
file = clean_array(file)
random_words = []
get_random_words(random_words, file)
p random_words

game = Hangman.new(random_words)
game.play