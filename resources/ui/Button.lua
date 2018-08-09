require("util/static")
require("text/Text")
Button = Class()

function Button.which(buttons,x,y)
   local r
   for i,b in ipairs(buttons) do
	  r = b.rect
	  if x >= r[1] and x < r[1] + r[3] and y >= r[2] and y < r[2] + r[4] then
		 return b, i
	  end
   end
end

-- creates a new button
-- self now owned by button
function Button.new (self)
   setmetatable(self, Button)
   self:resize()
   return self
end

function Button:resize()
   self.rect = self.layout:rect()
   local r = self.rect
   local c = self.color
   local s, l, h = Text.textbox(self.text, 2, r[3], r[4], {255,255,255,255})
   local s2 = Surface.newBlank(r[3], r[4])
   Surface.fill(s2, 0, 0, r[3], r[4], c[1], c[2], c[3], c[4])
   Surface.blit(s2, s, 0, (r[4] - h) // 2)
   self:destroy()
   self.tex = Surface.textureFrom(s2)
   self.spr = Sprite.new(self.tex, r[1], r[2], r[3], r[4], 0, 0) -- sprite
   Surface.destroy(s)
   Surface.destroy(s2)
end

function Button:draw()
   self.spr:draw(0,0)
end

-- deallocate button
function Button:destroy()
   if self.tex then
	  Texture.destroy(self.tex)
   end
   if self.spr then
	  self.spr:destroy()
   end
end
