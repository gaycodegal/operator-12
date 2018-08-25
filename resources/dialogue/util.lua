DUtil = {}

function DUtil.go(point)
   return function(self)
	  self:go(self.dialogue, point)
   end
end

function DUtil.reload(self)
   self:go(self.dialogue, self.point)
end

function DUtil.loadGlobalController(name)
   return function (self)
	  End()
	  Util.setController(rawget(_G, name))
	  Start(0,{})
   end
end
