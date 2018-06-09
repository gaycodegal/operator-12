require("util")
Segment = {}

Segment.__index = metareplacer(Segment)

-- creates a new segment
-- pos now owned by segment
function Segment.new (p, n, spr, pos, slug, c)
   self = {p=p,n=n,spr=spr,pos=pos, slug=slug, c=c}
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

-- Unsets self and surrounding c vals
function Segment.unsetMapConnections(self)
   local deltas = {{0,-1},{1,0},{0,1},{-1,0}}
   local tmp
   local swidth = map.width
   local sheight = map.height
   local ind
   local cur = self.pos
   for c, d in ipairs(deltas) do
	  tmp = {cur[1] + d[1], cur[2] + d[2]}
	  self.c[c] = 0
	  if tmp[1] >= 0 and tmp[1] < swidth and tmp[2] >= 0 and tmp[2] < sheight then
		 ind = map:indexOf(tmp[1], tmp[2])
		 if map.objects[ind] and map.objects[ind].slug == self.slug then
			map.objects[ind].c[((c + 1) & 3) + 1] = 0
		 end
	  end
   end
end

-- sets self and surrounding c vals
function Segment.setMapConnections(self) 
   local deltas = {{0,-1},{1,0},{0,1},{-1,0}}
   local tmp
   local swidth = map.width
   local sheight = map.height
   local ind
   local cur = self.pos
   for c, d in ipairs(deltas) do
	  tmp = {cur[1] + d[1], cur[2] + d[2]}
	  if tmp[1] >= 0 and tmp[1] < swidth and tmp[2] >= 0 and tmp[2] < sheight then
		 ind = map:indexOf(tmp[1], tmp[2])
		 if map.objects[ind] and map.objects[ind].slug == self.slug then
			self.c[c] = 1
			--print(c, ((c + 1) & 3) + 1)
			map.objects[ind].c[((c + 1) & 3) + 1] = 1
		 end
	  else
		 self.c[c] = 0
	  end
   end
end

-- Draw on Map
function Segment.draw(self)
   local x, y = Map.position(self.pos[1], self.pos[2])
   local s = self.spr
   local c = self.c
   local sep2 = (map.tilesep // 2)
   local w = tilew + sep2 * (c[2] + c[4])
   local h = tileh + sep2 * (c[1] + c[3])
   local dx = sep2 * c[4]
   local dy = sep2 * c[1]
   --print(c[1], c[2], c[3], c[4])
   Texture.renderCopy(s.tex, s.x-dx, s.y-dy, w, h, x-dx, y-dy, w, h)
   --   s:draw(x, y)
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

function Segment.cOf(self, o)
   if self.pos[2] > o.pos[2] then
	  return 1
   elseif self.pos[1] < o.pos[1] then
	  return 2
   elseif self.pos[2] < o.pos[2] then
	  return 3
   else
	  return 4
   end
end

-- insert between p - n
function Segment.insert(self, p, n)
   local c
   if p then
	  p.n = self
   end
   if n then
	  n.p = self
   end
   self.p = p
   self.n = n
end

function Segment.print(self)
   print(self.slug.name, self.pos[1], self.pos[2])
end
