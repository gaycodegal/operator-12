dofile("util.lua")
require("text/text")
require("cmd/keys")
function KeyDown(key)
   if key == KEY_ESCAPE then
	  return static.quit()
   elseif key == KEY_LSHIFT or key == KEY_RSHIFT then
	  shiftHeld = true
	  return
   elseif key == KEY_ENTER then
	  print(table.concat(line))
	  line = readLine()
   end
   
   local sym
   if shiftHeld then
	  sym = SHIFT_KEYS[key]
   else
	  sym = KEYS[key]
   end
   if sym then
	  down(line, sym)
   end
end

function KeyUp(key)
   if key == KEY_LSHIFT or key == KEY_RSHIFT then
	  shiftHeld = false
   end
end

function Start()
   shiftHeld = false
   line = readLine()
end

function Update()
   --Update = static.quit
end

function End()
   shiftHeld = false
end
function down(line, sym)
    line[line.n]=sym
    line.n=1+line.n
end

function readLine()
    return {n=1}
end
