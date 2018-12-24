require("util")
require("tiled/tilesets")
Util.isMain()

UIView = Class()
function UIView.new(cell, rect)
   local self = {rect=rect}
   self.color = cell.color
   setmetatable(self, UIView)
   return self
end

function UIView:setRect(rect)
   self.rect = rect
   local r = self.rect
   local s = Surface.newBlank(r[3], r[4])
   Surface.fill(s, 0, 0, r[3], r[4], parseColor(self.color)) 
   self.t = Surface.textureFrom(s)
   Surface.destroy(s)
end

function UIView:setData(data)
   self:setRect(self.rect)
end

function UIView:draw()
   local r = self.rect
   Texture.renderCopy(self.t, 0, 0, r[3], r[4], r[1], r[2], r[3], r[4])
end

function UIView:destroy()
   if self.t then
      Texture.destroy(self.t)
   end
end
