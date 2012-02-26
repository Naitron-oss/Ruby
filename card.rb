class Card
  attr_reader :type, :cost, :target, :effect, :secondary_effect, :name
  #type is 0, 1, or 2 if construction, attack, or magic card
  #cost is resource cost
  #target is 0 for self, 1 for opponent, 2 for both
  #effects will work in the following manner.  A card will have an array of effects.  Each effect will
  #be another array of three numbers: [first, second, third]
  # first: resource type: 0 => building, 1 => Attack, 2 => Magic, 3 => castle attrib
  # second: secondary type: 0 => resource qty, 1 => builder qty or 0 => castle height, 1 => fence height
  # third: delta (amount to change given attribute by)
  def initialize( args )
    #Args = [type, cost, target, effect, secondary_effect, name ]
    
    @type = args[0]
    @cost = args[1]
    @target = args[2]
    @effect = args[3]
    @secondary_effect = args[4] if @target == 2
    @name = args[5]
  end
end