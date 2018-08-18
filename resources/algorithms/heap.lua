require "util"
Heap = Class()
local H = Heap

--[[--
   make a new Heap
   
   @param cmp comparator fn

   @return new boi
]]
function Heap.new(cmp)
   self = {}
   self.size = 0
   self.data = {}
   self.cmp = cmp or Heap.cmp
   setmetatable(self, H)
   return self
end

--[[--
   Get parent index

   @param i current index

   @return parent index
]]
function Heap.parent(i)
   return (i-2) // 2 + 1
end

--[[--
   Get left child index

   Right = left + 1
   
   @param i Current index

   @return left child index
]]
function Heap.child(i)
   return (i-1) * 2 + 2
end

function Heap:siftUp(i)
   local p = self.parent(i)
   local d,cmp = self.data,self.cmp
   local t
   while p >= 1 and not cmp(d[p], d[i]) do
	  t = d[p]
	  d[p] = d[i]
	  d[i] = t
	  i = p
	  p = self.parent(i)
   end
   return i
end

function Heap:siftDown(p)
   local l = self.child(p)
   local r = l + 1
   local d,cmp = self.data,self.cmp
   local t
   local cl, cr = cmp(d[p], d[l]), cmp(d[p], d[r])
   while l <= self.size and not cl or not cr do
	  if (cl and not cr) or (cl and cr and cmp(d[l], d[r])) then
		 t = d[p]
		 d[p] = d[l]
		 d[l] = t
		 p = l
	  else
		 t = d[p]
		 d[p] = d[r]
		 d[r] = t
		 p = r
	  end
	  l = self.child(p)
	  r = l + 1
	  cl, cr = cmp(d[p], d[l]), cmp(d[p], d[r])
   end
   return p
end

function Heap:push(x)
   self.size = self.size + 1
   self.data[self.size] = x
   self:siftUp(self.size)
end

function Heap:pop()
   local x = self.data[1]
   self.data[1] = self.data[self.size]
   self.size = self.size - 1
   self:siftDown(1)
   return x
end

Heap.cmp = function(x,y)
   return x < y
end

heap = Heap.new()

for i = 1,100 do
   heap:push(i)
end

for i = 1,100 do
   print(heap:pop())
end
