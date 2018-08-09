return {
listButton = {e={},
resize=function(self)
local d = self.d
local p=self.p
local h=d.h
local th=(d.n * h + (d.n - 1) * d.s)
local a=d.align
local y=p.y + d.i*(h + d.s) + ((a==1 and 0) or (p.h - th)//((a==2 and 2) or 1))
self.h = h
self.w = p.w
self.x = p.x
self.y = y
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