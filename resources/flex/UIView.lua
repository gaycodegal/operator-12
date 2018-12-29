require("util")
require("tiled/tilesets")
Util.isMain()

UIView = Class()

function UIView:makeBackground(rect)
   if self.color then
      local r = rect
      local s = Surface.newBlank(r[3], r[4])
      Surface.fill(s, 0, 0, r[3], r[4], parseColor(self.color))
      return s
   end
end

function UIView:setBackground(src)
   if not src then
      return
   end
   if src.color then
      self.color = src.color
   end
end

function UIView.new(cell, rect)
   local self = {rect=rect}
   setmetatable(self, UIView)
   self:setBackground(cell)
   return self
end

function UIView:setRect(rect)
   local r = rect
   self.rect = rect
   self:destroy()
   if r[3] > 0 and r[4] > 0 then
      local s = self:makeBackground(rect)
      self.t = Surface.textureFrom(s)
      Surface.destroy(s)
   end
end

function UIView:setData(data)
   self:setBackground(data)
   self:setRect(self.rect)
end

function UIView:draw()
   if self.t then
      local r = self.rect
      Texture.renderCopy(self.t, 0, 0, r[3], r[4], r[1], r[2], r[3], r[4])
   end
end

function UIView:destroy()
   if self.t then
      Texture.destroy(self.t)
      self.t = nil
   end
end
