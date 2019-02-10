require("util")
Util.isMain()

UITextBox = Class()
Flex.UITextBox = UITextBox

--[[
   A textbox that works with flex.

   complies with flex constructor.
]]
function UITextBox.new(cell, rect)
   local self = {}
   if cell.name then
	  self.name = cell.name
   end
   setmetatable(self, UITextBox)
   self:setProps(cell)

   -- rect not set, won't resize
   self:setText(cell.text)
   
   -- rect set (can now resize)
   self.rect = rect
   if self.rect then
	  self:setRect(self.rect)
   end
   return self
end

--[[
   set all textbox properties

   @param data
   @param data.fg foreground (text) color
   @param data.bg background color
   @param data.j justification
]]
function UITextBox:setProps(data)
   if not data then
	  data = {}
   end
   local fg = data.fg and {parseColor(data.fg)}
   local bg = data.bg and {parseColor(data.bg)}
   
   self.j = data.justify or self.j or 1
   self.fg = fg or self.fg or {255,255,255,255}
   self.bg = bg or self.bg or {0,0,0,0}
   self.direction = data.direction or self.direction
end


--[[--
   set boy's text

   @param text 
   @param start 
]]
function UITextBox:setText(text, start)
   self.text = text
   self:setStart(start)
end

--[[--
   set start position (doesn't do much yet? I forget)

   @param start 
]]
function UITextBox:setStart(start)
   self.start = start or 1
   if self.rect then
	  self:setRect(self.rect)
   end
end

--[[
   go to next unseen bit of text
   
   @return bool whether has shown all text already
]]
function UITextBox:next()
   local text = self.text
   self:setStart(self.start + self.displaying)
   local ltext = #text
   if self.start > ltext then
	  self.start = ltext + 1
   end
   return self.start > ltext
end

--[[
   set the boy's text
]]
function UITextBox:setRect(rect)
   self.rect = rect
   local r = self.rect
   self:destroy()
   if r[3] > 0 and r[4] > 0 then
	  local r = self.rect
	  local text = self.text
	  if self.start > #text then
		 text = ""
	  elseif self.start ~= 1 then
		 text = string.sub(text, self.start)
	  end
	  if self.direction == 2 then
		 local len, h = Text.charsInTextbox(
			self.text,
			r[3],
			r[4],
			2)
		 text = string.sub(text, #text - len + 1, -1)
	  end
	  local s, l, h = Text.textbox(
		 text,
		 self.j,
		 r[3],
		 r[4],
		 self.fg,
		 1)
	  self.displaying = l
	  local bg = self.bg or {255,128,128,255}
	  local s2 = Surface.newBlank(r[3], r[4])
	  Surface.fill(s2, 0, 0, r[3], r[4], bg[1], bg[2], bg[3], bg[4])
	  Surface.blit(s2, s, 0, 0)
	  self.tex = Surface.textureFrom(s2)
	  self.spr = Sprite.new(self.tex, r[1], r[2], r[3], r[4], 0, 0) -- sprite
	  Surface.destroy(s)
	  Surface.destroy(s2)
   end
end

--[[
   set the boy's data. don't use tbh
]]
function UITextBox:setData(data)
   self:setText(data.text, data.start)
end

--[[
   draw the boy
]]
function UITextBox:draw()
   if self.spr then
	  self.spr:draw(0,0)
   end
end

--[[
   destroy the boy
]]
function UITextBox:destroy()
   if self.spr then
	  self.spr:destroy()
   end
   if self.tex then
	  Texture.destroy(self.tex)
   end
end
