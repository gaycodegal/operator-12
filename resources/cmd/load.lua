dofile("util.lua")
require("ui/TextBox")
require("cmd/keys")
Log = {data={},maxData=10}

function KeyDown(key)
   if key == KEY_ESCAPE then
	  return static.quit()
   elseif key == KEY_LSHIFT or key == KEY_RSHIFT then
	  Log.shiftHeld = true
	  return
   elseif key == KEY_BACKSPACE then
	  table.remove(Log.line)
	  Log.updateInput()
	  return
   elseif key == KEY_ENTER then
	  local cmd = table.concat(Log.line)
	  Log.line = Log.readLine()
	  Log.inputline:setText("")
	  Log.addMessage(cmd)
	  local success, result = pcall(load, "return " .. cmd)
	  if success then
		 local temp = {pcall(result)}
		 success = temp[1]
		 local length = 0
		 for i,v in ipairs(temp) do
			temp[i] = "[" .. (i-1) .. "]: " .. tostring(temp[i])
			length = i
		 end
		 result = table.concat(temp," ",2,length)
	  end
	  
	  if not success then
		 Log.addMessage("ERROR!")
	  end
	  Log.addMessage(tostring(result))
	  return
   end
   
   local sym
   if Log.shiftHeld then
	  sym = SHIFT_KEYS[key]
   else
	  sym = KEYS[key]
   end
   if sym then
	  Log.down(Log.line, sym)
   end
end

function KeyUp(key)
   if key == KEY_LSHIFT or key == KEY_RSHIFT then
	  Log.shiftHeld = false
   end
end

function Start()
   Log.shiftHeld = false
   Log.line = Log.readLine()
   Log.style = getStyle("cmd/cmd")
   Log.scene = {{s="screen",c={
					{n="input",s="input"},
					{n="log",s="log"}
			   }}}
   Log.named,Log.scene = UIElement.getNamed(Log.scene, Log.style)
   Log.inputline = TextBox.new({text="type a command", layout=Log.named.input})
   Log.log = TextBox.new({text="", layout=Log.named.log})
   Log.addMessage("GameEngine Lua command line")
   static.framedelay(1000)
end

function Update()
   --Update = static.quit
   Log.inputline:draw()
   Log.log:draw()
end

function End()
   Log.shiftHeld = false
   Log.inputline:destroy()
   Log.log:destroy()
end

function Log.down(line, sym)
   table.insert(line, sym)
   Log.updateInput()
end

function Log.updateInput()
   Log.inputline:setText(table.concat(Log.line))
end

function Log.readLine()
   return {n=1}
end

function Log.addMessage(m)
   table.insert(Log.data, m)
   if #Log.data > Log.maxData then
	  table.remove(Log.data, 1)
   end
   Log.log:setText(table.concat(Log.data,"\n"))
end
