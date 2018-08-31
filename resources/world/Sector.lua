require("util")
require("tiled/tilesets")
Sector=Class()
local S = Sector
Sector.speed = 10


--[[--
   A sector is basically all the content that can be viewed at once in
   the world map. A rectangular area. Scrollable and such

   @param data data of the sector

   @return new sector
]]
function Sector.new(data)
   local self = {}
   self.data = data
   self.sprites = {}
   self.x = 0
   self.y = 0
   self.dx = 0
   self.dy = 0
   self.width = self.data.width
   self.height = self.data.height
   self.tiles = self.data.tilesets
   setmetatable(self, Sector)
   self:load()
   self:recenter()
   return self
end

--[[--
   recenter the map in the display
]]
function Sector:recenter()
   self.x = (SCREEN_WIDTH - self.width)//2
   self.y = (SCREEN_HEIGHT - self.height)//2
end


--[[--
   pan map
]]
function Sector:update()
   self.x = self.x - self.dx
   self.y = self.y - self.dy
end

--[[--
   load a sector's textures and sprites
]]
function Sector:load()
   local t = self.tiles
   Tileset.loadSurfaces(t)
   t:asTextures()
   t:loadTilesets()
   for i,o in ipairs(self.data.objects) do
	  local tile = t.named[o.tile]
	  table.insert(self.sprites, Sprite.new(tile.tex, o.x - tile.w//2, o.y - tile.h//2, tile.w, tile.h, tile.x, tile.y))
   end
end

--[[--
   draw the boy
]]
function Sector:draw()
   for i,s in ipairs(self.sprites) do
	  s:draw(self.x,self.y)
   end
end

--[[--
   destroy the boy
]]
function Sector:destroy()
   for i,s in ipairs(self.sprites) do
	  s:destroy()
   end
   self.tiles:destroyTilesets()
   self.data = nil
   self.tiles = nil
end
