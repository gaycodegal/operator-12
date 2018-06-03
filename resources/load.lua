require("battle/map")
require("slug/slug")
require("ai/ai")
function makeGlobal(x)
   for k,v in pairs(x) do
      rawset(_G, k, v)
   end
end

makeGlobal(Game)
function Start()
   Slug.load()
   map = Map.new(require("maps/test"))
   map.slug = slugs.Slug1
   local all = AI.findAll(1, nil)
   print(#all)
   AI.sortDist(all, map.slug.head.pos)
   all[1]:print()
   all[2]:print()
end

function Update()
   --Update = static.quit
   map:update()
   map:draw()
   --Slug.renderAll()
   active = map
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
   end
end

function MouseDown(x, y)
   if active ~= nil then
	  active:mousedown(x,y)
   end
end
