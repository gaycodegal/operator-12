require("util")
local isMain = Util.isMain()
require("ui/UIElement")
require("text/Text")
TextBox = Class()

--[[--
   Create a new textbox

   @param self 
   @param self.text
   @param self.layout
   @param self.layout.e
   @param self.layout.e.justify optional
   @param self.layout.e.fg optional
   @param self.layout.e.bg optional

   @return new textbox
]]
function TextBox.new(self)
   setmetatable(self, TextBox)
   local layout = self.layout
   self.j = layout.e.justify or 1
   self.fg = layout.e.fg or {255,255,255,255}
   self.bg = layout.e.bg or {0,0,0,0}
   self.direction = layout.e.direction
   self:setStart()
   return self
end

--[[--
   set boy's text

   @param text 
   @param start 
]]
function TextBox:setText(text, start)
   self.start = start or 1
   self.text = text
   self:resize()
end

--[[--
   set start position (doesn't do much yet? I forget)

   @param start 
]]
function TextBox:setStart(start)
   self.start = start or 1
   self:resize()
end

--[[
desc.

@return
]]
function TextBox:next()
   local text = self.text
   self:setStart(self.start + self.displaying)
   local ltext = #text
   if self.start > ltext then
	  self.start = ltext + 1
   end
   return self.start > ltext
end

--[[--
   resize the boy
]]
function TextBox:resize()
   self:destroy()
   self.rect = self.layout:rect()
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

--[[--
   desc.

   @return
]]
function TextBox:draw()
   self.spr:draw(0,0)
end

--[[--
   desc.

   @return
]]
function TextBox:destroy()
   if self.spr then
	  self.spr:destroy()
   end
   if self.tex then
	  Texture.destroy(self.tex)
   end
end

--[[
   start the boy's tests
]]
function TextBox.Start()
   TextBox.style = getStyle("test/textbox")
   TextBox.scene = {{s="screen",c={
						{n="box",s="box"}
				   }}}
   TextBox.named,TextBox.scene = UIElement.getNamed(TextBox.scene, TextBox.style)
   TextBox.t = TextBox.new({text="testing testing 123", layout=TextBox.named.box})
end

--[[
   draw
]]
function TextBox.Update()
   --Update = static.quit
   TextBox.t:draw()
end

--[[
   end
]]
function TextBox.End()
   TextBox.t:destroy()
end


Util.try(isMain, TextBox)
