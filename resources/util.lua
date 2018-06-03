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

--Map.__index = metareplacer(Map)
