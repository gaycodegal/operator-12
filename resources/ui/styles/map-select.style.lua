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
button = {e={},
resize=function(self)
local d = self.d
local p=self.p
local s=10
local col=4
local w=(p.w - s * (col + 1))//col
local h=(p.h - s * (col + 1))//col
self.h = h
self.w = w
self.x = (d[1] + 1)*s + d[1]*w
self.y = (d[2] + 1)*s + d[2]*h
end
},
}