require("util")
local isMain = Util.isMain()
Flex = {}
local F = Flex
--[[
{{1,"w"},{30,"dp"},children={}}
]]
function Flex.calculateRects(cell, rect, direction, odirection)
   local size = rect[direction + 2]
   local osize = rect[odirection + 2]
   local x = rect[direction]
   local ox = rect[odirection]
   
   local flexible = size
   local weight = 0
   local children = cell.children
   -- calculate how much room standard things take up
   -- sum weights
   for i, child in ipairs(children) do
      local amount = child[direction]
      if amount[2] == "dp" then -- density dependant pix
	 flexible = flexible - amount[1]
      elseif amount[2] == "sp" then -- scalable pix
	 flexible = flexible - amount[1]
      elseif amount[2] == "w" then --weight
	 weight = weight + amount[1]
      end
   end
   
   local rects = {}
   for i, child in ipairs(children) do
      local amount = child[direction]
      local mass = 0
      if amount[2] == "dp" then -- density dependant pix
	 mass = amount[1]
      elseif amount[2] == "sp" then -- scalable pix
	 mass = amount[1]
      elseif amount[2] == "w" and flexible >= 0 then --weight
	 mass = math.ceil(amount[1] / weight * flexible)
	 if mass > flexible then
	    mass = flexible
	 end
	 flexible = flexible - mass
	 weight = weight - mass
      end
      if mass > size then
	 mass = size
      end
      size = size - mass
      
      rects[i] = Flex.makebox(direction, odirection, x, ox, mass, osize)
   end

   return rects
end

function Flex.makebox(direction, odirection, size, osize, x, ox)
   local rect = {0, 0, 0, 0}
   rect[direction] = x
   rect[odirection] = ox
   rect[direction + 2] = size
   rect[odirection + 2] = osize
   return rect
end

function Flex.Start()
   
end

function Flex.Update()
   Update=static.quit()
end

function Flex.End()
   
end

Util.try(isMain, F)
