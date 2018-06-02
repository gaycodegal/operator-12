require("util")

Slug = {sprites = require("slug/slugdefs")}

Slug.__index = metareplacer(Slug)

-- data now owned by slug
function Slug.new (data)
   local sprites = Slug.sprites[data.sprites]
   data.sprites = {}
   for i, spr in ipairs(sprites) do
	  data.sprites[i] = Sprite.new(spr[1], 0, 0, spr[2], spr[3])
   end
   data.size = #data.segs
   setmetatable(data, Slug)
   return data
end

function Slug.load ()
   local sprites = Slug.sprites
   for k, v in pairs(sprites) do
	  for i, name in ipairs(v) do
		 t, w, h = Texture.new("images/"..name)
		 v[i] = {t, w, h, name}
	  end
   end
end

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
   local head = self.segs[1]
   local dx = math.abs(x - head[1])
   local dy = math.abs(y - head[2])
   if dx > 1 or dy > 1 or dy == dx then
	  return
   end
   print(self.size)
   for i = self.size, 2, -1 do
	  self.segs[i] = self.segs[i - 1]
   end
   self.segs[1] = {x,y}
end

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

function Slug.destroy (self)
   for i, spr in ipairs(self.sprites) do
	  spr:destroy()
   end
end
