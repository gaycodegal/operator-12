require("util/static")
function Fake()
   local mt = {}
   mt.__index = function(t, f)
      v = rawget(t, f)
      if v ~= nil then
		 return v
      end
	  v = rawget(mt, f)
      if v ~= nil then
		 return v
      end
      return function () end
   end
   return mt
end

TTF = Fake()
Surface = Fake()
function TTF.size(x)
   return #x
end

