dofile("util.lua")
require("text/text")
require("cmd/keys")
function KeyDown(key)
   if key == KEY_ESCAPE then
	  return static.quit()
   elseif key == KEY_LSHIFT or key == KEY_RSHIFT then
	  shiftHeld = true
	  return
   end
   local sym
   if shiftHeld then
	  sym = SHIFT_KEYS[key]
   else
	  sym = KEYS[key]
   end
   print(sym)
end

function KeyUp(key)
   if key == KEY_LSHIFT or key == KEY_RSHIFT then
	  shiftHeld = false
   end
end

function Start()
   shiftHeld = false
end

function Update()
   --Update = static.quit
end

function End()
   shiftHeld = false
end
