require("util/static")

function KeyUp(key)
   if key == KEY_ESCAPE then
	  static.quit()
   end
end

function KeyDown(key)

end

function Resize(w, h)
   SCREEN_WIDTH = w
   SCREEN_HEIGHT = h
end

function MouseDown(x,y)

end

function MouseUp(x,y)

end

--Map.__index = metareplacer(Map)
