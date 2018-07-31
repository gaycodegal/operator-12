dofile("util.lua")
require("text/Text")
require("ui/Button")
require("ui/UIElement")
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
   for i = 0,15 do
	  local name = maps[i+page]
	  if name then
		 Button.new({text=name, layout=named[i+1], color={0,0,200,255}, click=LoadFile})
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
   local btns = {}
   scene = {{s="screen",c=btns}}
   for i = 1,16 do
	  btns[i] = {n=i,s="button",d={(i-1)%4,(i-1)//4}}
   end
   named, scene = UIElement.getNamed(scene, dofile("ui/styles/main-menu.style.lua"))
   --scene[1]:print()
   framedelay = 1000//60
   page = 1
   maps = listdir("maps/")
   updateForPage(page)
   static.framedelay(framedelay)
end

function Resize(w, h)
   SCREEN_WIDTH = w
   SCREEN_HEIGHT = h
   UIElement.recalc(scene)
   updateForPage(page)
end

function Update()
   --Update = static.quit
   Button.drawAll()
end

function End()
   Button.destroyAll()
end

function MouseDown(x,y)
   b = Button.which(x,y)
   if b then
	  b:click(x,y)
   end
end
