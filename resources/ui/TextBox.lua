require("util/static")
require("ui/UIElement")
require("text/Text")
TextBox = Class()

function TextBox.new(self)
   setmetatable(self, TextBox)
   local layout = self.layout
   self.j = layout.e.justify or 1
   self.fg = layout.e.fg or {255,255,255,255}
   self.direction = layout.e.direction
   self:resize()
   return self
end

function TextBox:setText(text, start)
   self.start = start or 0
   self.text = text
   self:resize()
end

function TextBox:setStart(start)
   self.start = start or 0
   self:resize()
end

function TextBox:resize()
   self:destroy()
   self.rect = self.layout:rect()
   local r = self.rect
   local text = self.text
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

function TextBox:draw()
   self.spr:draw(0,0)
end

function TextBox:destroy()
   if self.spr then
	  self.spr:destroy()
   end
   if self.tex then
	  Texture.destroy(self.tex)
   end
end

if not Start then
   dofile("util.lua")
   function Start()
	  style = getStyle("test/textbox")
	  scene = {{s="screen",c={
				   {n="box",s="box"}
			  }}}
	  named,scene = UIElement.getNamed(scene, style)
	  t = TextBox.new({text=dofile("text/loremipsum.lua"), layout=named.box})
   end

   function Update()
	  --Update = static.quit
	  t:draw()
   end

   function End()
	  t:destroy()
   end
end

