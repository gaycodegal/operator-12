require("util")
Segment = {}

Segment.__index = metareplacer(Segment)

-- creates a new segment
-- data now owned by slug
function Segment.new (p, n, spr, pos, slug)
   self = {p=p,n=n,spr=spr,pos=pos, slug=slug}
   setmetatable(self, Segment)
   self:insert(p, n)
   return self
end

-- Remove Segment from Map
function Segment.removeFromMap(self)
   map.objects[map:indexOf(self.pos[1], self.pos[2])] = false
end

-- Add Segment to Map
function Segment.addToMap(self)
   map.objects[map:indexOf(self.pos[1], self.pos[2])] = self
end

-- Draw on Map
function Segment.draw(self)
   local x, y = Map.position(self.pos[1], self.pos[2])
   self.spr:draw(x, y)
end

-- Removes Segment from chain
function Segment.unlink(self)
   if self.p then
	  self.p.n = self.n
   end
   if self.n then
	  self.n.p = self.p
   end
   self.n = nil
   self.p = nil
end

-- link the next
function Segment.linkN(self, n)
   n.p = self
   self.n = n
end

-- link the prev
function Segment.linkP(self, p)
   p.n = self
   self.n = n
end

-- insert between p - n
function Segment.insert(self, p, n)
   if p then
	  p.n = self
   end
   if n then
	  n.p = self
   end
   self.p = p
   self.n = n
end
