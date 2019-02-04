require("util")
Util.isMain()

UIList = Class()

function UIList.new(cell, rect)
   local self = {rect=rect}
   UIView.setBackground(self, cell)
   if cell.name then
	  self.name = cell.name
   end
   setmetatable(self, UIList)
   return self
end

function UIList:setData(cells, children)
   self.cells = cells
    -- avoid sub-calls to children by different name
   self.c = children
   self:setRect(self.rect)
end

function UIList:setRect(rect)
   if self.cells and self.c then
	  local cell = {
		 axis=vertical,
		 children = self.cells,
	  }
	  self.rects = Flex.calculateRects(cell, self.rect)
	  Flex.setRects(self.c, self.rects)
   end
end

function UIList:click(pt)
   Flex.click(pt, self.c, self.rects)
end

function UIList:draw()
   Flex.draw(self.c)
end

function UIList:destroy()
   Flex.destroy(self.c)
   self.rects = nil
   self.cells = nil
end

