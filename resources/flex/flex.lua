Flex = {}
--[[
   cell: {axis=1|2, class=string, size={int, "dp"|"sp"|"w"}, children?={cell+}}
   rect: {X, Y, W, H}
]]
function Flex.calculateRects(cell, rect)
   local direction = cell.axis
   local odirection = 1
   if direction == 1 then
      odirection = 2
   else
      direction = 2
   end
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
      local amount = child.size
      if amount[2] == "dp" then -- density dependant pix
	 flexible = flexible - amount[1]
      elseif amount[2] == "sp" then -- scalable pix
	 flexible = flexible - amount[1]
      elseif amount[2] == "w" then --weight
	 weight = weight + amount[1]
      end
   end
   local rects = {}
   --generate rects
   for i, child in ipairs(children) do
      local amount = child.size
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
	 weight = weight - amount[1]
      end
      if mass > size then
	 mass = size
      end
      size = size - mass
      rects[i] = Flex.makebox(direction, odirection, x, ox, mass, osize)
      x = x + mass
   end

   --generate children rects
   for i, child in ipairs(children) do
      if child.children then
	 rects[i].children = Flex.calculateRects(child, rects[i])
      end
   end

   return rects
end

function Flex.makebox(direction, odirection, x, ox, size, osize)
   local rect = {0, 0, 0, 0}
   rect[direction] = x
   rect[odirection] = ox
   rect[direction + 2] = size
   rect[odirection + 2] = osize
   return rect
end

function Flex.init(cell, rects, data)
   local objects = {}
   for i, child in ipairs(children) do
      if child.class then
	 local class = _G[child.class]
	 objects[i] = class.new(cell, rects[i], data)
      end
   end
end
