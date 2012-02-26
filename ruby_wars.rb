require_relative 'rw_deck'
require_relative 'player'

class RubyWars
  attr_reader :humans, :computers
  
  def initialize( terminal = true, singlePlayer = true )
    human_players, computer_players = [], []
    @players = greet if terminal
    begin
      humans = 1 # Maybe I can combine this with the line below?
      singlePlayer ? computer_players << Player.new : humans = 2
      humans.times { human_players << Player.new('human') }
      @players = human_players + computer_players
    end unless terminal
    @players[0].set_opponent(@players[1])
    @players[1].set_opponent(@players[0])
    @handsize = 6
    @deck = RWDeck.new
    @deck.shuffle!
    deal
  end
  
  def play
    finished = false
    currentPlayer = 0
    begin
      turn(@players[currentPlayer])
      currentPlayer == 0 ? currentPlayer = 1 : currentPlayer = 0
      finished = true if @players[0].castle > 100 or @players[0].castle == 0 or @players[1].castle > 100 or @players[1].castle == 0
    end until finished
    post_battle_report
  end
  
  protected
  
  def greet
    #TODO: add greeting.  Must specify number of players, must set up @humans and @computers arrays
    return [Player.new('human'), Player.new]
  end
  
  def deal
    begin
      @players.each do |p|
        @handsize.times { p.add_to_hand( @deck.get_card ) }
      end
    rescue
      #rescues in case there aren't enough cards to be dealt to each person
    end
  end
  
  def turn( player )
    player.turn_growth
    card, play = (player.human ? prompt( player ) : player.auto_turn)
    if play
      targeted_player = (card.target == 0 ? player : player.opponent)
      targeted_player.consequence(card)
    end
    player.remove_from_hand(card)
    @deck.return_card(card)
    player.add_to_hand( @deck.get_card )
    @deck.shuffle!
  end
  
  def prompt( player )
    #TODO:
    #outputs hand, castle info, resource info, etc
    #asks player to chose a card to play or discard
    #returns card, true or false for play or discard
  end
  
  def post_battle_report
    #TODO:
    #Show who won, talk about their greatness!
  end
end