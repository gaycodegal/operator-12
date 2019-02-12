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
						name=key,
			    size={1,"w"},
			    color="ff00ff"}
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
   standard Flex mouse down

   @param x 
   @param y 
]]
function MainMenu.MouseDown(x,y)
   Flex.mouseDown(M, x, y)
end

--[[
   standard Flex mouse move

   @param x 
   @param y 
]]
function MainMenu.MouseMove(x,y)
   Flex.mouseMove(M, x, y)
end

--[[
   standard Flex mouse up

   @param x 
   @param y 
]]
function MainMenu.MouseUp(x,y)
   Flex.mouseUp(M, x, y)
end

function MainMenu.MouseWheel(x,y,dx,dy)
   Flex.mouseWheel(M, x, y, dx, dy)
end

--[[
   resize

   @param w 
   @param h 
]]
function MainMenu.Resize(w,h)
   Util.Resize(w,h)
   M.rects = Flex.calculateRects(M.cells, {0,0,SCREEN_WIDTH,SCREEN_HEIGHT})
   Flex.setRects(M.views, M.rects)
   --UIElement.recalc(M.scene)
   --M.buttons:resize()
   
end

--[[--
   Basic menu setup
]]
function MainMenu.Start()
   M.cells = Flex.load("layout.lua")
   local named = Flex.getNamed(M.cells.children)
   named.main.size[1] = ListButton.heightOf(4, 60, 10)
   M.rects = Flex.calculateRects(M.cells, {0,0,SCREEN_WIDTH,SCREEN_HEIGHT})
   M.views = Flex.new(M.cells, M.rects)
   named = Flex.getNamed(M.views)
   ListButton.init(named.main,
				   {M.switchTo(MapSelect),M.toCredits,M.switchTo(World),M.switchTo(Dialogue)},
				   {"Level Selection", "Credits/Thanks", "World Map Test", "Dialogue Test"},
				   60, 10)
   --[[local data = {"EEE", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p"}
   local named = Flex.getNamed(M.views) 
   for i, v in ipairs(data) do
	  local dat = {text=v, click=M.click}
	  if i > 6 then
		 dat = {color="00ff0000"}
	  end
      named[i]:setData(dat)
	  end]]
end

function MainMenu.click(object, pt)
   print("click reg @", pt[1], pt[2], object.text)
end

--[[
   draw things
]]
function MainMenu.Update()
   --Update=static.quit
   Flex.draw(M.views)
   --M.buttons:draw()
end

--[[
   destroy things
]]
function MainMenu.End()
   Flex.destroy(M.views)
   M.views = nil
   M.cells = nil
   M.rects = nil
end

Util.try(isMain, M)
