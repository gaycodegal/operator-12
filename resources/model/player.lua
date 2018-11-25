require("util")
require("model/var")
PlayerModel = Class()

function PlayerModel.new(data)
   if not data then
      data = {money=0}
   end
   local self = {data=data}
   setmetatable(self, PlayerModel)
   self.money = ModelVar.new(data, "money")
   return self
end

function PlayerModel:destroy()
   self.money = nil
   self.data = nil
end
