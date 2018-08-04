Skills = {
   Damage = {},
   Flip = {},
   Spawn = {}
}
local Damage = Skills.Damage
local Flip = Skills.Flip
local Spawn = Skills.Spawn

--[[
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
