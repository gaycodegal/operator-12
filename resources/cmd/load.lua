dofile("util.lua")
require("ui/TextBox")
require("cmd/keys")
Log = {data={},maxData=10,search=0}

function Log.setLineN(line, n)
   if n > #line + 1 then
	  n = #line + 1
   elseif n < 1 then
	  n = 1
   end
   line.n = n
end

function KeyDown(key)
   if key == KEY_ESCAPE then
	  return static.quit()
   elseif key == KEY_LSHIFT or key == KEY_RSHIFT then
	  Log.shiftHeld = true
	  return
   elseif key == KEY_BACKSPACE then
	  Log.setLineN(Log.line, Log.line.n - 1)
	  table.remove(Log.line, Log.line.n)
	  Log.updateInput()
	  return
   elseif key==KEY_LEFT then
	  Log.setLineN(Log.line, Log.line.n - 1)
	  Log.updateInput()
	  return
   elseif key==KEY_RIGHT then
	  Log.setLineN(Log.line, Log.line.n + 1)
	  Log.updateInput()
	  return
   elseif key == KEY_UP then
	  Log.searchTo(Log.search + 2)
	  return
   elseif key == KEY_DOWN then
	  Log.searchTo(Log.search - 2)
	  return
   elseif key == KEY_ENTER then
	  local cmd = table.concat(Log.line)
	  local isSetOp = false
	  local ocmd = cmd
	  Log.search = 0
	  if string.sub(cmd,1,1) == ":" then
		 cmd = string.sub(cmd,2)
		 isSetOp = true
	  else
		 cmd = "return " .. cmd
	  end
	  Log.line = Log.readLine()
	  Log.inputline:setText("")
	  local success, result = load(cmd)
	  if success then
		 result = success
		 local temp = {pcall(result)}
		 success = temp[1]
		 local length = 0
		 for i,v in ipairs(temp) do
			temp[i] = "[" .. (i-1) .. "]: " .. tostring(temp[i])
			length = i
		 end
		 result = table.concat(temp," ",2,length)
	  end
	  
	  Log.addMessage(ocmd)
	  if not success then
		 Log.addMessage("ERROR!\n"..result)
	  elseif not isSetOp then
		 Log.addMessage(tostring(result))
	  else
		 Log.addMessage("ok")
	  end
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
   Log.screenW = (SCREEN_WIDTH // TTF.size("M")) - 1
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
   Log.addMessage("GameEngine Lua command line!\nif setting variables start the line with the ':' character")
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
   table.insert(line, line.n, sym)
   line.n = line.n + 1
   Log.updateInput()
end

function Log.updateInput()
   local l = Log.line
   local sl = #l
   if sl == 0 then
	  Log.inputline:setText("")
	  return
   end
   local dif = max(Log.screenW-min(sl - l.n, Log.screenW), Log.screenW//2)
   local low = min(max(l.n-dif,1),sl)
   local high = max(min(low + Log.screenW, sl), low)
   Log.inputline:setText(table.concat(l,"", low, high))
end

function Log.readLine(x)
   x = x or {}
   x.n = #x + 1
   return x
end

function Log.addMessage(m)
   table.insert(Log.data, m)
   if #Log.data > Log.maxData then
	  table.remove(Log.data, 1)
   end
   Log.log:setText(table.concat(Log.data,"\n"))
end

function Log.write(fname)
   local handle = io.open(fname, "w")
   handle:write(table.concat(Log.data,"\n"))
   handle:close()
   return "ok"
end

function Log.split(str)
   local t = {}
   for i = 1,#str do
	  table.insert(t, string.sub(str,i,i))
   end
   return t
end

function Log.searchTo(i)
   local dlen = #Log.data
   if i >= dlen then
	  i = dlen
   elseif i <= 0 then
	  i = 0
   end
   i = (i // 2) * 2
   if i == 0 then
	  Log.line=Log.readLine()
   else
	  Log.line=Log.readLine(Log.split(Log.data[#Log.data - i + 1]))
   end
   Log.search = i
   Log.inputline:setText(table.concat(Log.line))
end
