require("util")
local isMain = Util.isMain()
require("ui/UIElement")
require("ui/ListButton")
require("level-select/load")
require("viewer/load")
MainMenu = {}
local M = MainMenu

function M.toMapSelect()
   M.End()
   Util.setController(MapSelect)
   Start()
end

function M.toCredits()
   M.End()
   Util.setController(Viewer)
   Start(3, {"viewer/load", "licenses/", "\n\n"})
end

function M.MouseDown(x,y)
   local b = M.buttons:which(x,y)
   if b then
	  b:click()
   end
end

function M.Resize(w,h)
   Util.Resize(w,h)
   UIElement.recalc(M.scene)
   M.buttons:resize()
end

function M.Start()
   M.buttons = ListButton.new("menu", {M.toMapSelect,M.toCredits},{"Level Selection", "Credits/Thanks"}, 60, 10, 2)
   M.scene = {{s="screen",c=M.buttons.c}}
   M.named, M.scene = UIElement.getNamed(M.scene, getStyle("list-button"))
   M.buttons:init(M.named)
end

function M.Update()
   --Update=static.quit
   M.buttons:draw()
end

function M.End()
   M.buttons:destroy()
end

Util.try(isMain, M)
