require("util")
require("battle/map")
require("slug/slug")
require("ai/ai")
function Start(name)
   if name == nil then
	  name = "spawner-test.lua"
   end
   map = Map.new(dofile("maps/"..name))
   local sname = nil
   for n,slug in pairs(slugs) do
	  if not sname and slug.team == 1 then
		 sname = n
	  elseif slug.team == 1 and n < sname then
		 sname = n
	  end
   end
   map.slug = slugs[sname]
   active = map
end

function Update()
   --Update = static.quit
   map:update()
   map:draw()
   static.wait(math.floor(1000/60))
end

function End()
   Slug.unload()
   map:destroy()
   Slug.despawn()
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
   elseif key == 101 then
	  AI.prepareForEnemyTurns()
   end
end

function MouseDown(x, y)
   if active ~= nil then
	  active:mousedown(x,y)
   end
end
