require("util")
require("battle/collectable")

MoneyObject = {}
Collectable.types.money = MoneyObject

--[[--
   creates a new money object
   @param spr sprite
   @param pos now owned by segment
   @param value money the object will impart on capture
]]
function MoneyObject.new (spr, pos, value)
   local item = Collectable.new(spr, pos, MoneyObject.take)
   item.value = value
   return item
end

--[[--
   spawn a new money object from a tiled object
   @param v a tiled object
   @param v.properties.value money item will impart on capture
   @param pos now owned by segment
]]
function MoneyObject.spawn (v, pos)
   return MoneyObject.new(Collectable.sheet.named.money, pos, v.properties.value)
end

--[[--
   called to capture the money for a player/slug
   @param player player that took money
   @param slug slug that took money
]]
function MoneyObject:take(slug)
   player.money:add(self.value)
end
