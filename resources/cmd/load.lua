dofile("util.lua")
require("text/text")

function KeyDown(key)
   if key == KEY_ESCAPE then
	  static.quit()
   elseif key == KEY_UP then
	  updateForPage(page - 14)
   elseif key == KEY_DOWN then
	  updateForPage(page + 14)
   elseif key == KEY_LEFT then
	  updateForPage(page - 14)
   elseif key == KEY_RIGHT then
	  updateForPage(page + 14)
   end
end

function Start()
   
end

function Update()
   --Update = static.quit
   Button.drawAll()
end

function End()
   Button.destroyAll()
end
