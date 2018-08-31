DUtil = {}

--[[
Go to point

@param point 

@return callback closure
]]
function DUtil.go(point)
   return function(self)
	  self:go(self.dialogue, point)
   end
end

--[[
reload current point

@param self 
]]
function DUtil.reload(self)
   self:go(self.dialogue, self.point)
end

--[[
load a view controller in the global scope

@param name 

@return callback closure
]]
function DUtil.loadGlobalController(name)
   return function (self)
	  End()
	  Util.setController(rawget(_G, name))
	  Start(0,{})
   end
end
