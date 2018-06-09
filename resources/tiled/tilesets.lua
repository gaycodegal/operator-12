require("util")
Tileset = {}
Tileset.__index = metareplacer(Tileset)

-- find tile index <dat>
function Tileset.tilefinder(self, dat)
   local j = 1
   if dat <= 0 then
	  return false
   end
   while dat > self[j].tilecount do
	  dat = dat - self[j].tilecount
	  j = j + 1
   end
   return j, dat
end

function Tileset.destroyTilesets(self)
   for i, v in ipairs(self) do
	  if v.surface then
		 Surface.destroy(v.surface)
	  end
	  if v.sheet then
		 Texture.destroy(v.sheet)
	  end
   end
end

function parseColor(color)
   local l = #color
   local t = l // 6-- 0 if 3-4, 1 if 6-8
   local i = 1
   local r = tonumber(string.sub(color, i,i+t), 16)
   i = i + 1 + t
   local g = tonumber(string.sub(color, i,i+t), 16)
   i = i + 1 + t
   local b = tonumber(string.sub(color, i,i+t), 16)
   i = i + 1 + t
   if l == 8 or l == 4 then
	  a = tonumber(string.sub(color, i,i+t), 16)
   else
	  a = 255
   end
   return r,g,b,a
end

function Tileset.initTile(self, set, dat)
   local tex = {}
   tex.tex = set.sheet
   tex.w = set.tilewidth
   tex.h = set.tileheight
   tex.x = (dat % set.w) * (tex.w + set.spacing) + set.margin
   tex.y = (dat // set.w) * (tex.h + set.spacing) + set.margin
   return tex
end

function Tileset.loadSurfaces(self)
   self.named = {}
   setmetatable(self, Tileset)
   for i, v in ipairs(self) do
	  v.w = v.imagewidth // v.tilewidth
	  v.h = v.imageheight // v.tileheight
	  if v.tiles[1].properties.color then
		 local s = Surface.newBlank(v.imagewidth, v.imageheight)
		 Surface.blendmode(s, BLENDMODE_BLEND)
		 --Surface.fill(s,0,0,200,200,255,0,255,255)
		 for i, t in ipairs(v.tiles) do
			local r,g,b,a = parseColor(t.properties.color)
			if a ~= 0 then
			   Surface.fill(s,((i - 1) % v.w) * v.tilewidth,
							((i - 1) // v.w) * v.tileheight,
							v.tilewidth,
							v.tileheight,
							r,g,b,a)
			end
		 end
		 local s2 = Surface.new("images/" .. v.image)
		 Surface.blit(s, s2, 0, 0)
		 Surface.destroy(s2)
		 s2 = nil
		 if v.tilewidth ~= map.tilesize then
			local w = v.w * map.tilesize
			local h = v.h * map.tilesize
			s2 = Surface.newBlank(w,h)
			Surface.blendmode(s2, BLENDMODE_BLEND)
			Surface.blendmode(s, BLENDMODE_NONE)
			Surface.blitScale(s2, s, 0,0,v.imagewidth, v.imageheight,0,0,w,h)
			--Surface.blit(s2, s, 0, 0)
			Surface.destroy(s)
			s = s2
			v.tilewidth = map.tilesize
			v.tileheight = map.tilesize
			v.imagewidth = w
			v.imageheight = h
		 end
		 v.surface = s
		 --v.sheet = Surface.textureFrom(s)
		 --Surface.destroy(s)
	  else
		 v.surface = Surface.new("images/" .. v.image)
		 --v.sheet = t
	  end
   end
end

function Tileset.colorBridge(self)
   local sep = map.tilesep
   for i, v in ipairs(self) do
	  if v.tiles[1].properties.color then
		 v.spacing = sep
		 v.margin = sep
		 local w = v.w + 1
		 local h = v.h + 1
		 local s = Surface.newBlank(v.imagewidth + sep * w, v.imageheight + sep * h)
		 Surface.blendmode(s, BLENDMODE_BLEND)
		 for i, t in ipairs(v.tiles) do
			local r,g,b,a = parseColor(t.properties.color)
			if a ~= 0 then
			   local x = ((i - 1) % v.w) * (v.tilewidth + sep) + sep
			   local y = ((i - 1) // v.w) * (v.tileheight + sep) + sep
			   local ox = ((i - 1) % v.w) * (v.tilewidth)
			   local oy = ((i - 1) // v.w) * (v.tileheight)
			   local sep2 = sep // 2
			   local sep4 = 4
			   Surface.fill(s, x - sep2, y + sep4, sep2, v.tileheight - sep4*2,r,g,b,a)
			   Surface.fill(s, x + sep4, y - sep2, v.tilewidth - sep4*2, sep2,r,g,b,a)
			   Surface.fill(s, x + v.tilewidth, y + sep4, sep2, v.tileheight - sep4*2,r,g,b,a)
			   Surface.fill(s, x + sep4, y + v.tileheight, v.tilewidth - sep4*2, sep2,r,g,b,a)
			   Surface.blitScale(s, v.surface, ox, oy, v.tilewidth, v.tileheight, x, y, v.tilewidth, v.tileheight)
			end
		 end
		 Surface.destroy(v.surface)
		 v.surface = s
	  end
   end
end

function Tileset.asTextures(self)
   for i, v in ipairs(self) do
	  v.sheet = Surface.textureFrom(v.surface)
	  Surface.destroy(v.surface)
	  v.surface = nil
   end   
end

function Tileset.loadTilesets(self)
   local k = 0
   for i, v in ipairs(self) do
	  if v.tiles[1].type and #v.tiles[1].type then
		 for j, t in ipairs(v.tiles) do
			if t.type then
			   self.named[t.type] = self:initTile(v, k)
			end
			k = k + 1
		 end
	  end
   end
end

