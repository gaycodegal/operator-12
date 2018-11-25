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
function GoalObject.new (spr, pos, value)
   return Collectable.new(spr, pos, value, GoalObject.take)
end

--[[--
   spawn a new money object from a tiled object
   @param spr sprite
   @param pos now owned by segment
   @param value money the object will impart on capture
]]
function GoalObject.spawn (v, pos)
   return GoalObject.new(Collectable.sheet.named.goal, pos, v.properties.value)
end

--[[--
   called to capture the money for a player/slug
   @param player player that took money
   @param slug slug that took money
]]
function GoalObject:take(player, slug)
   self:removeFromMap()
   player.money:add(self.value)
end
