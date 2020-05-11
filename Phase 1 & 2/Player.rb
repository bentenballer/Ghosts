class Player
    attr_reader :name
    def initialize(name)
        @name = name
    end

    def guess
        input = gets.chomp
    end

    def alert_invalid_guess
        puts "Your input is invalid, please try again!"
    end
end