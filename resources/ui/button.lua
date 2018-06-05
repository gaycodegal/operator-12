require("util")
Button = {}
Button.__index = metareplacer(Button)

-- creates a new button
-- self now owned by button
function Button.new (self)
   if buttons == nil then
	  buttons = {}
   end
   setmetatable(self, Button)
   local r = self.rect
   local c = self.color
   local s = Text.textbox(self.text, r[3], r[4], 255,255,255,255)
   local s2 = Surface.newBlank(r[3], r[4])
   Surface.fill(s2, 0, 0, r[3], r[4], c[1], c[2], c[3], c[4])
   Surface.blit(s2, s, 0, 0)
   self.tex = Surface.textureFrom(s2)
   self.spr = Sprite.new(self.tex, r[1], r[2], r[3], r[4], 0, 0) -- sprite
   Surface.destroy(s)
   Surface.destroy(s2)
   buttons[#buttons + 1] = self
   return self
end

function Button.draw(self)
   self.spr:draw(0,0)
end

function Button.drawAll()
   for i,b in ipairs(buttons) do
	  b:draw()
   end
end

function Button.destroyAll()
   for i,b in ipairs(buttons) do
	  b:destroy()
   end
   buttons = {}
end

function Button.which(x,y)
   local r
   for i,b in ipairs(buttons) do
	  r = b.rect
	  if x >= r[1] and x < r[1] + r[3] and y >= r[2] and y < r[2] + r[4] then
		 return b, i
	  end
   end
end

-- deallocate button
function Button.destroy (self)
   Texture.destroy(self.tex)
   self.spr:destroy()
end
