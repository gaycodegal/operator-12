require("util")
require("text/text")
require("ui/button")
function LoadFile(self)
   End()
   require("battle/load")
   Start(self.text)
end
function Start()
   print(Text.charsInLine("test", 100))
   print("hi")
   page = 1
   maps = listdir("maps/")
   local spacing = 10
   local w = SCREEN_WIDTH // 5 - spacing * 3
   local h = SCREEN_HEIGHT // 5
   for i = page,page+16 do
	  local name = maps[i]
	  if name then
		 print(name)
		 local x = ((i-1) % 4)
		 local y = ((i-1) // 4)
		 Button.new({text=name, rect={(spacing)*(x)+SCREEN_WIDTH * x // 5, spacing * y +  SCREEN_HEIGHT * y // 5, w,h}, color={0,0,200,255},click=LoadFile})
	  end
   end
end

function Update()
   --Update = static.quit
   Button.drawAll()
   static.wait(1000/60)
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
