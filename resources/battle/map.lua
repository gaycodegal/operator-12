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
   local size = limit * (tilesize + tilesep) - tilesep
   local t = {map=map, width=limit, height=limit, x=(SCREEN_WIDTH - size)//2, y=(SCREEN_HEIGHT - size)//2, dx=0, dy=0, speed=5}
   setmetatable(t, Map)
   return t
end

-- map game logic
function Map.update(self)
   self.x = self.x + self.dx
   self.y = self.y + self.dy
end

-- get map pixel position from grid coords
function Map.position(x,y)
   --ehhhhhh global var abuse but like who cares rn
   return (x * (Map.tilesize + Map.tilesep) + map.x), (y * (Map.tilesize + Map.tilesep) + map.y)
end

-- click on map -> do someting 
function Map.mousedown(self,x,y)
   x = ((x - map.x) // (Map.tilesize + Map.tilesep))
   y = ((y - map.y) // (Map.tilesize + Map.tilesep))
   if x >= 0 and x < self.width and y >= 0 and y < self.width then
	  self.slug:move(x, y)
   end
end

-- draw map to screen
function Map.draw (self)
   for x = 1, self.width do
	  for y = 1, self.height do
		 self.map[x * self.width + y]:draw(map.x, map.y)
	  end
   end
end

-- deallocate map
function Map.destroy (self)
   for x = 1, self.width do
	  for y = 1, self.height do
		 self.map[x * self.width + y]:destroy()
	  end
   end
end
