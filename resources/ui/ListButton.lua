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

--[[--
   finish initialize button once layout is loaded

   @param named Named ui elements
]]
function ListButton:init(named)
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
   destroy my boy
]]
function ListButton:destroy()
   for i,b in ipairs(self.btns) do
	  b:destroy()
   end
   self.initialized = false
   self.btns = nil
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
