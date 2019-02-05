require("ui/TextBox")

MoneyUI = {}
local M = MoneyUI

function MoneyUI.new(named)
   local t = named.money
   t.set = M.set
   return t
end

function MoneyUI:set(x)
   self:setData({text=tostring(x) .. "$"})
end


