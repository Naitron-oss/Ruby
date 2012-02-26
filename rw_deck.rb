require_relative 'card'

class RWDeck
  def initialize (card_selection = [[3,2,3,3,3,2,3,3,2,2],[2,2,2,3,3,3,3,2,3,2],[3,2,2,2,3,3,3,3,3,3]])
    #type is 0, 1, or 2 if construction, attack, or magic card
    #cost is resource cost
    #target is 0 for self, 1 for opponent, 2 for both
    #effects will work in the following manner.  A card will have an array of effects.  Each effect will
    #be another array of three numbers: [first, second, third]
    # first: resource type: 0 => building, 1 => Attack, 2 => Magic, 3 => castle attrib
    # second: secondary type: 0 => resource qty, 1 => builder qty or 0 => castle height, 1 => fence height
    # third: delta (amount to change given attribute by)
    #if card effect is [9, [effect]] then the card has a secondary effect
    
    build_cards = %w{ Wall Base Defense Reserve Tower School Fence Fort Babylon Wain }
    attack_cards = %w{ Archer Knight Rider Platoon Recruit Assault Saboteur Swat Banshee Thief }
    magic_cards = %w{ Conjure-Bricks Conjure-Crystals Conjure-Weapons Crush-Bricks Crush-Crystals Crush-Weapons Sorcerer Dragon Pixies Curse }
    card_names = [build_cards, attack_cards, magic_cards]
    cost_values = [[1,1,3,3,5,8,12,18,39,10],[1,2,2,4,8,10,12,18,28,15],[4,4,4,4,4,4,8,21,22,45]]
    magic_targets = [0,0,0,1,1,1,0,1,0,2]
    build_effects = [[3,1,3],[3,0,2],[3,1,6],[[3,0,8],[3,1,-4]],[3,0,5],[0,1,1],[3,1,22],[3,0,20],[3,0,32],[3,0,8]]
    attack_effects = [[3,1,-2],[3,1,-3],[3,1,-4],[3,1,-6],[1,1,1],[3,1,-12],[[0,0,-4],[1,0,-4],[2,0,-4]],[3,0,-10],[3,1,-32],[[0,0,-5],[1,0,-5],[1,0,-5]]]
    magic_effects = [[0,0,8],[1,0,8],[2,0,8],[0,0,-8],[1,0,-8],[2,0,-8],[2,1,1],[3,1,-25],[3,0,22],[[0,0,1],[0,1,1],[1,0,1],[1,1,1],[2,0,1],[2,1,1],[3,0,1],[3,1,1]]]
    effects = [build_effects, attack_effects, magic_effects]
    s_effects = [[3,0,-4],[[0,0,5],[1,0,5],[1,0,5]],[[0,0,-1],[0,1,-1],[1,0,-1],[1,1,-1],[2,0,-1],[2,1,-1],[3,0,-1],[3,1,-1]]]
    
    type = 0
    @deck = []
    card_selection.each_index do |cat|
      card_selection[cat].each_index do |i|
        cost = cost_values[cat][i]
        target = 2
        target = cat unless cat == 2 or i == 9
        target = magic_targets[i] if cat == 2
        effect = effects[cat][i]
        secondary_effect = (target == 2 ? s_effects[cat] : nil)
        name = card_names[cat][i]
        args = [cat, cost, target, effect, secondary_effect, name]
        cat[i].times { @deck.push(Card.new(args)) }
      end
      type += 1
    end
  end
  
  def shuffle!
    @deck.shuffle!
  end
  
  #get 1 card and remove from deck
  def get_card
    @deck.pop
  end
  
  #returns card to deck
  def return_card( card )
    @deck.unshift( card )
  end
  
end