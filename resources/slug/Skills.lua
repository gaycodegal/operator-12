Skills = {
   Damage = {},
   Flip = {},
   Spawn = {},
   Heal = {}
}
local Damage = Skills.Damage
local Flip = Skills.Flip
local Spawn = Skills.Spawn
local Heal = Skills.Heal

--[[
   can initiator damage object

   @param initiator Slug doing the action
   @param object Map object at coordinates
   @param ind Map index
   @param x Coord x
   @param y Coord y
   @return whether action can run
]]
function Damage.can(initiator, object, _, _, _)
   if not object then
	  return false
   end
   local dx = object.pos[1]-initiator.head.pos[1]
   local dy = object.pos[2]-initiator.head.pos[2]
   if math.abs(dx) + math.abs(dy) <= initiator.action.range then
	  return object.slug.team ~= initiator.team
   end
   return false
end

--[[
   make initiator damage object

   @param initiator Slug doing the action
   @param object Map object at coordinates
   @param ind Map index
   @param x Coord x
   @param y Coord y
   @return whether action can run
]]
function Damage.act(initiator, object, _, _, _)
   object.slug:damage(initiator.action.damage)
end

--[[
   can initiator heal object

   @param initiator Slug doing the action
   @param object Map object at coordinates
   @param ind Map index
   @param x Coord x
   @param y Coord y
   @return whether action can run
]]
function Heal.can(initiator, object, _, _, _)
   if not object then
	  return false
   end
   local dx = object.pos[1]-initiator.head.pos[1]
   local dy = object.pos[2]-initiator.head.pos[2]
   if math.abs(dx) + math.abs(dy) <= initiator.action.range then
	  return object.slug.team == initiator.team
   end
   return false
end

--[[
   make initiator heal object

   @param initiator Slug doing the action
   @param object Map object at coordinates
   @param ind Map index
   @param x Coord x
   @param y Coord y
   @return whether action can run
]]
function Heal.act(initiator, object, _, _, _)
   --object.slug:damage(initiator.action.damage)
   local toHeal = initiator.action.heal
   local hasFrees = true
   local slug = object.slug
   local frees, cur
   while toHeal > 0 and hasFrees do
	  frees = {}
	  cur = slug.head
	  while cur do
		 Heal.addAllFreeNear(cur, frees)
		 cur = cur.n
	  end
	  for i, pos in ipairs(frees) do
		 if not map.objects[pos[3]] then
			slug.size = slug.size + 1
			toHeal = toHeal - 1
			cur = Segment.new(slug.tail, nil, slug.sprites[2], {pos[1],pos[2]}, slug, {0,0,0,0})
			slug.tail = cur
			cur:addToMap()
			cur:setMapConnections()
			if toHeal <= 0 then
			   break
			end
		 end
	  end
	  hasFrees = #frees > 0
   end
end

--[[
   add all the free spots near an object we could place newly spawned segements in

   @param object slug segment
   @param(out) frees list to insert free spaces into
]]
function Heal.addAllFreeNear(object, frees)
   local deltas = {{0,-1},{1,0},{0,1},{-1,0}}
   local pos = object.pos
   local x, y, ind
   for i,d in ipairs(deltas) do
	  x, y = pos[1] + d[1], pos[2] + d[2]
	  ind = map:indexOf(x, y)
	  if map:valid(x, y) and map.map[ind] and not map.objects[ind] then
		 table.insert(frees, {x,y,ind})
	  end
   end
end

--[[
   can slug flip a tile (bring it into existence or destroy it)

   @param initiator Slug doing the action
   @param object Map object at coordinates
   @param ind Map index
   @param x Coord x
   @param y Coord y
   @return whether action can run
]]
function Flip.can(initiator, object, ind, x, y)
   local dx = x-initiator.head.pos[1]
   local dy = y-initiator.head.pos[2]
   if math.abs(dx) + math.abs(dy) <= initiator.action.range then
	  return not object and map:valid(x,y)
   end
   return false
end

--[[
   flip a tile

   @param initiator Slug doing the action
   @param object Map object at coordinates
   @param ind Map index
   @param x Coord x
   @param y Coord y
   @return whether action can run
]]
function Flip.act(initiator, object, ind, x, y)
   if map.map[ind] then
	  map:destroyTile(ind)
   else
	  map:makeTile(ind, 1)
   end
end

--[[
   can spawn? not yet done

   @param initiator Slug doing the action
   @param object Map object at coordinates
   @param ind Map index
   @param x Coord x
   @param y Coord y
   @return whether action can run
]]
function Spawn.can(initiator, object, ind, x, y)
   return false
end

--[[
   do spawn (not yet done)

   @param initiator Slug doing the action
   @param object Map object at coordinates
   @param ind Map index
   @param x Coord x
   @param y Coord y
   @return whether action can run
]]
function Spawn.act(initiator, object, ind, x, y)
   return false
end
