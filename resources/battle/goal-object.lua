require("util")
require("battle/collectable")

GoalObject = {}
Collectable.types.goal = GoalObject

--[[--
   creates a new money object
   @param spr sprite
   @param pos now owned by segment
   @param value money the object will impart on capture
]]
function GoalObject.new (spr, pos)
   return Collectable.new(spr, pos, GoalObject.take)
end

--[[--
   spawn a new money object from a tiled object
   @param unused a tiled object
   @param value money the object will impart on capture
]]
function GoalObject.spawn (unused, pos)
   return GoalObject.new(Collectable.sheet.named.goal, pos)
end

--[[--
   called to capture the money for a player/slug
   @param player player that took money
   @param slug slug that took money
]]
function GoalObject:take(slug)
   Player.win()
end
