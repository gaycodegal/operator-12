require("util")
Util.isMain()

UIListGroup = Class()

function UIListGroup.new(cell, rect)
   local self = {}
   setmetatable(self, UIListGroup)
   return self
end

function UIListGroup:setData(data)
   Flex.setDataList(self.children, data)
end

UIListGroup.draw = UIGroup.draw
UIListGroup.destroy = UIGroup.destroy
UIListGroup.setRect = UIGroup.setRect
