require("util")
Util.isMain()

UIButton = Class()
function UIButton.new(cell, rect)
   local self = {rect=rect,text=cell.text}
   UIView.setBackground(self, cell)
   self.context = cell.context
   if cell.name then
	  self.name = cell.name
   end
   setmetatable(self, UIButton)
   if self.rect then
	  self:setRect(self.rect)
   end
   return self
end

function UIButton:setRect(rect)
   self.rect = rect
   local r = self.rect
   self:destroy()
   if r[3] > 0 and r[4] > 0 then
      local s = UIView.makeBackground(self, rect)
	  if self.text and #self.text > 0 then
		 local text, l, h = Text.textbox(self.text, 2, r[3], r[4], {255,255,255,255})
		 Surface.blit(s, text, 0, (r[4] - h) // 2)
		 Surface.destroy(text)
	  end
      self.t = Surface.textureFrom(s)
      Surface.destroy(s)
   end
end

function UIButton:setData(data)
   UIView.setBackground(self, data)
   self.text = data.text
   self.fn = data.click -- click fn
   if self.rect then
	  self:setRect(self.rect)
   end
end

function UIButton:click(pt)
   if self.fn then
	  return self.fn(self.context, pt, self)
   end
   return true
end

function UIButton:draw()
   if self.t then
      local r = self.rect
      Texture.renderCopy(self.t, 0, 0, r[3], r[4], r[1], r[2], r[3], r[4])
   end
end

function UIButton:destroy()
   if self.t then
      Texture.destroy(self.t)
      self.t = nil
   end
end
