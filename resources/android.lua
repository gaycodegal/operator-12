function require(modname)
   if package.loaded[modname] then
      return package.loaded[modname]
   end
   local mod = Game.static.readfile(modname .. ".lua")
   local x = load(mod)
   if x == nil then
      x = true
   else
      x = x() or true
   end
   package.loaded[modname] = x
   return package.loaded[modname]
end
require("load.lua")
