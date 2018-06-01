metareplacer = function(mt)
   return function(t, f)
      v = rawget(t, f)
      if v ~= nil then
	 return v
      end
      return rawget(mt, f)
   end
end

--Map.__index = metareplacer(Map)
