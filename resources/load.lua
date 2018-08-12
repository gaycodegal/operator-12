require("util")
local isMain = Util.isMain()
require("ui/UIElement")
require("ui/ListButton")
require("level-select/load")
require("viewer/load")
MainMenu = {}
local M = MainMenu

--[[
   on click callback to load map select
]]
function M.toMapSelect()
   M.End()
   Util.setController(MapSelect)
   Start()
end

--[[
   on click callback to load credits
]]
function M.toCredits()
   M.End()
   Util.setController(Viewer)
   Start(3, {"viewer/load", "licenses/", "\n\n"})
end

--[[
   click button

   @param x 
   @param y 
]]
function M.MouseDown(x,y)
   local b = M.buttons:which(x,y)
   if b then
	  b:click()
   end
end

--[[
   resize

   @param w 
   @param h 
]]
function M.Resize(w,h)
   Util.Resize(w,h)
   UIElement.recalc(M.scene)
   M.buttons:resize()
end

--[[
   Basic menu setup
]]
function M.Start()
   M.buttons = ListButton.new(
	  "menu",
	  {M.toMapSelect,M.toCredits},
	  {"Level Selection", "Credits/Thanks"},
	  60, 10, 2)
   M.scene = {{s="screen",c=M.buttons.c}}
   M.named, M.scene = UIElement.getNamed(
	  M.scene, getStyles({"list-button", "screen"}))
   M.buttons:init(M.named)
end

--[[
   draw shit
]]
function M.Update()
   --Update=static.quit
   M.buttons:draw()
end

--[[
   destroy shit
]]
function M.End()
   M.buttons:destroy()
end

Util.try(isMain, M)
