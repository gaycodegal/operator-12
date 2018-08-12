UpdateStack = {}
-- indexing checks metatable first
-- and falls back to object if that fails
function metareplacer(mt)
   return function(t, f)
      v = rawget(t, f)
      if v ~= nil then
		 return v
      end
      return rawget(mt, f)
   end
end

--[[
desc.

@param t 

@return
]]
function meta(t)
   t.__index = metareplacer(t)
end

--[[
desc.

@return
]]
function Class()
   local t = {}
   meta(t)
   return t
end

--[[
desc.

@param x 

@return
]]
function makeGlobal(x)
   for k,v in pairs(x) do
      rawset(_G, k, v)
   end
end

--[[
desc.

@param path 

@return
]]
function listdir(path)
   return dofile(path .. ".contents.lua")
end

--[[
desc.

@param t 

@return
]]
function table.copy(t)
   for k, v in pairs(t) do
	  rawset(t, k, v)
   end
end

--[[
desc.

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
desc.

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
desc.

@param dst 
@param src 

@return
]]
function merge(dst,src)
   for k,v in pairs(src) do
	  dst[k] = v
   end
end

makeGlobal(Game)
