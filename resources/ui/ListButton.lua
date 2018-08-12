require("util")
local isMain = Util.isMain()
require("ui/UIElement")
require("ui/Button")
ListButton = Class()
local LB = ListButton

function LB.new(name, fns, texts, height, space, align)
   space = space or 0
   height = height or 30
   local nb = #fns
   self = {}
   setmetatable(self, LB)
   self.name = name
   self.fns = fns
   self.align = align
   self.texts = texts
   self.c = {}
   if align ~= 2 then
	  self.child = {
		 n=self.name .. "-c",
		 s="lbChild",
		 d={n=nb,align=align,s=space,h=height}}
	  table.insert(self.c, self.child)
   end
   for i = 1,nb do
	  table.insert(self.c, {
					  n=self.name .. i,
					  s="listButton",
					  d={n=nb, align=align, s=space, h=height, i=(i-1)}})
   end
   self.container = {n=self.name .. "-p",s="lbContainer",c=self.c}
   self.initialized = false
   return self
end

function LB:init(named)
   if not self.initialized then
	  self.btns = {}
	  for i=1,#self.fns do
		 table.insert(self.btns, Button.new({
			   text=self.texts[i],
			   layout=named[self.name .. i],
			   color={0,0,200,255},
			   click=self.fns[i]}))
	  end
	  if self.align ~= 2 then
		 self.child=named[self.name .. "-c"]
	  end
	  self.initialized = true
   end
end

function LB:resize()
   for i,b in ipairs(self.btns) do
	  b:resize()
   end
end

function LB:draw()
   for i,b in ipairs(self.btns) do
	  b:draw()
   end
end

function LB:destroy()
   for i,b in ipairs(self.btns) do
	  b:destroy()
   end
   self.initialized = false
   self.btns = nil
end

function LB:which(x,y)
   return Button.which(self.btns, x,y)
end

-- TESTS BELOW

function LB:testClick()
   print(self.text)
end

function LB.MouseDown(x,y)
   local b = LB.buttons:which(x,y)
   if b then
	  b:click()
   end
end

function LB.Resize(w,h)
   Util.Resize(w,h)
   UIElement.recalc(LB.scene)
   LB.buttons:resize()
end

function LB.Start()
   require("ui/TextBox")
   LB.buttons = LB.new(
	  "boye",
	  {LB.testClick,LB.testClick,LB.testClick,LB.testClick},
	  {"a","bb", "cs", "doo", "eff"},
	  60, 10, 3)
   LB.scene = {{s="screen",c=LB.buttons.c}}
   LB.named, LB.scene = UIElement.getNamed(
	  LB.scene, getStyles({"list-button", "screen"}))
   LB.buttons:init(LB.named)
   --since algin is != 2, we have a self.child style
   LB.t = TextBox.new({text="testing testing 123", layout=LB.buttons.child})
end

function LB.Update()
   --Update=static.quit
   LB.buttons:draw()
   LB.t:draw()
end

function LB.End()
   LB.buttons:destroy()
   LB.t:destroy()
end

Util.try(isMain, LB)
