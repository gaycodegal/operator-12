require("util/static")
Util = {}

function Util.KeyUp(key)
   if key == KEY_ESCAPE then
	  static.quit()
   end
end

function Util.KeyDown(key)

end

function Util.Resize(w, h)
   SCREEN_WIDTH = w
   SCREEN_HEIGHT = h
end

function Util.MouseDown(x,y)

end

function Util.MouseMove(x,y)

end

function Util.MouseUp(x,y)

end

--Map.__index = metareplacer(Map)

function Util.setController(controller)
   local f = {"Start", "Update", "End", "Resize", "KeyDown", "KeyUp", "MouseDown", "MouseMove", "MouseUp"}
   for i, v in ipairs(f) do
	  if controller[v] then
		 rawset(_G, v, controller[v])
	  else
		 rawset(_G, v, Util[v])
	  end
   end
end

function Util.isMain()
   if Util.main then
	  return false
   end
   Util.main = true
   return true
end

function Util.try(isMain, controller)
   if isMain then
	  Util.setController(controller)
   end
end
