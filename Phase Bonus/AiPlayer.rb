class AiPlayer
    attr_reader :name, :ai
    attr_accessor :other_players

    def initialize(num)
        @name = "AI#{num}"
        @ai = true
        @other_players = 0
    end

    def best_moves(hash, string)
        alphabet = ("a".."z").to_a
        if string == ""
            return alphabet[rand(alphabet.length)]
        end

        good_moves = []

        alphabet.each do |char|
            test = string.dup + char
            hash.each_key do |key| 
                if good_move?(test, key)
                    good_moves << char
                end
            end
        end

        if good_moves == []
            alphabet.each do |char|
                test = string.dup + char
                hash.each_key do |key| 
                    return char if key[0...test.length].include?(test) 
                end
            end
        else
            good_moves[rand(good_moves.length)]
        end
    end

    def good_move?(possible_string, word)
        length = word.length - possible_string.length
        if word[0...possible_string.length].include?(possible_string) && length > 0 && length < @other_players
            return true
        end
        false
    end

end