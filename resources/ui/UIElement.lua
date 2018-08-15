require("util")

UIElement = {named={}}
meta(UIElement)

--[[--
load a style from disk

@param name style's name

@return said style
]]
function getStyle(name)
   return dofile("ui/styles/"..name..".style.lua")
end

--[[--
load multiple styles

@param names all them boye's names

@return all dem styles as one
]]
function getStyles(names)
   local all = {}
   for i, name in ipairs(names) do
	  merge(all, getStyle(name))
   end
   return all
end

--[[--
Creates UIElements
Calculates their properties when loaded

@param e Elements list to render
@param parent parent of current element list (nil is fine)

@return table of named entities; Array.<UIElement> generated elements
]]
function UIElement.getNamed(e,style,parent)
   UIElement.named = {}
   local scene = UIElement.fromStatic(e,style,parent)
   local named = UIElement.named
   UIElement.recalc(scene)
   return named, scene
end

--[[--
Creates UIElements

@param e Elements list to render
@param parent parent of current element list (nil is fine)

@return Array.<UIElement> generated elements
]]
function UIElement.fromStatic(e,style,parent)
   local resize
   local level = {}
   local nc
   local t
   for i, v in ipairs(e) do
	  resize = style[v.s]
	  if v.c then
		 nc = #v.c
	  else
		 nc = 0
	  end
	  t = UIElement.new(v, resize, nc, parent)
	  if nc >= 1 then
		 t.c = UIElement.fromStatic(v.c,style,t)
	  end
	  if v.n then
		 t.n = v.n
		 UIElement.named[v.n] = t
	  end
	  level[i] = t
   end
   return level
end

--[[--
Calculates/recalcs element properties
and subchildren

@param e Elements list to operate on
]]
function UIElement.recalc(e)
   for k,v in ipairs(e) do
	  v:resize()
	  if v.c then
		 UIElement.recalc(v.c)
	  end
   end
end

--[[--
Calculates/recalcs element properties

@private

@param v.s Style name
@param v.d Data table
@param resize onResize function
@param nchildren number of children
@param parent of elem

@return new boy
]]
function UIElement.new(v,layout,nchildren,parent)
   if not layout then
	  print(v.s, "not found")
   end
   local self = {d=v.d,resize=layout.resize,e=layout.e,nc=nchildren,p=parent, layout=layout}
   setmetatable(self, UIElement)
   return self
end

function UIElement:copy(d)
   local c = UIElement.new({d=d}, self.layout, self.nc, self.p)
   c:resize()
   return c
end

--[[--
Prints self and children
]]
function UIElement:print()
   print(self.n, self.x, self.y, self.w, self.h)
   if self.c then
	  for i,v in ipairs(self.c) do
		 v:print()
	  end
   end
end

--[[--
   get boy's rect
   @return {x,y,w,h}
]]
function UIElement:rect()
   return {self.x, self.y, self.w, self.h}
end
