require("util")
Util.isMain()

UIGroup = Class()
--[[
   arbitrary grouping ui class
]]
function UIGroup.new(cell, rect)
   local self = {}
   setmetatable(self, UIGroup)
   return self
end

function UIGroup:setRect(rect)
end

function UIGroup:setData(data)
   if self.children then
      Flex.setData(self.children, data)
   end
end

function UIGroup:draw()
end

function UIGroup:destroy()
end
