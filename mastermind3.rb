# class defining methods for the gameplay
class Game
  def initialize
    @code_maker = player_role_selection == '1' ? 'computer' : 'player'
    create_code

    puts "\n  Let the game begin!\n  -------------------\n\n"

    start_guess_loop
    play_again
  end

  def player_role_selection
    puts "\n  Welcome to Mastermind!"
    puts "  ----------------------\n\n"
    puts '  Would you like to be the Code Maker or the Code Breaker?'

    input = ''
    until %w[1 2].include?(input)
      print "  Enter '1' for Code Breaker or '2' for Code Maker: "
      input = gets.chomp
    end
    input
  end

  def code_breaker_rules_description
    puts '  The computer has generated a 4 digit secret code using the digits 1-6.'
    puts '  Your goal is to guess this code in 10 guesses or less.'
    puts "\n  After each guess, you will be given clues about the code: "
    puts "    Each 'O' means that you have 1 correct number in the correct position"
    puts "    Each 'X' means that you have 1 correct number in the wrong position"
    puts "\n  You have 12 attempts to find the secret code. Good luck!\n"
  end

  def create_code
    if @code_maker == 'player'
      @code = Player.player_choose_code
    elsif @code_maker == 'computer'
      @code = Computer.computer_generate_code
    end
  end

  def start_guess_loop
    if @code_maker == 'player'
      Computer.guess_loop(@code_maker, @code)
    elsif @code_maker == 'computer'
      Player.guess_loop(@code_maker, @code)
    end
  end

  def play_again
    puts '  Would you like to play again?'
    again = ''
    until %w[y n].include?(again)
      print "  Enter 'y' to play again or 'n' to quit: "
      again = gets.chomp.downcase
    end
    again == 'y' ? Game.new : @code_maker = 'player'
  end
end

# class defining methods for the human player
class Player
  def self.player_choose_code
    @code = []
    print "  Enter a 4 digit secret code using digits 1-6 for the computer to guess. \n\n  Secret code: "
    @code = gets.chomp.split('')
    until @code.all? { |digit| digit.to_i.between?(1, 6) } && @code.size == 4
      print "  Invalid code! Please enter a 4 digit code using digits 1-6.\n\n  Secret code: "
      @code = gets.chomp.split('')
    end

    puts "\n  Your secret code is: #{@code}"
    @code
  end

  def self.guess_loop(code_maker, code)
    attempt = 1
    while attempt <= 12
      print "\n  Attempt ##{attempt}: "
      @guess = Player.get_guess(attempt)
      results = Results.display_results(code, @guess)

      GameOverCheck.check(code_maker, results, attempt, code) ? break : Results.print_results(@guess, results, attempt)

      attempt += 1
    end
  end

  def self.get_guess(attempt)
    guess = gets.chomp.split('')
    until guess.all? { |digit| digit.to_i.between?(1, 6) } && guess.size == 4
      puts '  Invalid guess! Please enter a 4 digit code using digits 1-6.'
      print "  Attempt ##{attempt}: "
      guess = gets.chomp.split('')
    end
    guess
  end
end

# class defining methods for the computer player
class Computer
  def self.computer_generate_code
    @code = []
    4.times { @code.push(rand(1..6)) }
    @code.join.split('')
  end

  def self.guess_loop(code_maker, code)
    attempt = 1
    array_of_possibilities = create_array

    while attempt <= 12
      @guess = array_of_possibilities[0]

      results = Results.display_results(code, @guess)
      sleep(1)
      Results.print_results(@guess, results, attempt)

      GameOverCheck.check(code_maker, results, attempt, code) ? break : results = CheckCode.results(code, @guess)

      i = array_of_possibilities.length - 1
      while i >= 0
        possible_results = CheckCode.results(@guess, array_of_possibilities[i])
        array_of_possibilities.delete_at(i) unless results == possible_results
        i -= 1
      end
      attempt += 1
    end
  end

  def self.create_array
    source = %w[1 2 3 4 5 6]
    source.repeated_permutation(4).to_a
  end
end

# class defining methods for displaying nad printing the results of a guess
class Results
  def self.display_results(code, guess)
    @code = Marshal.load(Marshal.dump(code))
    @guess = Marshal.load(Marshal.dump(guess)).map(&:to_s)
    @results = ''

    i = 0
    while i < @code.length
      if @code[i] == @guess[i]
        @results << 'O'
        @code.delete_at(i)
        @guess.delete_at(i)
      else
        i += 1
      end
    end

    diff = @code - (@code - @guess)
    j = 0
    while j < diff.length
      @results << 'X'
      j += 1
    end
    @results
  end

  def self.print_results(guess, results, attempt)
    puts "\n              Guess: #{guess}"
    puts "              Clues: #{results}\n"
    puts "  Guesses remaining: #{12 - attempt} \n"
  end
end

# class defining methods to check the results of the code with a guess
class CheckCode
  def self.results(code, guess)
    @results = ''

    (0...code.length).each do |i|
      if code[i] == guess[i]
        @results << 'O'
      elsif code[i] == guess[0] || guess[1] || guess[2] || guess[3]
        @results << 'X'
      end
    end
    @results
  end
end

# class defining a method to check if the game is over
class GameOverCheck
  def self.check(code_maker, results, attempt, code)
    if results == 'OOOO'
      if code_maker == 'computer'
        puts "  Great job! You figured out the code in #{attempt} guesses."
      else
        puts "\n  The computer deciphered your code in #{attempt} guesses."
        puts "  Better luck next time.\n\n"
      end
      true
    elsif attempt == 12
      if code_maker == 'player'
        puts '  Great job! The computer failed to decipher your code!'
      else
        puts "\n  Good effort, but you failed to guess the code."
        puts "  The secret code was: #{code}."
        puts "  Better luck next time.\n\n"
      end
      true
    else
      false
    end
  end
end

Game.new
