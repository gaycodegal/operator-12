require "util"
local isMain = Util.isMain()
Heap = Class()
local H = Heap

--[[--
   make a new Heap
   
   @param cmp(x,y) comparator fn. if cmp(x,y) => x > y 
   then (begin (push x) (push y) (pop)) => x 
   

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

--[[--
moves an element toward the top of the heap as appropriate

@param i index to move

@return index the element ended up at
]]
function Heap:siftUp(i)
   local p = self.parent(i)
   local d,cmp = self.data,self.cmp
   local t
   while p >= 1 and not cmp(d[p], d[i]) do
	  t = d[p]
	  d[p] = d[i]
	  d[i] = t
	  d[p]._ind = p
	  d[i]._ind = i
	  i = p
	  p = self.parent(i)
   end
   return i
end

--[[--
moves an element toward the bottom of the heap as appropriate

@param p index to move

@return index the element ended up at
]]
function Heap:siftDown(p)
   local l = self.child(p)
   local r = l + 1
   local d,cmp = self.data,self.cmp
   local t
   local cl, cr
   while l <= self.size do
	  cl, cr = not cmp(d[p], d[l]), r <= self.size and not cmp(d[p], d[r])
	  if (cl and not cr) or (cl and cr and cmp(d[l], d[r])) then
		 t = d[p]
		 d[p] = d[l]
		 d[l] = t
		 d[p]._ind = p
		 d[l]._ind = l
		 p = l
	  elseif cr then
		 t = d[p]
		 d[p] = d[r]
		 d[r] = t
		 d[p]._ind = p
		 d[r]._ind = r
		 p = r
	  else
		 break
	  end
	  l = self.child(p)
	  r = l + 1
   end
   return p
end

--[[--
add a thing to the heap. must be a table

@param x table to add
]]
function Heap:push(x)
   self.size = self.size + 1
   self.data[self.size] = x
   x._ind = self.size
   self:siftUp(self.size)
end

--[[--
remove the top thing from the heap

@return said thing
]]
function Heap:pop()
   local x = self.data[1]
   self.data[1] = self.data[self.size]
   self.data[1]._ind = 1
   self.size = self.size - 1
   self:siftDown(1)
   return x
end

--[[--
move something at index i up or down in heap as required

@param i index to rescore
]]
function Heap:rescore(i)
   if i > self.size or i < 1 then
	  return
   end
   if self:siftUp(i) == i then
	  self:siftDown(i)
   end
end

--[[--
   default comparator
]]
Heap.cmp = function(x,y)
   return x < y
end

if isMain then
   heap = Heap.new(function (x, y) return x[1] < y[1] end)

   for i = 100,1,-1 do
	  heap:push({i})
   end
   
   for i = 1,100 do
	  print(heap:pop()[1])
   end
end
