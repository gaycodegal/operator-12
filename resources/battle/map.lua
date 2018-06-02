require("util")
Map = {}

Map.__index = metareplacer(Map)

Map.tilesep = 10
Map.tilesize = 40 -- rewritten
function Map.new (dx, dt, param, target)
   local map = {}
   local limit = 5
   local tilesize = tilew
   Map.tilesize = tilesize
   local tilesep = 10
   for xi = 1,limit do
	  local x = (xi - 1) * (tilesize + tilesep)
	  for yi = 1,limit do
		 local y = (yi - 1) * (tilesize + tilesep)
		 local temp = Sprite.new(tile, x, y, tilesize, tilesize)
		 map[xi * limit + yi] = temp
	  end
   end
   local t = {map=map, width=limit, height=limit, x=0, y=0, dx=0, dy=0, speed=5}
   setmetatable(t, Map)
   return t
end

function Map.update(self)
   self.x = self.x + self.dx
   self.y = self.y + self.dy
end

function Map.position(x,y)
   --ehhhhhh global var abuse but like who cares rn
   return (x * (Map.tilesize + Map.tilesep) + map.x), (y * (Map.tilesize + Map.tilesep) + map.y)
end

function Map.draw (self)
   for x = 1, self.width do
	  for y = 1, self.height do
		 self.map[x * self.width + y]:draw(map.x, map.y)
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
