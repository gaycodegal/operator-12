Flex = {
   rDrag = 10,
   horizontal = 1,
   vertical = 2,
}
require("flex/UIGroup")
require("flex/UIList")
require("flex/UITextBox")
require("flex/UIView")
require("flex/UIButton")

--[[--
   calculate the rects that views will take up given the
   parent rect (usually {0, 0, SCREEN_WIDTH, SCREEN_HEIGHT}
   and the view's layout cell.

   @param cell {axis=1|2, class=string, size={int, "dp"|"sp"|"w"}, children?={cell+}}
   @param rect {X, Y, W, H}
   @return rects of the cells
]]
function Flex.calculateRects(cell, rect, nolimit)
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
      if not nolimit and mass > size then
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

--[[--
   helper function to make a rect

   @param direction primary direction either 1|2 (horizontal|vertical)
   @param odirection secondary direction either 1|2 (horizontal|vertical)
   opposite of direction
   @param x position (x|y) of start of rect in the primary axis
   @param ox position (x|y) of start of rect in the secondary axis
   @param size size (width|height) of start of rect in the primary axis
   @param osize size (width|height) of start of rect in the secondary axis
   @return crafted rect
]]
function Flex.makebox(direction, odirection, x, ox, size, osize)
   local rect = {0, 0, 0, 0}
   rect[direction] = x
   rect[odirection] = ox
   rect[direction + 2] = size
   rect[odirection + 2] = osize
   return rect
end

--[[--
   Initialize the views given the layout (cell) and the rects
   these should occupy

   @param cell the layout
   @param rects generated by Flex.calculateRects
   @return newly created views
]]
function Flex.new(cell, rects)
   local views = {}
   views.n = #rects
   for i, rect in ipairs(rects) do
      local child = cell.children[i]
      if (not child.class) and child.children then
		 child.class = UIGroup
      end
      if child.class then
		 local class = child.class
		 views[i] = class.new(child, rect, i)
      end
      if child.children then
		 views[i].children = Flex.new(child, rect.children)
      end
   end
   return views
end

--[[--
   Set the rects of views
   
   @param views to have their rects set
   @param rects to set as the views' rects
]]
function Flex.setRects(views, rects)
   for i = 1, views.n do
      local child = views[i]
      local rect = rects[i]
      if child then
		 child:setRect(rect)
		 if child.children then
			Flex.setRects(child.children, rect.children)
		 end
      end
   end
end

--[[--
   is `pt` in `rect`
   @param pt point to check
   @param rect to test if in
   @return whether `pt` in `rect`
]]
function Flex.isInBound(pt, rect)
   return pt[1] >= rect[1] and pt[1] <= rect[1] + rect[3] and pt[2] >= rect[2] and pt[2] <= rect[2] + rect[4]
end

--[[
   Function that makes objectAtPoint work to find draggable objects
   @return returns nil if not a draggable object, object otherwise
]]
function Flex.doGetDraggable(object, pt)
   if object.draggable then
      return object
   end
end

--[[--
   If there is a draggable object at point fetch it
   @return returns nil if no a draggable object at point, view otherwise
]]
function Flex.getDraggable(pt, views, rects)
   return Flex.objectAtPoint(pt, views, rects, Flex.doGetDraggable)
end

--[[
   Function that makes objectAtPoint work as a clicking function
   @return non nil/false if click was consumed, nil/false otherwise
]]
function Flex.doClick(object, pt)
   if object.click then
      return object.click(object, pt)
   end
end

--[[--
   Do click at point
   @return non nil/false if click was consumed, nil/false otherwise
]]
function Flex.click(pt, views, rects)
   return Flex.objectAtPoint(pt, views, rects, Flex.doClick)
end

--[[--
   Apply a function to a view at a point
   @return result of calling fn on view at point
]]
function Flex.objectAtPoint(pt, views, rects, fn)
   for i = 1, views.n do
      local child = views[i]
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

--[[--
   Get all named members of views
   @return dict of {name=view...}
]]
function Flex.getNamed(views)
   return Flex._getNamed(views, {})
end

--[[
   Helper. Get all named members of views
   @return dict of {name=view...}
]]
function Flex._getNamed(views, named)
   local len = views.n or #views
   for i = 1, len do
      local child = views[i]
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

--[[--
   Draw the views
]]
function Flex.draw(views)
   for i = 1, views.n do
      local child = views[i]
      if child then
		 views[i]:draw(0, 0)
		 if child.children then
			Flex.draw(child.children)
		 end
      end
   end
end

--[[--
   destroy the views
]]
function Flex.destroy(views)
   for i = 1, views.n do
      local child = views[i]
      if child then
		 views[i]:destroy()
		 if child.children then
			Flex.destroy(child.children)
		 end
      end
   end
end

--[[--
   Handles the common scenario of mouse wheel
   @param M module or object doing the clicking
   @param x coord
   @param y coord
   @param dx scroll dx
   @param dx scroll dy
]]
function Flex.mouseWheel(M, x, y, dx, dy)
   local draggable = Flex.getDraggable({x, y}, M.views, M.rects)
   if draggable then
      if dx < 0 then
	 dx = -10
      elseif dx > 0 then
	 dx = 10
      end
      if dy < 0 then
	 dy = -10
      elseif dy > 0 then
	 dy = 10
      end
      draggable:moveBy(dx, dy)
   end
   
   return draggable
end

--[[--
   Handles the common scenario of clicking / dragging mouse down
   @param M module or object doing the clicking
   @param x coord
   @param y coord
]]
function Flex.mouseDown(M, x, y)
   M.draggable = Flex.getDraggable({x, y}, M.views, M.rects)
   M.last = {x, y}
   M.dragging = false
end

--[[--
   Handles the common scenario of clicking / dragging mouse move
   @param M module or object doing the clicking
   @param x coord
   @param y coord
]]
function Flex.mouseMove(M, x, y)
   local last = M.last
   if M.draggable then
	  local dx = x - last[1]
	  local dy = y - last[2]
	  if M.dragging or math.abs(dx) > Flex.rDrag or math.abs(dy) > Flex.rDrag then
		 M.draggable:moveBy(dx, dy)
		 M.last = {x, y}
		 M.dragging = true
	  end
   end
end

--[[--
   Handles the common scenario of clicking / dragging mouse up
   @param M module or object doing the clicking
   @param x coord
   @param y coord
]]
function Flex.mouseUp(M, x, y)
   local result = true
   if not M.dragging then
	  result = Flex.click({x, y}, M.views, M.rects)
   end
   M.draggable = nil
   M.dragging = false
   M.last = nil
   return result
end

--[[--
   loads a file in the flex scope
]]
function Flex.load(fname)
   return uloadfile(fname, "bt", Flex)
end
