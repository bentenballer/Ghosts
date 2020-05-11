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
        @losses[self.previous_player] += 1
        puts "#{self.previous_player.name} lost this round!"
        puts "\nCurrent Record: "

        if @losses[self.previous_player] == 5
            @players.pop
        end
        
        @losses.each do |player, score|
            puts "Player #{player.name}: #{self.record(player)}"
        end
    end

    def current_player
        @players[0]
    end

    def previous_player
        @players[-1]
    end

    def next_player!
        previous = @players.shift
        @players << previous
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

    def add_players(num)
        i = 1
        while i <= num
            print "\nPlease enter name for Player #{i}: "
            player = gets.chomp
            @players << Player.new(player)
            i += 1
        end
    end

    def run
        puts "Welcome to GHOST!"
        puts "This is a multiplyer players game:"
        print "How many players?: "
        total_players = gets.chomp.to_i
        
        add_players(total_players)

        while @players.length > 1
            @fragments = ""
            self.play_round
        end

        puts "\nPlayer #{self.current_player.name} won this game!"
    end
end

game = Game.new
game.run
