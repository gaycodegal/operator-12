require("util")
Util.isMain()

UIList = Class()

--[[
   create a list, conforms to flex constructor
]]
function UIList.new(cell, rect)
   local self = {
	  rect = rect,
	  draggable = (cell.axis ~= nil),
	  delta = {0, 0},
	  axis = cell.axis,
   }
   UIView.setBackground(self, cell)
   if cell.name then
	  self.name = cell.name
   end
   setmetatable(self, UIList)
   return self
end

--[[
   set the list's data
   @param cells layout
   @param children already init'd views
]]
function UIList:setData(cells, children)
   self:destroy()
   self.cells = cells
    -- avoid sub-calls to children by different name
   self.c = children
   self:setRect(self.rect)
end

--[[
   set the boy's rect
]]
function UIList:setRect(rect)
   self.rect = rect
   if self.cells and self.c then
	  local cell = {
		 axis=vertical,
		 children = self.cells,
	  }
	  self.rects = Flex.calculateRects(cell, self.rect)
	  Flex.setRects(self.c, self.rects)
   end
end

--[[
   set the list's drag to dx, dy
]]
function UIList:moveTo(dx, dy)
   self.delta = {0, 0}
   self:moveBy(dx, dy)
end

--[[
   drag the list by dx, dy
   @param dx delta x
   @param dy delta y
]]
function UIList:moveBy(dx, dy)
   local d = {dx, dy}
   local a = self.axis
   local sd = self.delta
   sd[a] = sd[a] + d[a]
   if sd[a] < 0 then
	  sd[a] = 0
   end
end

--[[
   click the boy
]]
function UIList:click(pt)
   local d = self.delta
   pt = {pt[1] - d[1], pt[2] - d[2]}
   return Flex.click(pt, self.c, self.rects)
end

--[[
   draw the boy
]]
function UIList:draw()
   local r = {0, 0, SCREEN_WIDTH, SCREEN_HEIGHT}
   local rs = self.rect
   static.setRenderClip(rs[1], rs[2], rs[3], rs[4])
   local x = self.delta[1]
   local y = self.delta[2]
   local v = self.c
   for i = 1,v.n do
	  if v[i] then
		 v[i]:draw(x, y)
	  end
   end
   rs = r
   static.setRenderClip(rs[1], rs[2], rs[3], rs[4])
end

--[[
   destroy the boy
]]
function UIList:destroy()
   if self.c then
	  Flex.destroy(self.c)
   end
   self.rects = nil
   self.cells = nil
end

