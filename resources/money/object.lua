require("util")
require("battle/collectable")

MoneyObject = {}

--[[--
   creates a new money object
   @param spr sprite
   @param pos now owned by segment
   @param value money the object will impart on capture
]]
function MoneyObject.new (spr, pos, value)
   return Collectable.new(spr, pos, value, MoneyObject.take)
end

--[[--
   called to capture the money for a player/slug
   @param player player that took money
   @param slug slug that took money
]]
function MoneyObject:take(player, slug)
   self:removeFromMap()
   player.money:add(self.value)
end
