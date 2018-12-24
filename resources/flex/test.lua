require("util")
local isMain = Util.isMain()
require("data/save")
require("flex/flex")
local F = Flex

function Flex.Start()
   print("hi")
   cells = dofile("flex/test.layout.lua")
   rects = Flex.calculateRects(cells, {0,0,SCREEN_WIDTH,SCREEN_HEIGHT})
   print(rects)
   print(table.tostring(rects))
   things = Flex.new(cells, rects)
   print("things")
   Flex.setData(things,
		rects
   )
   print("end")
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
