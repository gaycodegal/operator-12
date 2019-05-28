require "util"
local isMain = Util.isMain()
require "world/Sector"
require "tiled/tilesets"
World = {}
local W = World
--[[--
   Load a sector of the world map.

   @param argv[2] name of sector
]]
function World.Start(argc, argv)
   framedelay = 1000//60
   local name = argv[2]
   if name == nil then
	  name = "main"
   end
   static.framedelay(framedelay)
   
end

--[[
   resize things

   @param w 
   @param h 
]]
function World.Resize(w, h)
   SCREEN_WIDTH = w
   SCREEN_HEIGHT = h
   W.sector:recenter()
end

--[[--
   draw things, update map
]]
function World.Update()
   Update = static.quit
   W.sector:update()
   W.sector:draw()
end

--[[
   destroy things
]]
function World.End()
   W.sector:destroy()
   W.sector = nil
end

--[[--
   pan camera about map or quit

   @param key 
]]
function World.KeyDown(key)
   if key == KEY_ESCAPE then
	  static.quit()
   elseif key == KEY_UP then
	  W.sector.dy = -W.sector.speed
   elseif key == KEY_DOWN then
	  W.sector.dy = W.sector.speed
   elseif key == KEY_LEFT then
	  W.sector.dx = -W.sector.speed
   elseif key == KEY_RIGHT then
	  W.sector.dx = W.sector.speed
   end
end

--[[--
   Stop panning or quit

   @param key 
]]
function World.KeyUp(key)
   if key == KEY_ESCAPE then
	  static.quit()
   elseif key == KEY_UP and W.sector.dy < 0 then
	  W.sector.dy = 0
   elseif key == KEY_DOWN and W.sector.dy > 0 then
	  W.sector.dy = 0
   elseif key == KEY_LEFT and W.sector.dx < 0 then
	  W.sector.dx = 0
   elseif key == KEY_RIGHT and W.sector.dx > 0 then
	  W.sector.dx = 0
   end
end

--[[
   Trigger movement/attack or whatever other action is currently active

   @param x 
   @param y 

   @return
]]
function World.MouseDown(x, y)

end

Util.try(isMain, World)
