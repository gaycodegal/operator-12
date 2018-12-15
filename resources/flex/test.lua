require("util")
require("data/save")
require("flex/flex")
local isMain = Util.isMain()
local F = Flex

function Flex.Start()
   print("hi")
   err, res = xpcall(Flex.calculateRects,
		     debug.traceback,
		     {axis=2,
		      children={
			 {size={1,"w"},
			  axis=1,
			  children={
			     {size={50,"dp"}}
			  }
			 },
			 {size={1,"w"}},
		     }},
		     {0,0,100,100})
   print(res)
   print(table.tostring(res))
end

function Flex.Update()
   Update=static.quit()
end

function Flex.End()
   
end

Util.try(isMain, F)
