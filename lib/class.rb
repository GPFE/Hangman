require 'json'

class Hangman
  def initialize(random_words)
    @random_words = random_words
    @current_word_idx = 0
    @wrong_gueses = []
    @max_mistakes = 10
  end

  def play
    new_board = true

    puts "Do you wanna continue from where you ended?"
    answer = gets.chomp
    if answer == "y" || answer == "Y"
      load_progress
      new_board = false
    end
    while @current_word_idx < @random_words.size
      new_board == true ? generate_board : new_board = true
      display_board

      loop do
        turn
        display_board
        if check_for_end == true
          break
        end
      end
      @current_word_idx += 1
      @wrong_gueses = []
    end
    puts "the game has ended"
  end

  def load_progress
    begin
      data = File.read("data.json")
      data = JSON.parse(data)

      @random_words = data["random_words"]
      @current_word_idx = data["current_word_idx"]
      @wrong_gueses = data["wrong_gueses"]
      @gues_array = data["gues_array"]
      @random_word = @random_words[@current_word_idx]
    rescue
      puts "No data found."
    end
  end

  private

  def to_json
    JSON.dump(to_hash)
  end

  def save_progress
    file = File.open("data.json", "w")
    file.puts to_json
  end

  def to_hash
    data = {
      random_words: @random_words,
      current_word_idx: @current_word_idx,
      wrong_gueses: @wrong_gueses,
      gues_array: @gues_array
    }
  end

  def generate_board
    @random_word = @random_words[@current_word_idx]
    @length = @random_word.size
    @gues_array = Array.new(@length, "_")
  end

  def display_board
    puts "*****************"
    puts @gues_array.join(" ")
    puts "errors(#{@wrong_gueses.size}/#{@max_mistakes}): #{@wrong_gueses.join(", ")}" unless @wrong_gueses.size == 0
  end

  def turn
    gues = gets.chomp.downcase

    if gues == "save"
      save_progress
    end
    while gues.size != 1 || @wrong_gueses.include?(gues) || @gues_array.include?(gues) do
      gues = gets.chomp.downcase
    end

    check_for_letter(gues)
  end

  def check_for_letter(gues)
    if @random_word.include?(gues) == false
      @wrong_gueses << gues
      puts "wrong gues"
    else
      puts "correct"
      @random_word.split("").each_with_index do |letter, idx|
        if letter == gues
          @gues_array[idx] = letter
        end
      end
    end
  end

  def check_for_end
    if @wrong_gueses.size > @max_mistakes
      puts "You lose."
      true
    elsif @gues_array.join("") == @random_word
      puts "You won."
      true
    end
  end
end