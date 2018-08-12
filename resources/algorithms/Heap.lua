-- via https://github.com/Roblox/Wiki-Lua-Libraries
-- No copyright license provided
-- Heap contains the following functions:
--		.new(comparator) - Creates a new Heap
--			comparator: Uses this function to compare values. If none is given, will assume values are numbers and will find smallest value
--						Comparator should accept two values and return true if a should be further up the heap than b and false otherwise
--		:Heapify(oldTable, comparator) - Converts a table to a Heap - Will destroy the provided table
--			comparator: The comparator to pass to Heap.new(comparator)
--		:Meld(heap1, heap2) - Creates a new Heap using the two provided Heaps
-- A Heap object has the following functions:
--		:insert(newValue) - Adds an element to the Heap
--		:pop() - Removes the first element in the Heap and returns it
--		:peek() - Returns the first element in the Heap but does not remove it
--		:toTable() - Returns a table of the elements in the Heap
--		:clear() - Removes all values from the Heap
--		:print() - prints out all the values in the Heap
--		:size() - Returns the size of the Heap
--		:clone() - Creates and returns a new copy of the Heap

Heap = {}
Heap.__index = Heap

local function DefaultCompare(a, b)
	if a > b then
		return true
	else
		return false
	end
end

local function SiftUp(heap, index)
	local parentIndex
	if index ~= 1 then
		parentIndex = index//2
		if heap.Compare(heap[parentIndex], heap[index]) then
			heap[parentIndex], heap[index] = heap[index], heap[parentIndex]
			SiftUp(heap, parentIndex)
		end
	end
end

local function SiftDown(heap, index)
	local leftChildIndex, rightChildIndex, minIndex
	leftChildIndex = index * 2
	rightChildIndex = index * 2 + 1
	if rightChildIndex > #heap then
		if leftChildIndex > #heap then
			return
		else
			minIndex = leftChildIndex
		end
	else
		if not heap.Compare(heap[leftChildIndex], heap[rightChildIndex]) then
			minIndex = leftChildIndex
		else
			minIndex = rightChildIndex
		end
	end
	
	if heap.Compare(heap[index], heap[minIndex]) then
		heap[minIndex], heap[index] = heap[index], heap[minIndex]
		SiftDown(heap, minIndex)
	end
end

--[[
desc.

@param comparator 

@return
]]
function Heap.new(comparator)
	local newHeap = { }
	setmetatable(newHeap, Heap)
	if comparator then
		newHeap.Compare = comparator
	else
		newHeap.Compare = DefaultCompare
	end
	
	return newHeap
end

--[[
desc.

@param newValue 

@return
]]
function Heap:insert(newValue)
	table.insert(self, newValue)
	
	if #self <= 1 then
		return
	end
	
	SiftUp(self, #self)
end

--[[
desc.

@return
]]
function Heap:pop()
	if #self > 0 then
		local toReturn = self[1]
		self[1] = self[#self]
		table.remove(self, #self)
		if #self > 0 then
			SiftDown(self, 1)
		end
		return toReturn
	else
		return nil
	end
end

--[[
desc.

@return
]]
function Heap:peek()
	if #self > 0 then
		return self[1]
	else
		return nil
	end
end

--[[
desc.

@return
]]
function Heap:toTable()
	local newTable = { }
	for i = 1, #self do
		table.insert(newTable, self[i])
	end
	return newTable
end

--[[
desc.

@return
]]
function Heap:clear()
	for k in pairs(self) do
		self[k] = nil
	end
end

--[[
desc.

@return
]]
function Heap:print()
	local out = ""
	for i = 1, #self do
		out = out .. tostring(self[i]) .. " "
	end
	print(out)
end

--[[
desc.

@return
]]
function Heap:size()
	return #self
end

--[[
desc.

@return
]]
function Heap:clone()
	local newHeap = Heap.new(self.Compare)
	for i = 1, #self do
		table.insert(newHeap, self[i])
	end
	return newHeap
end

-- Functions that are not self-referential
function Heap:Heapify(oldTable, comparator)
	local newHeap = Heap.new(comparator)
	for i = #oldTable, 1, -1 do
		newHeap:insert(oldTable[i])
		table.remove(oldTable, i)
	end
	return newHeap
end

--[[
desc.

@param heap1 
@param heap2 
@param comparator 

@return
]]
function Heap:Meld(heap1, heap2, comparator)
	if not comparator then
		comparator = heap1.Compare or heap2.Compare
	end
	local newHeap = Heap.new(comparator)
	for i = #heap1, 1, -1 do
		newHeap:insert(heap1[i])
	end
	for i = #heap2, 1, -1 do
		newHeap:insert(heap2[i])
	end
	return newHeap
end

return Heap
