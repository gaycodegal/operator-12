require("ui/TextBox")

MoneyUI = {}
local M = MoneyUI

function MoneyUI.new(named)
   local t = TextBox.new({text="0$", layout=named.money})
   t.set = M.set
   return t
end

function MoneyUI:set(x)
   self:setText(tostring(x) .. "$")
end


