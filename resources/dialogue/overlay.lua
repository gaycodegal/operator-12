require("util")
require("ui/UIElement")
require("ui/button")
Dialogue = {}
function Dialogue.start(text)
   local style = dofile("ui/styles/dialogue-overlay.style.lua")
   local named, scene = UIElement.getNamed({{s="screen",c={
						   {s="dialogue", n=1}
									}}}, style)
   Dialogue.scene = scene
   Dialogue.dialogue = named[1]
end



if not Start then
   function Start()
	  Dialogue.start(dofile("test-text.lua"))
   end
end
