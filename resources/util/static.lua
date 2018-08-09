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

function meta(t)
   t.__index = metareplacer(t)
end

function Class()
   local t = {}
   meta(t)
   return t
end

function makeGlobal(x)
   for k,v in pairs(x) do
      rawset(_G, k, v)
   end
end

function listdir(path)
   return dofile(path .. ".contents.lua")
end

function table.copy(t)
   for k, v in pairs(t) do
	  rawset(t, k, v)
   end
end

function min(x,y)
   if x < y then
	  return x
   end
   return y
end

function max(x,y)
   if x < y then
	  return y
   end
   return x
end

function merge(dst,src)
   for k,v in pairs(src) do
	  dst[k] = v
   end
end

makeGlobal(Game)
