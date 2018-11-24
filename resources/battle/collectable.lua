require("util")

Collectable = class()
local C = Collectable

--[[--
   creates a new money object
   @param spr sprite
   @param pos now owned by segment
   @param value money the object will impart on capture
   @param take function to activate on collection
]]
function Collectable.new (spr, pos, value, take)
   local self = {spr=spr, pos=pos, v=value, take=take}
   setmetatable(self, C)
   return self
end

--[[--
   Remove from Map
]]
function Collectable:removeFromMap()
   map.objects[map:indexOf(self.pos[1], self.pos[2])] = false
end

--[[--
   Add to Map
]]
function Collectable:addToMap()
   map.objects[map:indexOf(self.pos[1], self.pos[2])] = self
end

--[[--
   Draw on Map
]]
function Collectable:draw()
   local x, y = Map.position(self.pos[1], self.pos[2])
   local s = self.spr
   local sep2 = (map.tilesep // 2)
   local w = tilew
   local h = tileh
   Texture.renderCopy(s.tex, s.x, s.y, w, h, x, y, w, h)
end
