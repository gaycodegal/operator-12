require("flex/UIGroup")
require("flex/UIList")
require("flex/UITextBox")
require("flex/UIView")
require("flex/UIButton")
horizontal = 1
vertical = 2
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

function Flex.new(cell, rects)
   local objects = {}
   objects.n = #rects
   for i, rect in ipairs(rects) do
      local child = cell.children[i]
      if (not child.class) and child.children then
	 child.class = UIGroup
      end
      if child.class then
	 local class = child.class
	 objects[i] = class.new(child, rect, i)
      end
      if child.children then
	 objects[i].children = Flex.new(child, rect.children)
      end
   end
   return objects
end

function Flex.setRects(objects, rects)
   for i = 1, objects.n do
      local child = objects[i]
      local rect = rects[i]
      if child then
	 child:setRect(rect)
	 if child.children then
	    Flex.setRects(child.children, rect.children)
	 end
      end
   end
end

function Flex.isInBound(pt, rect)
   return pt[1] >= rect[1] and pt[1] <= rect[1] + rect[3] and pt[2] >= rect[2] and pt[2] <= rect[2] + rect[4]
end

function Flex.doClick(object, pt)
   if object.click then
      return object.click(object, pt)
   end
end

function Flex.click(pt, objects, rects)
   return Flex.objectAtPoint(pt, objects, rects, Flex.doClick)
end

function Flex.objectAtPoint(pt, objects, rects, fn)
   for i = 1, objects.n do
      local child = objects[i]
      local rect = rects[i]
      if child and Flex.isInBound(pt, rect) then
	 if child.children then
	    local result = Flex.objectAtPoint(pt, child.children, rect.children, fn)
	    if result then
	       return result
	    end
	 end
	 return fn(child, pt)
      end
   end
end

function Flex.getNamed(objects)
   return Flex._getNamed(objects, {})
end

function Flex._getNamed(objects, named)
   local len = objects.n or #objects
   for i = 1, len do
      local child = objects[i]
      if child then
		 if child.name then
			named[child.name] = child
		 end
		 if child.children then
			Flex._getNamed(child.children, named)
		 end
      end
   end
   return named
end

function Flex.draw(objects)
   for i = 1, objects.n do
      local child = objects[i]
      if child then
	 objects[i]:draw()
	 if child.children then
	    Flex.draw(child.children)
	 end
      end
   end
end

function Flex.destroy(objects)
   for i = 1, objects.n do
      local child = objects[i]
      if child then
	 objects[i]:destroy()
	 if child.children then
	    Flex.destroy(child.children)
	 end
      end
   end
end
