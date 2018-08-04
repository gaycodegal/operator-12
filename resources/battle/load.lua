dofile("util.lua")
require("battle/map")
dofile("slug/slug.lua")
require("ai/ai")
require("ai/player")
require("tiled/tilesets")

function Start(name)
   framedelay = 1000//60
   if name == nil then
	  name = "test.lua"
   end
   map = Map.new(dofile("maps/"..name))
   overlay = {dofile("battle/overlay.lua")}
   Tileset.loadSurfaces(overlay)
   overlay:asTextures()
   overlay:loadTilesets()
   
   Player.prepareForTurn()
   static.framedelay(framedelay)
end

function Update()
   --Update = static.quit
   map:update()
   map:draw()
   if Player.slug then
	  Player.slug:drawOverlay()
   end
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
			Player.slug:basicOverlay(
			   Player.slug.action.range, Slug.attackOverlayFn)
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
