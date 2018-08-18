require("slug/Skills")
require("battle/ui")
Player = {}

--[[--
   Prepares current slug to be controlled
]]
function Player.prepareCurrentSlug()
   local slug = Player.slugs[Player.turni]
   local head = slug.head
   Player.slug = slug
   Player.pos = head.pos
   Player.moves = slug.stats.moves
   active = Player.move
   Player.slug:movementOverlay(Player.moves)
   BattleUI.setSlug(slug)
end

--[[--
   Sets the slug into attack mode
]]
function Player.beginAttack()
   Player.slug:destroyOverlay()
   Player.slug:basicOverlay(Player.slug.action.range, Slug.attackOverlayFn)
   active = Player.attack   
end

--[[--
   Trigger player losing the battle
]]
function Player.lose()
   End()
   Util.setController(MapSelect)
   Start()
end

--[[--
   Trigger player battle win
]]
function Player.win()
   End()
   Util.setController(MapSelect)
   Start()
end

--[[--
   wipe variables
]]
function Player.returnControl()
   if Player.slug then
	  Player.slug:destroyOverlay()
   end
   Player.slug = nil
   Player.pos = nil
   Player.moves = nil
   Player.slugs = nil
   Player.turni = nil
   Player.nslugs = nil
   active = nil
end

--[[--
   prepare for player turn
]]
function Player.prepareForTurn()
   Player.slugs = {} -- active slugs
   Player.turni = 1 -- which slug's turn is it
   j = 1
   for i, slug in pairs(slugs) do
	  if slug then
		 if slug.team == 1 then
			Player.slugs[j] = slug
			j = j + 1
		 end
	  end
   end
   Player.nslugs = j-1 -- number of enemies to go.
   if Player.nslugs <= 0 then
	  Player.returnControl()
	  Player.lose()
	  return
   end
   Player.prepareCurrentSlug()   
end

--[[--
   Player move a slug by one tile

   @param x 
   @param y 
]]
function Player.move(x, y)
   if Player.moves > 0 then
	  if Player.slug:move(x,y) then
		 Player.moves = Player.moves - 1
	  end
   end
   Player.slug:destroyOverlay()
   Player.slug:movementOverlay(Player.moves)
   if Player.moves <= 0 then
	  Player.beginAttack()
   end
end

--[[--
   Player attempt attack

   if the player chooses an invalid square it will 

   @param x 
   @param y 
]]
function Player.attack(x,y)
   local ind = map:indexOf(x,y)
   local obj = map.objects[ind]
   local skill = Skills[Player.slug.action.skill]
   if skill.can(Player.slug, obj, ind, x, y)  then
	  skill.act(Player.slug, obj, ind, x, y)
   end
   Player.nextTurn()
end

function Player.nextTurn()
   Player.turni = Player.turni + 1
   if Player.turni > Player.nslugs then
	  Player.returnControl()
	  AI.prepareForEnemyTurns()
   else
	  Player.prepareCurrentSlug()
   end
end
