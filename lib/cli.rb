class CLI       
    attr_accessor :answers, :total_questions
    attr_reader :score

    def initialize
        @score = 0
        @total_questions = 1
        call
    end

    def call
        greeting
        API.get_data
        menu
    end
    
    def greeting
        puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        puts "                Welcome! Enjoy this time with your significant other and play some trivia!".colorize(:light_magenta)
        puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    end
  
    def menu
        puts "                           Are you ready for some trivia? Type 'y' to continue or 
                                        if you wish to exit, type 'n'   "
         input = gets.strip.downcase
                
            if  input == "y" 
                trivia_list
                menu
            elsif input == "n"
                goodbye
            else 
                invalid_entry
            end
    end

    def other_menu
        puts "Uh-oh, seem like you typed 'exit', do you wish to leave? (y/n)".colorize(:yellow)
        
        input = gets.strip.downcase

        if input == "n"
            trivia_list
        elsif input == "y"
            puts "Thanks for playing some Trivia"
            goodbye
        else 
            invalid_entry
        end

    end

    
    def trivia_list
        puts "Question:"
        puts ""

        Trivia.all.each.with_index(1) do |trivia, index|
            puts "  #{index}. #{trivia.question.gsub("&#039;","'").gsub("&quot;", "'").gsub("&amp;", "&").gsub("&deg;", " degrees ").gsub("&ndash;", "-")}"
            trivia_selection_output(trivia.question)
        end   
        twenty_questions
    end

    def trivia_selection_output(answer)
        puts "__________________________________________________________________________________________"
        puts "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
        puts "__________________________________________________________________________________________"
        puts "             Choose one of the following answers: (enter the number of answer)            "
        puts "------------------------------------------------------------------------------------------"
        puts "                        If you wish to Exit at anytime, type 'exit'                       "
        puts "__________________________________________________________________________________________"
        puts ""
        puts "Answers:"
        puts ""
        
        @current_trivia = Trivia.all.find {|trivia| trivia.question == answer}
        answers = @current_trivia.all_answers.each.with_index(1) do |answer, index|
            puts "#{index}. #{answer.gsub("&#039;","'").gsub("&quot;", "'").gsub("&amp;", "&").gsub("&deg;", " degrees ").gsub("&ndash;", "-")}" 
        end
    
        input = gets.strip.downcase

            if input.to_i.between?(1, answers.length)
                answer_selection(answers[input.to_i - 1])
                score
            elsif input == "exit"
                goodbye
            else
                puts "Invalid Answer".colorize(:yellow)
                trivia_selection_output(answer)
            end
    end
       
    def answer_selection(answer)
        if answer == "#{@current_trivia.correct_answer}"
            if total_questions != 20
                @score += 1
                self.total_questions += 1
            else
                twenty_questions
            end
            puts "Correct Answer - Wahoo!".colorize(:green) 
        else answer == "#{@current_trivia.incorrect_answers}"
            puts "Sorry that was incorrect".colorize(:red)
            self.total_questions += 1
        end

    end

    def score
        puts " Your score is: #{@score}/20 "
    end

    def final_score
        puts " Your final score is : #{@score}/20 ".colorize(:green)
    end

    def invalid_entry   
        puts " Invalid entry, please try again.".colorize(:yellow)
        menu
    end

    def twenty_questions
        puts "You got through the game - Congrats!".colorize(:green)
        goodbye
    end

    def goodbye
        puts "Thanks for playing Date Night Trivia!"
        final_score
        exit
    end
end