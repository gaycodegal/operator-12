require("util")
require("battle/collectable")
require("battle/goal-object")
require("money/object")
Map = Class()

Map.tilesep = 10
Map.tilesize = 40 -- rewritten

--[[--
   create a new Map

   could display in a more efficient way but like it works fine.
   
   @param data passed in from Tiled data
   (map assumes control of data)/will corrupt it.
]]
function Map.new (data)
   tilew = data.tilesets[1].tilewidth
   tileh = data.tilesets[1].tileheight
   local tilesets = data.tilesets
   for i, v in ipairs(tilesets) do
      local t, w, h = Texture.new("images/" .. v.image)
      v.sheet = t
      v.w = w // v.tilewidth
   end
   local tilesize = tilew
   Map.tilesize = tilesize
   local tilesep = 10
   local tmap = data.layers[1].data
   local objects = {}
   local t = {map=tmap,
	      objects = objects,
	      tilesets=tilesets,
	      width=data.width,
	      height=data.height,
	      x=0,
	      y=0,
	      dx=0, dy=0, speed=5}
   --print(t.x, t.y)
   setmetatable(t, Map)
   map = t
   for i, dat in ipairs(tmap) do
      t:makeTile(i, dat)
   end
   Collectable.spawn(data.layers[3].objects)
   Slug.load()
   Slug.spawn(data.layers[2].objects)
   for k,v in pairs(slugs) do
      t.slug = v
   end
   t:recenter()
   return t
end


--[[--
   recenter the map in the display
]]
function Map:recenter()
   self.x = (SCREEN_WIDTH - (self.width * (self.tilesize + self.tilesep) - self.tilesep))//2
   self.y = (SCREEN_HEIGHT - (self.height * (self.tilesize + self.tilesep) - self.tilesep))//2
end



--[[--
   make a map tile, adds it to the map

   @param i map index
   @param dat tile number
]]
function Map:makeTile(i, dat)
   local tilesets = self.tilesets
   local tmap = self.map
   local objects = self.objects
   objects[i] = false
   local j = 1
   if dat <= 0 then
      tmap[i] = false
   else
      while dat > tilesets[j].tilecount do
	 dat = dat - tilesets[j].tilecount
	 j = j + 1
      end
      
      local v = tilesets[j]
      dat = dat - 1
      local x, y = Map.basePosition((i-1) % self.width + 1, (i-1) // self.width + 1)
      tmap[i] = Sprite.new(v.sheet,
			   x,
			   y,
			   self.tilesize,
			   self.tilesize,
			   (dat % v.w)*v.tilewidth,
			   (dat // v.w)*v.tileheight)
   end
end

--[[--
   destroy an individual tile

   @param i map index
]]
function Map:destroyTile(i)
   if self.map[i] then
      self.map[i]:destroy()
      self.map[i] = false
   end
end

--[[--
   convert x,y map postion to an index

   @param x 1 based x index
   @param y 1 based x index

   @return map index
]]
function Map:indexOf(x,y)
   return (x-1) + (y - 1) * self.width + 1
end

--[[--
   pan map
]]
function Map:update()
   self.x = self.x - self.dx
   self.y = self.y - self.dy
end

--[[--
   is an (x,y) coord in bounds

   @param x 
   @param y 

   @return in bounds
]]
function Map:valid(x, y)
   return x >= 1 and y >= 1 and x <= self.width and y <= self.height
end

--[[--
   convert input position to map coordinates

   @param x Screen-space position
   @param y Screen-space position

   @return x, y - map-space postion
]]
function Map.positionToCoords(x,y)
   return (x - map.x)//(Map.tilesize + Map.tilesep) + 1,
   (y - map.y)//(Map.tilesize + Map.tilesep) + 1
end

--[[
   get map pixel position from grid coords
]]
function Map.position(x,y)
   --ehhhhhh global var abuse but like who cares rn
   return ((x - 1) * (Map.tilesize + Map.tilesep) + map.x), ((y - 1) * (Map.tilesize + Map.tilesep) + map.y)
end

-- get map pixel position from grid coords
function Map.basePosition(x,y)
   --ehhhhhh global var abuse but like who cares rn
   return ((x - 1) * (Map.tilesize + Map.tilesep)), ((y - 1) * (Map.tilesize + Map.tilesep))
end

-- click on map -> do someting 
function Map:mousedown(x,y)
   local x,y = Map.positionToCoords(x,y)
   if x > 0 and x <= self.width and y > 0 and y <= self.width then
      if self.slug then
	 self.slug:move(x, y)
      end
   end
end

-- draw map to screen
function Map:draw()
   local i = 1
   local v
   local tx = self.x
   local ty = self.y
   for y = 1,self.height do
      if ty + self.tilesize > 0 and ty < SCREEN_HEIGHT then
	 tx = self.x
	 for x = 1,self.width do
	    if tx + self.tilesize > 0 and tx < SCREEN_WIDTH then
	       v = self.map[i]
	       if v then
		  v:draw(self.x, self.y)
	       end
	       if self.objects[i] then
		  self.objects[i]:draw()
	       end
	    end
	    i = i + 1
	    tx = tx + self.tilesize + self.tilesep
	 end
      else
	 i = i + self.width
      end
      ty = ty + self.tilesize + self.tilesep
   end
end

-- deallocate map
function Map:destroy()
   for i, v in ipairs(self.tilesets) do
      Texture.destroy(v.sheet)
   end

   for i, v in ipairs(self.map) do
      if v then
	 v:destroy()
      end
   end

   Slug.despawn()
   Collectable.despawn()
end
