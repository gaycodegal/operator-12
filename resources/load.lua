require("util")
local isMain = Util.isMain()
require("flex/flex")
require("data/save")
require("ui/UIElement")
require("ui/ListButton")
require("level-select/load")
require("viewer/load")
require("world/load")
require("dialogue/overlay")
MainMenu = {}
local M = MainMenu

--[[--
   generic no-arg controller switcher
]]
function MainMenu.switchTo(controller)
   return function()
      M.End()
      Util.setController(controller)
      Start(0,{})
   end
end

function MainMenu.layout()
   local class = UIButton
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
      childRow[i + 1] = {axis=horizontal,
			 size={1,"w"},
			 children=childCol}
   end
   childRow[2 * rows + 1] = space
   
   return {
      axis=horizontal,
      children={
	 {axis=vertical,
	  size={1,"w"},
	  children=childRow}
      }
   }
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
   local rects = Flex.calculateRects(M.cells, {0,0,SCREEN_WIDTH,SCREEN_HEIGHT})
   Flex.setRects(M.views, rects)
   --UIElement.recalc(M.scene)
   --M.buttons:resize()
   
end

--[[--
   Basic menu setup
]]
function MainMenu.Start()
   M.cells = M.layout()
   local rects = Flex.calculateRects(M.cells, {0,0,SCREEN_WIDTH,SCREEN_HEIGHT})
   --[[M.buttons = ListButton.new(
      "menu",
      {M.switchTo(MapSelect),M.toCredits,M.switchTo(World),M.switchTo(Dialogue)},
      {"Level Selection", "Credits/Thanks", "World Map Test", "Dialogue Test"},
      60, 10, 2)
      M.scene = {{s="screen",c={M.buttons.container}}}
      M.named, M.scene = UIElement.getNamed(
      M.scene, getStyles({"list-button", "screen"}))
      M.buttons:init(M.named)]]
   M.views = Flex.new(M.cells, rects)
   local data = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p"}
   for i, v in ipairs(data) do
      data[i] = {text=v}
   end
   Flex.setData(M.views, data)
end

--[[
   draw shit
]]
function MainMenu.Update()
   --Update=static.quit
   Flex.draw(M.views)
   --M.buttons:draw()
end

--[[
   destroy shit
]]
function MainMenu.End()
   Flex.destroy(M.views)
   M.views = nil
   M.cells = nil
end

Util.try(isMain, M)
