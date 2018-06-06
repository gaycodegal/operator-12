require("util")
require("tiled/tilesets")
-- slugdefs tells us information about slug types
-- such as where the head/body images are stored
Slug = {defs = dofile("slug/slugdefs.lua")}

Slug.__index = metareplacer(Slug)
require("slug/segment")

-- creates a new slug
-- self now owned by slug
function Slug.new (self)
   local sprites = Slug.defs[self.sprites].tiles
   self.stats = Slug.defs[self.sprites].stats
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

function Slug.movementOverlay(self, range)
   local diamond = self:listDiamond(range)
   local arrs = {overlay.named.up, overlay.named.right, overlay.named.down, overlay.named.left}
   local x, y
   if #diamond < 4 then
	  return
   end
   for i = 1, 4 do
	  if diamond[i] then
		 x,y = Map.basePosition(diamond[i][1], diamond[i][2])
		 diamond[i] = Sprite.new(arrs[i].tex, x, y, tilew, tileh, arrs[i].x, arrs[i].y)
	  end
   end
   local move = overlay.named.move
   for i = 5, #diamond do
	  if diamond[i] then
		 x,y = Map.basePosition(diamond[i][1], diamond[i][2])
		 diamond[i] = Sprite.new(move.tex, x, y, tilew, tileh, move.x, move.y)
	  end
   end
   self.overlay = diamond
end

function Slug.destroyOverlay(self)
   if self.overlay then
	  for i,v in ipairs(self.overlay) do
		 if v then
			v:destroy()
		 end
	  end
   end
   self.overlay = nil
end

function Slug.drawOverlay(self)
   if self.overlay then
	  local x, y = Map.position(self.head.pos[1] + 1, self.head.pos[2] + 1)
	  for i,v in ipairs(self.overlay) do
		 if v then
			v:draw(x,y)
		 end
	  end
   end
end

function Slug.listDiamond(self, size)
   -- >v, <v,<^,>^
   local deltas = {{1,1},{-1,1},{-1,-1},{1,-1}}
   local j = 1
   local hpos = self.head.pos
   local pos = {0,0}--
   local lst = {}
   for ring = 1,size do
	  pos[2] = pos[2] - 1
	  for t,d in ipairs(deltas) do
		 for i=1,ring do
			if map.map[map:indexOf(pos[1]+hpos[1], pos[2]+hpos[2])] then
			   lst[j] = {pos[1], pos[2]}
			else
			   lst[j] = false
			end
			pos[1] = pos[1] + d[1]
			pos[2] = pos[2] + d[2]
			j = j + 1
		 end
	  end
   end
   return lst
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
		 (v.x // map.tilesize) + 1,
		 (v.y // map.tilesize) + 1
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

--load all slug data
--names -> textures
function Slug.load ()
   local data = Slug.defs
   local tilesets = data.tilesets
   local slugdefs = data.slugs
   Tileset.loadTilesets(tilesets)
   for name, v in pairs(slugdefs) do
	  for i, tile in ipairs(v.tiles) do
		 local j, dat = tilesets:tilefinder(tile)
		 if j then
			local t = tilesets:initTile(tilesets[j],dat)
			v.tiles[i] = t
		 end
	  end
   end
   Slug.defs = slugdefs
   Slug.tilesets = tilesets
end

--deallocate global slug textures
function Slug.unload()
   Tileset.destroyTilesets(Slug.tilesets)
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
   local ind = map:indexOf(x,y)
   if map.map[ind] then else
	  return false
   end
   local mid = map.objects[ind]
   if mid then
	  if mid.slug ~= self then
		 return false
	  end
   end
   
   if dx > 1 or dy > 1 or dy == dx then
	  return false
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
   return true
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
   self:destroyOverlay()
   for i, spr in ipairs(self.sprites) do
	  spr:destroy()
   end
   if self.name and slugs[self.name] then
	  slugs[self.name] = nil
   end
end
