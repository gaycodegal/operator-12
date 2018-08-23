require("util")
local isMain = Util.isMain()
require("ui/UIElement")
require("ui/Button")
ListButton = Class()
local LB = ListButton

--[[--
   creates a new list button

   a ui element that contains multiple buttons in a list, and possibly a space for some text above or below it.

   if align = 2 then there is no child container space

   MUST CALL init before use
   
   @param name unique id
   @param fns callbacks for buttons
   @param texts texts for buttons
   @param height height of one button
   @param space space between buttons
   @param align {1=align button top, 2=middle, 3=bottom}

   @return new list button
]]
function ListButton.new(name, fns, texts, height, space, align)
   space = space or 0
   height = height or 30
   local nb = #fns
   local self = New(LB)
   self.name = name
   self.fns = fns
   self.texts = texts
   self.height = height
   self.space = space
   self.align = align
   self.c = {}
   if align ~= 2 then
	  self.child = {
		 n=self.name .. "-c",
		 s="lbChild",
		 d={n=nb,align=align,s=space,h=height}}
	  table.insert(self.c, self.child)
   end
   table.insert(self.c, {
				   n=self.name .. "-b",
				   s="listButton",
				   d={n=1, align=align, s=space, h=height, i=0}})
   self.container = {n=self.name .. "-p",s="lbContainer",c=self.c}
   self.initialized = false
   return self
end

--[[--
   finish initialize button once layout is loaded

   @param named Named ui elements
]]
function ListButton:init(named)
   self.named = named
   if not self.initialized then
	  self.btns = {}
	  local layout = named[self.name .. "-b"]
	  local nb = #self.fns
	  self.container = named[self.name .. "-p"]
	  self.container.c={}
	  local c = self.container.c
	  if self.align ~= 2 then
		 self.child=named[self.name .. "-c"]
		 self.child.d.n = nb
		 table.insert(c, self.child)
	  end
	  for i = 1,nb do
		 local d = {n=nb, align=self.align, s=self.space, h=self.height, i=(i-1)}
		 local cpy = layout:copy(d)
		 table.insert(c, cpy)		 
		 table.insert(self.btns, Button.new({
							text=self.texts[i],
							layout=cpy,
							color={0,0,200,255},
							click=self.fns[i]}))
	  end
	  UIElement.recalc({self.container})
	  self.initialized = true
   end
end

--[[--
   resize my boy
]]
function ListButton:resize()
   for i,b in ipairs(self.btns) do
	  b:resize()
   end
end

--[[--
   draw my boy
]]
function ListButton:draw()
   for i,b in ipairs(self.btns) do
	  b:draw()
   end
end

--[[--
   Sets up new buttons to replace the old. Number of buttons does not have to remain constant

   WARNING, you may need to resize your child elements of this button after calling this

   @param fns New onclicks
   @param texts New texts
]]
function ListButton:setButtons(fns, texts)
   local named = self.named
   self:destroy()
   self.fns = fns
   self.texts = texts
   self:init(named)
   self:resize()
end

--[[--
   destroy my boy
]]
function ListButton:destroy()
   if self.btns then
	  for i,b in ipairs(self.btns) do
		 b:destroy()
	  end
   end
   self.initialized = false
   self.btns = nil
   self.named = nil
end

--[[--
   which of our boys was pressed

   @param x 
   @param y 

   @return that boy, index or just like nil
]]
function ListButton:which(x,y)
   return Button.which(self.btns, x,y)
end

-- TESTS BELOW

--[[
   test click callback
]]
function ListButton:testClick()
   print(self.text)
end

--[[
   click our boys

   @param x 
   @param y 
]]
function ListButton.MouseDown(x,y)
   local b = LB.buttons:which(x,y)
   if b then
	  b:click()
   end
end

--[[
   resize scene

   @param w 
   @param h 
]]
function ListButton.Resize(w,h)
   Util.Resize(w,h)
   UIElement.recalc(LB.scene)
   LB.buttons:resize()
end

--[[
   test boys
]]
function ListButton.Start()
   require("ui/TextBox")
   LB.buttons = ListButton.new(
	  "boye",
	  {LB.testClick,LB.testClick,LB.testClick,LB.testClick},
	  {"a","bb", "cs", "doo", "eff"},
	  60, 10, 3)
   LB.scene = {{s="screen",c={LB.buttons.container}}}
   LB.named, LB.scene = UIElement.getNamed(
	  LB.scene, getStyles({"list-button", "screen"}))
   LB.buttons:init(LB.named)
   --since algin is != 2, we have a self.child style
   LB.t = TextBox.new({text="testing testing 123", layout=LB.buttons.child})
end

--[[
   test boys
]]
function ListButton.Update()
   --Update=static.quit
   LB.buttons:draw()
   LB.t:draw()
end

--[[
   stop test boys
]]
function ListButton.End()
   LB.buttons:destroy()
   LB.t:destroy()
end

Util.try(isMain, LB)
