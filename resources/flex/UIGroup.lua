require("util")
Util.isMain()

UIGroup = Class()
function UIGroup.new(cell, rect)
   local self = {}
   setmetatable(self, UIGroup)
   return self
end

function UIGroup:setRect(rect)
end

function UIGroup:setData(data)
end

function UIGroup:draw()
end

function UIGroup:destroy()
end
