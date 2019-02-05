require("util")
local isMain = Util.isMain()
require("text/Text")
require("ui/Button")
require("ui/UIElement")
require("battle/load")
MapSelect = {}
local M = MapSelect

--[[--
   Button onclick, load map associated with button

   @param self Button
]]
function MapSelect.LoadFile(self)
   M.End()
   
   Util.setController(Battle)
   
   Start(2, {"battle/load", self.text})
end

--[[--
   Destroy all active buttons
]]
function MapSelect.destroyButtons()
   for i,b in ipairs(M.buttons) do
	  b:destroy()
   end
   M.buttons = {}
end

function MapSelect.layout()
   local class = UIView
   local rows, cols = 4, 4

   local space = {size={10, "dp"}}
   local childRow = {}
   local key = 1
   for i = 1, 2 * rows, 2 do
      local childCol = {}
      for j = 1, 2 * cols, 2 do
	 childCol[j] = space
	 childCol[j + 1] = {class=class,
			    size={1,"w"},
			    color="ff00ff",
			    key=key}
	 key = key + 1
      end
      childCol[2 * cols + 1] = space
      childRow[i] = space
      childRow[i + 1] = {axis=vertical,
			 size={1,"w"},
			 children=childCol}
   end
   childRow[2 * rows + 1] = space
   
   return {
      axis=vertical,
      children={
	 {axis=horizontal,
	  size={1,"w"},
	  children=childRow}
      }
   }
end

--[[--
   page select which maps to display

   @param p page number
]]
function MapSelect.updateForPage(p)
   M.destroyButtons()
   if p < 1 then
	  p = 1
   end
   if p > #M.maps then
	  p = #M.maps - 14
   else
	  M.page = p
   end
   for i = 0,15 do
	  local name = M.maps[i+M.page]
	  if name then
		 M.buttons[i + 1] = Button.new({text=name, layout=M.named[i+1], color={0,0,200,255}, click=M.LoadFile})
	  end
   end
end

--[[--
   Turn page/quit

   @param key 
]]
function MapSelect.KeyDown(key)
   if key == KEY_ESCAPE then
	  static.quit()
   elseif key == KEY_UP then
	  M.updateForPage(M.page - 14)
   elseif key == KEY_DOWN then
	  M.updateForPage(M.page + 14)
   elseif key == KEY_LEFT then
	  M.updateForPage(M.page - 14)
   elseif key == KEY_RIGHT then
	  M.updateForPage(M.page + 14)
   end
end

--[[--
   Loads list of available maps, will display them in a grid
]]
function MapSelect.Start()
   local btns = {}
   M.buttons = {}
   M.scene = {{s="screen",c=btns}}
   for i = 1,16 do
	  btns[i] = {n=i,s="button",d={(i-1)%4,(i-1)//4}}
   end
   M.named, M.scene = UIElement.getNamed(M.scene, dofile("ui/styles/map-select.style.lua"))
   --M.scene[1]:print()
   framedelay = 1000/10
   trueticks = framedelay
   M.page = 1
   M.maps = listdir("maps/")
   M.updateForPage(M.page)
   static.framedelay(framedelay)
end

--[[
   resize

   @param w 
   @param h 
]]
function MapSelect.Resize(w, h)
   SCREEN_WIDTH = w
   SCREEN_HEIGHT = h
   UIElement.recalc(M.scene)
   M.updateForPage(M.page)
end

--[[
   Draw, also tries to keep it close to the target framerate as an experiment

   @param t time since last frame as a fraction of a second
   @param ticks true ticks (ms) between last frame, can be 0
]]
function MapSelect.Update(t, ticks)
   --Update = static.quit
   for i,b in ipairs(M.buttons) do
	  b:draw()
   end
   local weight = 100
   trueticks = max(1, (trueticks * weight + trueticks - (ticks - framedelay))//(weight + 1))
   static.framedelay(trueticks)
end

--[[
   destroy things
]]
function MapSelect.End()
   M.destroyButtons()
end

--[[
   handle buttons

   @param x 
   @param y 

   @return
]]
function MapSelect.MouseDown(x,y)
   local b = Button.which(M.buttons, x,y)
   if b then
	  b:click(x,y)
   end
end

Util.try(isMain, M)
