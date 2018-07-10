return {
box = {e={["direction"]=2},
resize=function(self)
local d = self.d
local p=self.p
local s=10
local w=p.w - s * 2
local h=250
self.h = h
self.w = w
self.x = s
self.y = p.h - h - s
end
},
screen = {e={},
resize=function(self)
local d = self.d
self.h = SCREEN_HEIGHT
self.w = SCREEN_WIDTH
self.x = 0
self.y = 0
end
},
}