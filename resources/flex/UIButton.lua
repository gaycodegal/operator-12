require("util")
require("tiled/tilesets")
Util.isMain()

UIButton = Class()
function UIButton.new(cell, rect)
   local self = {rect=rect, key=cell.key, text=""}
   self.color = cell.color
   setmetatable(self, UIButton)
   return self
end

function UIButton:setRect(rect)
   self.rect = rect
   local r = self.rect
   local s = UIView.makeBackground(self, rect)
   local text, l, h = Text.textbox(self.text, 2, r[3], r[4], {255,255,255,255})
   Surface.blit(s, text, 0, (r[4] - h) // 2)
   Surface.destroy(text)
   self.t = Surface.textureFrom(s)
   Surface.destroy(s)
end

function UIButton:setData(data)
   if data[self.key] then
      self.text = data.text
      self:setRect(self.rect)
   end
end

function UIButton:draw()
   local r = self.rect
   Texture.renderCopy(self.t, 0, 0, r[3], r[4], r[1], r[2], r[3], r[4])
end

function UIButton:destroy()
   if self.t then
      Texture.destroy(self.t)
   end
end
