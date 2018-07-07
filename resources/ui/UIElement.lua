require("util")

UIElement = {named={}}
UIElement.__index = metareplacer(UIElement)

function UIElement.getNamed(e,style,childs,parent)
   UIElement.named = {}
   local scene = UIElement.fromStatic(e,style,childs,parent)
   local named = UIElement.named
   UIElement.recalc(scene)
   return named, scene
end

function UIElement.fromStatic(e,style,childs,parent)
   local resize
   local level = childs or {}
   local nc
   local t
   for i, v in ipairs(e) do
	  resize = style[v.s]
	  if v.c then
		 nc = #v.c
	  else
		 nc = 0
	  end
	  t = UIElement.new(v.d, resize, nc, parent)
	  level[i] = t
	  if v.n then
		 t.n = v.n
		 UIElement.named[v.n] = t
	  end
	  if nc >= 1 then
		 t.c = {}
		 UIElement.fromStatic(v.c,style,t.c,t)
	  end
   end
   return level
end

function UIElement.recalc(e)
   for k,v in ipairs(e) do
	  v:resize()
	  if v.c then
		 UIElement.recalc(v.c)
	  end
   end
end

function UIElement.new(d,resize,nchildren,parent)
   local self = {d=d,resize=resize,nc=nchildren,p=parent}
   setmetatable(self, UIElement)
   return self
end

function UIElement:print()
   print(self.n, self.x, self.y, self.w, self.h)
   if self.c then
	  for i,v in ipairs(self.c) do
		 v:print()
	  end
   end
end

function UIElement:rect()
   return {self.x, self.y, self.w, self.h}
end
