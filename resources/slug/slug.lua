require("util")
-- slugdefs tells us information about slug types
-- such as where the head/body images are stored
Slug = {defs = require("slug/slugdefs")}

Slug.__index = metareplacer(Slug)
require("slug/segment")

-- creates a new slug
-- self now owned by slug
function Slug.new (self)
   local sprites = Slug.defs[self.sprites].tiles
   self.sprites = {}
   for i, spr in ipairs(sprites) do
	  self.sprites[i] = Sprite.new(spr.tex, 0, 0, tilew, tileh, spr.x, spr.y)
   end
   self.size = #self.segs
   local prev = nil
   for i = 1,self.size do
	  local sprite = self.sprites[2]
	  if i == 1 then
		 sprite = self.sprites[1]
	  end
	  self.segs[i] = Segment.new(prev, nil, sprite, self.segs[i], self)
	  prev = self.segs[i]
   end
   self.head = self.segs[1]
   self.tail = self.segs[self.size]
   self.segs = nil
   setmetatable(self, Slug)
   self:addToMap()
   return self
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
	  if v.properties.team then
		 slugs[v.name].team = v.properties.team
	  end
   end
   for name, v in pairs(slugs) do
	  slugs[name] = Slug.new({sprites = v.type, segs = v, name=name, team=v.team})
   end
end

-- despawn slugs from Tiled lua file
function Slug.despawn()
   for name, v in pairs(slugs) do
	  if v then
		 v:destroy()
	  end
   end
end

-- find tile index <dat> within tilesets
function Slug.tilefinder(dat, tilesets)
   local j = 1
   if dat <= 0 then
	  return false
   end
   while dat > tilesets[j].tilecount do
	  dat = dat - tilesets[j].tilecount
	  j = j + 1
   end
   return j, dat
end

function Slug.destroyTilesets(tilesets)
   for i, v in ipairs(tilesets) do
	  Texture.destroy(v.sheet)
   end
end

function Slug.parseColor(color)
   local r = tonumber(string.sub(color, 1,2), 16)
   local g = tonumber(string.sub(color, 3,4), 16)
   local b = tonumber(string.sub(color, 5,6), 16)
   local a = 255
   return r,g,b,a
end

function Slug.loadTilesets(tilesets)
   for i, v in ipairs(tilesets) do
	  v.w = v.imagewidth // v.tilewidth
	  v.h = v.imageheight // v.tileheight
	  if v.tiles[1].properties.color then
		 local s = Surface.newBlank(v.imagewidth, v.imageheight)
		 for i, t in ipairs(v.tiles) do
			local r,g,b,a = Slug.parseColor(t.properties.color)
			Surface.fill(s,(i % v.w) * v.tilewidth,
						 (i // v.w) * v.tileheight,
						 v.tilewidth,
						 v.tileheight,
						 r,g,b,a)
		 end
		 local s2 = Surface.new("images/" .. v.image)
		 Surface.blit(s, s2, 0, 0)
		 Surface.destroy(s2)
		 s2 = nil
		 if v.tilewidth ~= map.tilesize then
			local w = v.w * map.tilesize
			local h = v.h * map.tilesize
			s2 = Surface.newBlank(w,h)
			--Surface.fill(s2, 0,0,w,h,255,255,255,255)
			Surface.blitScale(s2, s, 0,0,v.imagewidth, v.imageheight,0,0,w,h)
			Surface.destroy(s)
			s = s2
			v.tilewidth = map.tilesize
			v.tileheight = map.tilesize
			v.imagewidth = w
			v.imageheight = h
		 end
		 v.sheet = Surface.textureFrom(s)
		 Surface.destroy(s)
	  else
		 local t, w, h = Texture.new("images/" .. v.image)
		 v.sheet = t
	  end
   end
end

--load all slug data
--names -> textures
function Slug.load ()
   local data = Slug.defs
   local tilesets = data.tilesets
   local slugdefs = data.slugs
   Slug.loadTilesets(tilesets)
   for name, v in pairs(slugdefs) do
	  for i, tile in ipairs(v.tiles) do
		 local j, dat = Slug.tilefinder(tile, tilesets)
		 if j then
			local set = tilesets[j]
			local tex = {}
			tex.tex = set.sheet
			tex.w = set.tilewidth
			tex.h = set.tileheight
			tex.x = (dat % set.w) * tex.w
			tex.y = (dat // set.w) * tex.h
			v.tiles[i] = tex
		 end
	  end
   end
   Slug.defs = slugdefs
   Slug.tilesets = tilesets
end

--deallocate global slug textures
function Slug.unload()
   Slug.destroyTilesets(Slug.tilesets)
end

-- Remove Slug from Map
function Slug.removeFromMap(self)
   local seg = self.head
   while seg do
	  seg:removeFromMap()
	  seg = seg.n
   end
end

-- Add Slug to Map
function Slug.addToMap(self)
   local seg = self.head
   while seg do
	  seg:addToMap()
	  seg = seg.n
   end
end

-- case off map
-- case encounter other
-- diagonal or on head
-- case encounter consumable
-- case encounter self tail
-- case encounter self (max len)
-- case encounter self default
function Slug.move(self, x, y)
   local head = self.head
   local dx = math.abs(x - head.pos[1])
   local dy = math.abs(y - head.pos[2])

   if map.map[x + y * map.width] then else
	  return
   end
   local mid = map.objects[x + y * map.width]
   if mid then
	  if mid.slug ~= self then
		 mid.slug:damage(1)
		 return
	  end
   end
   
   if dx > 1 or dy > 1 or dy == dx then
	  return
   end

   head:removeFromMap()
   local tail = self.tail
   tail:removeFromMap()
   if mid and mid ~= tail then
	  mid:removeFromMap()
	  local t = mid.pos
	  mid.pos = tail.pos
	  tail.pos = t
	  mid:addToMap()
	  mid:unlink()
	  mid:insert(tail.p, tail)
   end
   if tail ~= head then
	  local prev = tail.p
	  tail:unlink()	  
	  tail:insert(head, head.n)
	  tail.pos[1] = head.pos[1]
	  tail.pos[2] = head.pos[2]
	  tail:addToMap()
	  if prev ~= head then
		 self.tail = prev
	  end
   end
   head.pos[1] = x
   head.pos[2] = y
   head:addToMap()
end

-- remove <amount> segments from
-- slug, possibly destroying it
function Slug.damage(self, amount)
   for i = 1,amount do
	  self.size = self.size - 1
	  local t = self.tail
	  t:removeFromMap()
	  self.tail = t.p
	  t:unlink()
	  if self.size <= 0 then
		 self:destroy()
	  end
   end
end

-- deallocate slug
function Slug.destroy (self)
   for i, spr in ipairs(self.sprites) do
	  spr:destroy()
   end
   if self.name and slugs[self.name] then
	  slugs[self.name] = nil
   end
end
