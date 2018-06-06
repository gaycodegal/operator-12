require("util")
Tileset = {}
Tileset.__index = metareplacer(Tileset)

function Tileset.loadlist(tilesets)

end

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

function Tileset.destroyTilesets(tilesets)
   for i, v in ipairs(tilesets) do
	  Texture.destroy(v.sheet)
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
   tex.x = (dat % set.w) * tex.w
   tex.y = (dat // set.w) * tex.h
   return tex
end

function Tileset.loadTilesets(tilesets)
   tilesets.named = {}
   setmetatable(tilesets, Tileset)
   for i, v in ipairs(tilesets) do
	  v.w = v.imagewidth // v.tilewidth
	  v.h = v.imageheight // v.tileheight
	  if v.tiles[1].properties.color then
		 local s = Surface.newBlank(v.imagewidth, v.imageheight)
		 Surface.blendmode(s, BLENDMODE_BLEND)
		 --Surface.fill(s,0,0,200,200,255,0,255,255)
		 for i, t in ipairs(v.tiles) do
			local r,g,b,a = parseColor(t.properties.color)
			if a ~= 0 then
			   Surface.fill(s,(i % v.w) * v.tilewidth,
							(i // v.w) * v.tileheight,
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
		 v.sheet = Surface.textureFrom(s)
		 Surface.destroy(s)
	  else
		 local t, w, h = Texture.new("images/" .. v.image)
		 v.sheet = t
	  end
	  local k = 0
	  if v.tiles[1].type and #v.tiles[1].type then
		 for j, t in ipairs(v.tiles) do
			if t.type then
			   tilesets.named[t.type] = overlay:initTile(v, k)
			end
			k = k + 1
		 end
	  end
   end
end
