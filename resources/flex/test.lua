require("util")
local isMain = Util.isMain()
require("data/save")
require("flex/flex")
local F = Flex

function Flex.Start()
   cells = dofile("flex/test.layout.lua")
   rects = Flex.calculateRects(cells, {0,0,SCREEN_WIDTH,SCREEN_HEIGHT})
   things = Flex.new(cells, rects)
   Flex.setData(things, nil)
end

function Flex.Update()
   --Update=static.quit()
   Flex.draw(things)
end

function Flex.Resize(w, h)
   Util.Resize(w,h)
   rects = Flex.calculateRects(cells, {0,0,SCREEN_WIDTH,SCREEN_HEIGHT})
   Flex.setRects(things, rects)
end

function Flex.End()
   Flex.destroy(things)
end

Util.try(isMain, F)
