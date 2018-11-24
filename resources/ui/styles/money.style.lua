return {
money = {e={["bg"]={255,0,0,255},["justify"]=3},
resize=function(self)
local d = self.d
local p=self.p
local w=200
self.h = 30
self.w = w
self.x = p.x + p.w - w
self.y = p.y
end
},
}