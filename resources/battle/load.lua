dofile("util.lua")
require("battle/map")
dofile("slug/slug.lua")
require("ai/ai")
require("ai/player")
require("tiled/tilesets")
function Start(name)
   if name == nil then
	  name = "spawner-test.lua"
   end
   map = Map.new(dofile("maps/"..name))
   overlay = {dofile("battle/overlay.lua")}
   Tileset.loadTilesets(overlay)
   
   Player.prepareForTurn()
end

function Update()
   --Update = static.quit
   map:update()
   map:draw()
   if Player.slug then
	  Player.slug:drawOverlay()
   end
   static.wait(math.floor(1000/60))
end

function End()
   Tileset.destroyTilesets(overlay)
   overlay = nil
   Slug.unload()
   map:destroy()
   Slug.despawn()
   map = nil
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
   elseif key == 32 then
	  if active == Player.move then
		 active = Player.attack
		 if Player.slug then
			Player.slug:destroyOverlay()
			Player.slug:attackOverlay(Player.slug.stats.range)
		 end
	  elseif active == Player.attack then
		 Player.returnControl()
		 AI.prepareForEnemyTurns()
	  end
   end
end

function MouseDown(x, y)
   if active ~= nil then
	  local px, py = Map.positionToCoords(x,y)	  
	  active(px,py)
   end
end
