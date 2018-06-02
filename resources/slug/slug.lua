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

function Slug.draw (self)
   local spr = self.sprites[1]
   for k,seg in ipairs(self.segs) do
	  if k ~= 1 then
		 spr = self.sprites[2]
	  end
	  local x, y = Map.position(seg[1], seg[2])
	  spr:draw(x, y)
   end
end

function Slug.destroy (self)
   for i, spr in ipairs(self.sprites) do
	  spr:destroy()
   end
end
