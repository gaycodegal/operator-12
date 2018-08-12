require("util")
local isMain = Util.isMain()
require("text/Text")
require("ui/Button")
require("ui/UIElement")
require("battle/load")
MapSelect = {}
local M = MapSelect

--[[
desc.

@param self 

@return
]]
function M.LoadFile(self)
   M.End()
   
   Util.setController(Battle)
   
   Start(self.text)
end

--[[
desc.

@return
]]
function M.destroyButtons()
   for i,b in ipairs(M.buttons) do
	  b:destroy()
   end
   M.buttons = {}
end

--[[
desc.

@param p 

@return
]]
function M.updateForPage(p)
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

--[[
desc.

@param key 

@return
]]
function M.KeyDown(key)
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

--[[
desc.

@return
]]
function M.Start()
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
desc.

@param w 
@param h 

@return
]]
function M.Resize(w, h)
   SCREEN_WIDTH = w
   SCREEN_HEIGHT = h
   UIElement.recalc(M.scene)
   M.updateForPage(M.page)
end

--[[
desc.

@param t 
@param ticks 

@return
]]
function M.Update(t, ticks)
   --Update = static.quit
   for i,b in ipairs(M.buttons) do
	  b:draw()
   end
   local weight = 100
   trueticks = max(1, (trueticks * weight + trueticks - (ticks - framedelay))//(weight + 1))
   static.framedelay(trueticks)
end

--[[
desc.

@return
]]
function M.End()
   M.destroyButtons()
end

--[[
desc.

@param x 
@param y 

@return
]]
function M.MouseDown(x,y)
   local b = Button.which(M.buttons, x,y)
   if b then
	  b:click(x,y)
   end
end

Util.try(isMain, M)
