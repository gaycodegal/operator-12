require("util/static")
require("ui/UIElement")
require("text/Text")
TextBox = Class()

function TextBox.new(self)
   setmetatable(self, TextBox)
   local layout = self.layout
   self.j = layout.e.justify or 1
   self.fg = layout.e.fg or {255,255,255,255}
   self.CIL = Text.charsInLine
   self.sub = Text.sub
   print(layout.e.direction)
   if layout.e.direction == 1 then
	  self.CIL = Text.charsInLineRev
	  self.sub = Text.subRev
   end
   self:resize()
   return self
end

function TextBox:text(text, start)
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
   local s, l, h = Text.textbox(
	  self.text,
	  self.j,
	  r[3],
	  r[4],
	  self.fg,
	  self.CIL,
	  self.sub)
   self.displaying = l
   local bg = self.bg or {255,128,128,255}
   local s2 = Surface.newBlank(r[3], r[4])
   Surface.fill(s2, 0, 0, r[3], r[4], bg[1], bg[2], bg[3], bg[4])
   Surface.blit(s2, s, 0, (r[4] - h) // 2)
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

