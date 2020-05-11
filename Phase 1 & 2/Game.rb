require_relative "Player"

class Game
    def initialize
        @players = []
        @fragments = ""
        @dictionary = Hash[File.read('dictionary.txt').split("\n").map{|i|i.split(', ')}]
        @losses = Hash.new(0)
    end

    def play_round
        while self.losses == false
            current_player = self.current_player
            previous_player = self.previous_player
            player_input = self.take_turn(current_player)
            while !valid_play?(player_input)
                current_player.alert_invalid_guess
                player_input = self.take_turn(current_player)
            end
            @fragments += player_input
            puts "\nFragments: #{@fragments}"
            self.next_player!
        end
        @losses[current_player] += 1
        puts "#{current_player.name} lost this round!"
        puts "\nCurrent Record: "
        puts "Current Player #{current_player.name}: #{self.record(current_player)}"
        puts "Other Player #{previous_player.name}: #{self.record(previous_player)}"
    end

    def current_player
        @players[0]
    end

    def previous_player
        @players[1]
    end

    def next_player!
        @players[0], @players[1] = @players[1], @players[0]
    end

    def take_turn(player)
        print "\n#{player.name} turn, please make a play by entering an alphabet: "
        player.guess
    end

    def valid_play?(string)
        alphabet = ("a".."z").to_a
        if alphabet.include?(string)
            test = @fragments.dup + string
            @dictionary.each_key { |key| return true if key[0...test.length].include?(test) }
        end
        false
    end

    def losses
        if @dictionary.has_key?(@fragments)
            return true
        end
        false
    end

    def record(player)
        return "" if @losses[player] == 0
        return "G" if @losses[player] == 1
        return "GH" if @losses[player] == 2
        return "GHO" if @losses[player] == 3
        return "GHOS" if @losses[player] == 4
        return "GHOST" if @losses[player] == 5
    end

    def run
        puts "Welcome to GHOST!"
        puts "This is a two players game:"
        print "\nPlease enter the name for Player 1: "
        player_1 = gets.chomp
        print "\nPlease enter the name for Player 2: "
        player_2 = gets.chomp
        @players << Player.new(player_1)
        @players << Player.new(player_2)

        while @losses.has_value?(5) == false
            @fragments = ""
            self.play_round
        end

        puts "\nPlayer #{self.previous_player.name} lost this game!"
    end
end

game = Game.new
game.run
