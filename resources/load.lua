dofile("util.lua")
require("text/text")
require("ui/button")

function LoadFile(self)
   End()
   dofile("battle/load.lua")
   Start(self.text)
end

function updateForPage(p)
   Button.destroyAll()
   if p < 1 then
	  p = 1
   end
   if p > #maps then
	  p = #maps - 14
   else
	  page = p
   end
   local spacing = 10
   local w = (SCREEN_WIDTH - spacing * 5) // 4
   local h = (SCREEN_HEIGHT - spacing * 5) // 4
   for i = 0,15 do
	  local name = maps[i+page]
	  if name then
		 local x = ((i) % 4)
		 local y = ((i) // 4)
		 local rx = spacing*(x +1)+w * x
		 local ry = spacing * (y+1) + h*y
		 Button.new({text=name, rect={rx,ry, w,h}, color={0,0,200,255},click=LoadFile})
	  end
   end
end

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
   print(Text.charsInLine("test", 100))
   print("hi")
   page = 1
   maps = listdir("maps/")
   updateForPage(page)
   print("end start")
end

function Update()
   --Update = static.quit
   print("eyy")
   Button.drawAll()
   print("butddon")
   static.wait(1000/60)
   print("fuck")
end

function End()
   Button.destroyAll()
   print("goodbye")
end

function MouseDown(x,y)
   print(x,y)
   b = Button.which(x,y)
   if b then
	  b:click(x,y)
   end
end
