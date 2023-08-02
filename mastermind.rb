module Mastermind
  class Game

    def initialize
      puts "Welcome to Mastermind!"
      puts "----------------------\n\n"
      puts "Would you like to be the Code Maker or the Code Breaker?"
      print "Enter '1' for Code Maker or '2' for Code Breaker: "

      input = gets.chomp.to_i

      until input == 1 || input == 2
        puts "Invalid input! Try again!"
        print "Enter '1' for Code Maker or '2' for Code Breaker: "
        input = gets.chomp.to_i
      end

      @player_role = select_role(input)
      puts "\nYou have selected \"#{@player_role}\""
      if @player_role == "Code Maker"
        puts "Enter a 4 digit secret code using digits 1-6 for the computer to guess. "
        print "Secret code: "
        @code = choose_code
        puts "\nYour secret code is: #{@code}"
      elsif @player_role == "Code Breaker"
        puts "The computer has generated a 4 digit secret code using the digits 1-6."
        puts "Your goal is to guess this code in 10 guesses or less."
        puts "After each guess, you will be provided with the results of your guess."
        puts "An 'O' indicates your guess contains a correct digit in the correct position."
        puts "An 'X' indicates your guess contains a correct digit, but in the wrong position."
        puts "The results will be in no particular order."
        @code = generate_code
      end

      puts "\nLet the game begin!"
      puts "----------------------\n\n"

      @remaining_guesses = 12

      if @player_role == "Code Breaker"
        # player is the guesser
      elsif @player_role == "Code Breaker"
        # computer is the guesser
      end


    end

    def generate_code
      code = Array.new
      4.times { code.push(rand(1..6)) }
      code.join.split('')
    end

    def choose_code
      code = gets.chomp.split('')
      until (code.all? { |digit| digit.to_i <= 6 && digit.to_i >= 1} && code.size == 4)
        puts "Invalid code! Please enter a 4 digit code using digits 1-6."
        print "Secret code: "
        code = gets.chomp.split('')
      end
      code
    end

    def play
      loop do
        guess = guess_code
        @remaining_guesses -= 1

        if guess_is_correct?(guess)
          puts "You win!"
          puts "The secret code was: #{@code}."
          break
        elsif @remaining_guesses == 0
          puts "Out of guesses! You lose!"
          puts "The secret code was: #{@code}."
          break
        end
        puts "Incorrect!"
        puts "Results: #{guess_feedback(guess)}\n"

      end

      puts "\nThe Code Maker scored #{12 - @remaining_guesses} points."
    end

    def guess_is_correct?(guess)
      if guess == @code
        true
      else
        false
      end
    end

    def guess_feedback(guess)
      feedback = ''
      i = 0
      while i < 4
        if guess[i] == @code[i]
          feedback << 'O'
        elsif @code[i] == guess[0] || @code[i] == guess[1] || @code[i] == guess[2] || @code[i] == guess[3]
          feedback << 'X'
        end
        i += 1
      end
      feedback.split('').shuffle.join
    end

    def guess_code
        print "Guess ##{@remaining_guesses}: "
        guess = get_guess
    end

    def get_guess
      guess = gets.chomp.split('')
      until (guess.all? { |digit| digit.to_i <= 6 && digit.to_i >= 1} && guess.size == 4)
        puts "Invalid guess! Please enter a 4 digit code using digits 1-6."
        print "Guess ##{@remaining_guesses}: "
        guess = gets.chomp.split('')
      end
      guess
    end

    def select_role(input)
      if input == 1
        "Code Maker"
      elsif input == 2
        "Code Breaker"
      end
    end

    # def computer_guess
    #   print "Guess ##{@remaining_guesses}: "
    #   guess =
    # end
  end

  class Player
    def initialize(game)
      @game = game
    end
  end
end

include Mastermind

Game.new.play

# decide who is code_maker and who is code_breaker

# code_maker creates code
# code_breaker starts round by making first guess
# code_breaker:
  # correct value & correct position: 'O'
  # correct value, incorrect position: 'X'
  #! in no particular order!
# repeat 9 more times (10 total)

# when code_breaker guesses correctly, the code is revealed

# Scoring:
  # code_maker: 1 point per guess by code_breaker
  # 11 points if code_breaker fails to guess code