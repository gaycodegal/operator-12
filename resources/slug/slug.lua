require("util")

Slug = {sprites = require("slug/slugdefs")}

Slug.__index = metareplacer(Slug)

-- creates a new slug
-- data now owned by slug
function Slug.new (data)
   local sprites = Slug.sprites[data.sprites]
   data.sprites = {}
   for i, spr in ipairs(sprites) do
	  data.sprites[i] = Sprite.new(spr[1], 0, 0, tilew, tileh, 0, 0)
   end
   data.size = #data.segs
   setmetatable(data, Slug)
   return data
end

-- spawn slugs from Tiled lua file
function Slug.spawn(data)
   slugs = {}
   for i, v in ipairs(data) do
	  if slugs[v.name] then else
		 slugs[v.name] = {}
	  end
	  --print(v.y, v.x, map.tilesize, map.width, (v.y // map.tilesize))
	  slugs[v.name][v.properties.index] = {
		 (v.x // map.tilesize) % map.width + 1,
		 (v.y // map.tilesize) 
	  }
	  slugs[v.name].type = v.type
   end
   for name, v in pairs(slugs) do
	  slugs[name] = Slug.new({sprites = v.type, segs = v})
   end
   return slugs
end

-- despawn slugs from Tiled lua file
function Slug.despawn()
   for name, v in pairs(slugs) do
	  v:destroy()
   end
end

-- draw slugs from Tiled lua file
function Slug.renderAll()
   for name, v in pairs(slugs) do
	  v:draw()
   end
end

--load all slug data
--names -> textures
function Slug.load ()
   local sprites = Slug.sprites
   for k, v in pairs(sprites) do
	  for i, name in ipairs(v) do
		 t, w, h = Texture.new("images/"..name)
		 v[i] = {t, w, h, name}
	  end
   end
end

--deallocate global slug textures
function Slug.unload()
   local sprites = Slug.sprites
   for k, v in pairs(sprites) do
	  for i, spr in ipairs(v) do
		 v[i] = Texture.destroy(spr)
	  end
   end
end

-- incredibly inefficient. O(1) with LinkedListSlug,
-- but hey who cares, fast and dirty to start
function Slug.move(self, x, y)
   local seg = self.segs[1]
   local dx = math.abs(x - seg[1])
   local dy = math.abs(y - seg[2])
   if map.map[x + y * map.width] then else
	  return
   end
	  
   if dx > 1 or dy > 1 or dy == dx then
	  return
   end
   local tomove = nil
   local toi
   -- check if we'll replace one of our own segments
   for i = 2, self.size - 1 do
	  seg = self.segs[i]
	  if seg[1] == x and seg[2] == y then
		 tomove = seg
		 toi = i
		 break
	  end
   end
   --if so shift and cylce
   if tomove ~= nil then
	  for i = toi, 2, -1 do
		 self.segs[i] = self.segs[i - 1]
	  end
	  self.segs[1] = tomove
	  return
   end
   --otherwise, slide everyone down one
   self.segs[self.size] = tomove
   for i = self.size, 2, -1 do
	  self.segs[i] = self.segs[i - 1]
   end
   self.segs[1] = {x,y}
end

--draw slug to screen
function Slug.draw (self)
   local spr = self.sprites[2]
   local x, y, seg

   for i = 2, self.size do
	  seg = self.segs[i]
	  x, y = Map.position(seg[1], seg[2])
      spr:draw(x, y)
   end
   spr = self.sprites[1]
   seg = self.segs[1]
   x, y = Map.position(seg[1], seg[2])
   spr:draw(x, y)
end

-- deallocate slug
function Slug.destroy (self)
   for i, spr in ipairs(self.sprites) do
	  spr:destroy()
   end
end
