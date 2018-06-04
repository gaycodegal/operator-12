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

function makeGlobal(x)
   for k,v in pairs(x) do
      rawset(_G, k, v)
   end
end

makeGlobal(Game)

function KeyUp(key)
   if key == KEY_ESCAPE then
	  static.quit()
   end
end

function listdir(path)
   return dofile(path .. ".contents.lua")
end

--Map.__index = metareplacer(Map)
