return {
screen = {e={},
resize=function(self)
local d = self.d
self.h = SCREEN_HEIGHT
self.w = SCREEN_WIDTH
self.x = 0
self.y = 0
end
},
log = {e={["direction"]=2,["fg"]={255,255,255,255},["bg"]={0,0,0,255}},
resize=function(self)
local d = self.d
local p=self.p
local ch=30
self.h = p.h - ch
self.w = p.w
self.x = 0
self.y = 0
end
},
input = {e={["direction"]=2,["fg"]={0,0,0,255},["bg"]={255,255,255,255}},
resize=function(self)
local d = self.d
local p=self.p
local h=30
self.h = h
self.w = p.w
self.x = 0
self.y = p.h - h
end
},
}