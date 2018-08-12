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
lbContainer = {e={},
resize=function(self)
local d = self.d
local p=self.p
self.h = p.h
self.w = p.w
self.x = p.x
self.y = p.y
end
},
lbChild = {e={},
resize=function(self)
local d = self.d
local p=self.p
local h=d.h
local th=(d.n * h + (d.n - 1) * d.s)
local a=d.align
local y=p.y + ((a==3 and 0) or th)
self.h = p.h-th
self.w = p.w
self.x = p.x
self.y = y
end
},
}