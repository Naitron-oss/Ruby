class Player
  attr_reader :opponent, :human
  
  def initialize( type = 'computer' )
    type.match(/human/) ? @human = true : @human = false
    @hand = []
    @stats = [[5,2],[5,2],[5,2],[30,10]]
    @opponent = nil
  end
  
  def set_opponent( player )
    @opponent = player
  end
  
  def add_to_hand( card )
    @hand << card
  end
  
  def remove_from_hand( card )
    @hand.delete( card )
  end
  
  def castle
    @stats[3][0]
  end
  
  def turn_growth
    3.times {|i| @stats[i][0] += @stats[i][1]}
  end
  
  def get_playable
    playable = []
    @hand.each_index do |i|
      playable << i if @stats[@hand[i].type][0] > @hand[i].cost
    end
    playable
  end
  
  #AI: How does the computer decide to take its turn
  def auto_turn
    #TODO:
    #returns card, true or false for play or discard
    #choose a random card
    #discard a random card if no cards can be played
    #come up with a prioritized hand based on winning potential (play the best, discard the worst)
  end
  
  #affects player stats based on card_effect
  def consequence( card, secondary = false, transfer = nil )
    effects = (secondary ? card.secondary_effect : card.effect)
    new_transfer = nil
    if effects.respond_to? 'each'
      if card.name == 'Thief'
        new_transfer = []
        effects.each_index do |i|
          #Use corrected values for thief transfers if opponent didn't have max_transfer in stock (secondary effect only)
          effects[i][2] = transfer[i] unless transfer[i].nil?
          #Process Effect, grab corrected transfer if applicable (first effect only)
          new_transfer << process_effect( card, effects[i] )
        end
      else
        effects.each {|effect| process_effect( card, effect ) }
      end
    else
      process_effect( card, effects )
    end
    unless card.secondary_effect.nil? or secondary
      #cool! Recursive solutions are fun!
      consequence( card, true, new_transfer )
    end
  end
  
  protected
  
  def process_effect( card, effect )
    cat1, cat2, qty = effect
    transfer = nil #for transferring resources after playing a Thief and stocks below max_transfer
    if qty < 0
      #if fence is at less than -qty, fence -> 0 and target castle for remainder (but not if it's a reserve card):
      if @cat1 == 3 && @stats[cat1][cat2] < qty.abs
        remainder = @stats[cat1][cat2] + qty
        @stats[cat1][cat2] = 0
        cat2, qty = 0, remainder unless card.name == 'Reserve'
      end
      #if resources aren't there, don't go negative
      if @stats[cat1][cat2] < qty.abs
        transfer = @stats[cat1][cat2] if card.name == 'Thief'
        qty = -@stats[cat1][cat2]
      end
      #prevent less than 1 growth
      if cat2 == 1 && (0..2).include?( cat1 )
        qty = 0
      end
    end #end qty < 0
    
    #finished processing effect, now modify:
    @stats[cat1][cat2] += qty
    transfer
  end
  
end