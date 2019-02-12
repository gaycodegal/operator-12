require("util/static")
Util = {}

--[[--
   keyup fallback
]]
function Util.KeyUp(key)
   if key == KEY_ESCAPE then
      static.quit()
   end
end

--[[--
   keydown fallback
]]
function Util.KeyDown(key)

end

--[[--
   resize fallback

   @param w 
   @param h 
]]
function Util.Resize(w, h)
   SCREEN_WIDTH = w
   SCREEN_HEIGHT = h
end

--[[--
   mousewheel fallback

   @param x 
   @param y 
]]
function Util.MouseWheel(x, y, dx, dy)
   
end

--[[--
   mousedown fallback

   @param x 
   @param y 
]]
function Util.MouseDown(x,y)

end

--[[--
   mousemove fallback

   @param x 
   @param y 
]]
function Util.MouseMove(x,y)

end

--[[--
   fallback

   @param x 
   @param y 
]]
function Util.MouseUp(x,y)

end

--[[--
   Take a class and make global the methods that are expected by C++

   @param controller 
]]
function Util.setController(controller)
   local f = {"Start", "Update", "End", "Resize", "KeyDown", "KeyUp", "MouseWheel", "MouseDown", "MouseMove", "MouseUp"}
   for i, v in ipairs(f) do
      if controller[v] then
	 rawset(_G, v, controller[v])
      else
	 rawset(_G, v, Util[v])
      end
   end
end

--[[--
   First class to call this becomes main.

   Hence there is a pattern of the first import being `require("util")` followed by local `isMain = Util.isMain()` - this guarentees the first loaded class will be main. Other require calls should follow this pattern.

   @return if caller is main 
]]
function Util.isMain()
   if Util.main then
      return false
   end
   Util.main = true
   return true
end

--[[--
   Make a controller the current controller if it says it's main

   @param isMain usually returned from Util.isMain()
   @param controller Controller to make current
]]
function Util.try(isMain, controller)
   if isMain then
      Util.setController(controller)
   end
end
