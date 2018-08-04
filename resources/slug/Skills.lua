Skills = {
   Damage = {}
   
}
local Damage = Skills.Damage

--[[
   @param initiator Slug doing the action
   @param object Map object at coordinates
   @param ind Map index
   @param x Coord x
   @param y Coord y
   @return whether action can run
]]
function Damage.can(initiator, object, ind, x, y)
   local dx = x-initiator.head.pos[1]
   local dy = y-initiator.head.pos[2]
   if math.abs(dx) + math.abs(dy) <= initiator.stats.range then
	  return object and object.slug.team ~= initiator.team
   end
   return false
end

function Damage.act(initiator, object, ind, x, y)
   object.slug:damage(initiator.stats.damage)
end
