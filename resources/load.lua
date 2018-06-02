require("battle/map")
require("slug/slug")

function makeGlobal(x)
   for k,v in pairs(x) do
      rawset(_G, k, v)
   end
end

makeGlobal(Game)
function Start()
   Slug.load()
   tile, tilew, tileh = Texture.new("images/tile.png")
   slug = Slug.new({sprites="test", segs={{2,2}, {2,1}, {1,1}}})
   map = Map.new()
   
end

function Update()
   --Update = static.quit
   map:update()
   map:draw()
   slug:draw()
   static.wait(math.floor(1000/60))
end

--Update = nil

function End()
   Slug.unload()
   Texture.destroy(tile)
   map:destroy()
   slug:destroy()
   print("goodbye")
end

--[[loadScene()
   endScene()]]

--my machine's keys only, should default to lua's guidance
function KeyDown(key)
   if key == 27 then
	  static.quit()
   elseif key == 1073741906 then
	  map.dy = -map.speed
   elseif key == 1073741905 then
	  map.dy = map.speed
   elseif key == 1073741904 then
	  map.dx = -map.speed
   elseif key == 1073741903 then
	  map.dx = map.speed
   end
end

function KeyUp(key)
   if key == 27 then
	  static.quit()
   elseif key == 1073741906 and map.dy < 0 then
	  map.dy = 0
   elseif key == 1073741905 and map.dy > 0 then
	  map.dy = 0
   elseif key == 1073741904 and map.dx < 0 then
	  map.dx = 0
   elseif key == 1073741903 and map.dx > 0 then
	  map.dx = 0
   end
end
