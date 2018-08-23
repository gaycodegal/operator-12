UpdateStack = {}

--[[--
   indexing checks metatable first
   and falls back to object if that fails

   @param mt metatable
]]
function metareplacer(mt)
   return function(t, f)
      v = rawget(t, f)
      if v ~= nil then
		 return v
      end
      return rawget(mt, f)
   end
end

--[[--
   metareplaces t

   @param t table
]]
function meta(t)
   t.__index = metareplacer(t)
end

--[[--
   creates a new already metareplaced object ready to become a class

   @return new class table
]]
function Class()
   local t = {}
   meta(t)
   return t
end

--[[--
   creates a new already metareplaced instance
   
   @param class Class to create an instance of
]]
function New(class)
   self = {}
   setmetatable(self, class)
   return self
end

--[[--
   make everything in x global

   @param x table
]]
function makeGlobal(x)
   for k,v in pairs(x) do
      rawset(_G, k, v)
   end
end

--[[--
   list everything in dir, hack cause neither lua nor C supported it. C++ probably has a better solution.
   
   @param path 

   @return contents
]]
function listdir(path)
   return dofile(path .. ".contents.lua")
end

--[[--
   copy a table

   @param t table to copy

   @return new table
]]
function table.copy(t)
   local n = {}
   for k, v in pairs(t) do
	  rawset(n, k, v)
   end
   return n
end

--[[
   DONT USE see math.min

   @deprecated
   @private

   @param x 
   @param y 

   @return
]]
function min(x,y)
   if x < y then
	  return x
   end
   return y
end

--[[
   DONT USE see math.max

   @deprecated
   @private

   @param x 
   @param y 

   @return
]]
function max(x,y)
   if x < y then
	  return y
   end
   return x
end

--[[
   merge 2 tables

   @param dst destination
   @param src source
]]
function merge(dst,src)
   for k,v in pairs(src) do
	  dst[k] = v
   end
end

--[[--
   prints out a table

   @param t table to print
]]
function table.print(t)
   if type(t) ~= "table" then
	  print(t)
	  return
   end
   print("__#__", #t)
   for k,v in pairs(t) do
	  print(k,v)
   end
end

--[[
desc.

@param t 
@param fn 

@return
]]
function table.map(t, fn)
   local t2 = {}
   for k,v in pairs(t) do
	  t2[k] = fn(k,v)
   end
   return t2
end

if Game then makeGlobal(Game) end
