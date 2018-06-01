require("util")
Map = {}

Map.__index = metareplacer(Map)

function Map.new (dx, dt, param, target)
   local map = {}
   local limit = 5
   local tilesize = 40
   local tilesep = 10
   for xi = 1,limit do
	  local x = (xi - 1) * (tilesize + tilesep)
	  for yi = 1,limit do
		 local y = (yi - 1) * (tilesize + tilesep)
		 local temp = Sprite.new(tile, x, y, tilesize, tilesize)
		 map[xi * limit + yi] = temp
	  end
   end
   local t = {map=map, width=limit, height=limit}
   setmetatable(t, Map)
   return t
end

function Map.draw (self)
   for x = 1, self.width do
	  for y = 1, self.height do
		 self.map[x * self.width + y]:draw(0, 0)
	  end
   end
end

function Map.destroy (self)
   for x = 1, self.width do
	  for y = 1, self.height do
		 self.map[x * self.width + y]:destroy()
	  end
   end
end
