require("util")

Collectable = Class()
local C = Collectable
C.types = {}

--[[--
   creates a new money object
   @param spr sprite
   @param pos now owned by segment
   @param take function to activate on collection
]]
function Collectable.new (spr, pos, take)
   local self = {spr=spr, pos=pos, take=take, item=true}
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

--[[--
   spawn collectables from Tiled lua file
   @param data sourced from tiled_map.layers[3].objects
]]
function Collectable.spawn(data)
   if not data then
      return
   end
   local collectables = {}
   C.items = collectables
   C.sheet = Tileset.fromSheet("collectables")
   for i, v in ipairs(data) do
      local item = C.types[v.type].spawn(v, {
	 (v.x // map.tilesize) + 1,
	 (v.y // map.tilesize) + 1
      })
      table.insert(collectables, item)
      item:addToMap()
   end
end

--[[--
   Destroys associated objects created in the spawn function
]]
function Collectable.despawn()
   if C.sheet then
      C.sheet:destroyTilesets()
   end
   C.sheet = nil
   C.items = nil
end
