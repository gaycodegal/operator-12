require("util")
local isMain = Util.isMain()

--[[
   Render to texture + glitch art.

   Also a good demo of what textures can do currently
]]
function Start()
   music, err = Music.new("test.ogg")
   print(music, err)
   paused = false
   music:play(-1)
   static.framedelay(1000)
end

--[[
   draw some random colored copies
]]
function Update()
   --Update = static.quit
end

--[[
   destroy things
]]
function End()
   music:destroy()
end

function KeyDown(k)
   if k == KEY_ESCAPE then
	  static.quit()
   elseif k == KEY_SPACE then
	  paused = not paused
	  if paused then
		 music:pause()
	  else
		 music:resume()
	  end
   end
end

--purely a test class, so I used globals and then just told Util to pull off the global env instead of a class
Util.try(isMain, _G)
