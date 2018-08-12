require("util")
local isMain = Util.isMain()
require("ui/UIElement")
require("ui/ListButton")
require("level-select/load")
require("viewer/load")
MainMenu = {}
local M = MainMenu

--[[--
   on click callback to load map select
]]
function MainMenu.toMapSelect()
   M.End()
   Util.setController(MapSelect)
   Start()
end

--[[--
   on click callback to load credits
]]
function MainMenu.toCredits()
   M.End()
   Util.setController(Viewer)
   Start(3, {"viewer/load", "licenses/", "\n\n"})
end

--[[
   click button

   @param x 
   @param y 
]]
function MainMenu.MouseDown(x,y)
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
function MainMenu.Resize(w,h)
   Util.Resize(w,h)
   UIElement.recalc(M.scene)
   M.buttons:resize()
end

--[[--
   Basic menu setup
]]
function MainMenu.Start()
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
function MainMenu.Update()
   --Update=static.quit
   M.buttons:draw()
end

--[[
   destroy shit
]]
function MainMenu.End()
   M.buttons:destroy()
end

Util.try(isMain, M)
