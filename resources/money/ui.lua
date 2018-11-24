require("ui/TextBox")

MoneyUI = {}
local M = MoneyUI

function MoneyUI.new(named)
   local t = TextBox.new({text="0$", layout=named.money})
   t.add = M.add
   t.money = 0
   return t
end

function MoneyUI:add(x)
   self.money = self.money + x
   self:setText(tostring(x) .. "$")
end


