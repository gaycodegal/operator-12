require("util")
AI = {}

AI.__index = metareplacer(AI)

-- creates a new AI
function AI.new (algo)
   self = {algo=algo}
   setmetatable(self, AI)
   return self
end

-- find all segments not on <nteam>
function AI.findAll(nteam)
   local all = {}
   j = 1
   for i, o in ipairs(map.objects) do
	  if o and o.slug and o.slug.team ~= nteam then
		 all[j] = o
		 j = j + 1
	  end
   end
   return all
end

function AI.manhatten(a, b)
   return math.abs(a[1] - b[1]) + math.abs(a[2] - b[2])
end

function AI.mancomp (a, b)
   local c = AI.manhatten(a.pos, a._pos) < AI.manhatten(b.pos, a._pos)
   return c
end

function AI.sortDist(all, pos)
   Segment._pos = pos
   Segment.__lt = AI.mancomp
   table.sort(all)
   Segment.__lt = nil
   Segment._pos = nil
   return all
end
