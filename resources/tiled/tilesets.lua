require("util")
Tileset = {}
Tileset.__index = metareplacer(Tileset)

function Tileset.loadlist(tilesets)

end

-- find tile index <dat> within tilesets
function Tileset.tilefinder(dat, tilesets)
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

function Tileset.destroyTilesets(tilesets)
   for i, v in ipairs(tilesets) do
	  Texture.destroy(v.sheet)
   end
end

function parseColor(color)
   local r = tonumber(string.sub(color, 1,2), 16)
   local g = tonumber(string.sub(color, 3,4), 16)
   local b = tonumber(string.sub(color, 5,6), 16)
   local a = 255
   return r,g,b,a
end

function Tileset.loadTilesets(tilesets)
   for i, v in ipairs(tilesets) do
	  v.w = v.imagewidth // v.tilewidth
	  v.h = v.imageheight // v.tileheight
	  if v.tiles[1].properties.color then
		 local s = Surface.newBlank(v.imagewidth, v.imageheight)
		 for i, t in ipairs(v.tiles) do
			local r,g,b,a = parseColor(t.properties.color)
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
