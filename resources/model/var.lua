require("util")

ModelVar = Class()

function ModelVar.new(holder, key)
   local self = {holder=holder, key=key}
   setmetatable(self, ModelVar)
   return self
end

function ModelVar:listen(listener)
   self.listener = listener
   listener:set(self.holder[self.key])
end

function ModelVar:add(value)
   local new = self.holder[self.key] + value
   self:set(new)
   return new
end

function ModelVar:get()
   return self.holder[self.key]
end

function ModelVar:set(value)
   self.holder[self.key] = value
   if self.listener then
      self.listener:set(value)
   end
end
