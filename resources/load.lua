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
   slug = Slug.new({sprites="test", segs={{2,2}, {2,1}, {1,1}, {1,2}, {1,3}}})
   map = Map.new()
   
end

function Update()
   --Update = static.quit
   map:update()
   map:draw()
   slug:draw()
   active = map
   map.slug = slug
   static.wait(math.floor(1000/60))
end

function End()
   Slug.unload()
   Texture.destroy(tile)
   map:destroy()
   slug:destroy()
   print("goodbye")
end

function KeyDown(key)
   if key == KEY_ESCAPE then
	  static.quit()
   elseif key == KEY_UP then
	  map.dy = -map.speed
   elseif key == KEY_DOWN then
	  map.dy = map.speed
   elseif key == KEY_LEFT then
	  map.dx = -map.speed
   elseif key == KEY_RIGHT then
	  map.dx = map.speed
   end
end

function KeyUp(key)
   if key == KEY_ESCAPE then
	  static.quit()
   elseif key == KEY_UP and map.dy < 0 then
	  map.dy = 0
   elseif key == KEY_DOWN and map.dy > 0 then
	  map.dy = 0
   elseif key == KEY_LEFT and map.dx < 0 then
	  map.dx = 0
   elseif key == KEY_RIGHT and map.dx > 0 then
	  map.dx = 0
   end
end

function MouseDown(x, y)
   if active ~= nil then
	  active:mousedown(x,y)
   end
end
