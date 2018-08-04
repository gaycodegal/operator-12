require("slug/Skills")
Player = {}

---Player.__index = metareplacer(Player)

function Player.prepareCurrentSlug()
   local slug = Player.slugs[Player.turni]
   local head = slug.head
   Player.slug = slug
   Player.pos = head.pos
   Player.moves = slug.stats.moves
   active = Player.move
   Player.slug:movementOverlay(Player.moves)
end

function Player.lose()
   End()
   dofile("load.lua")
   Start()
   print("lose")
end

function Player.win()
   End()
   dofile("load.lua")
   Start()
   print("win")
end

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

function Player.move(x, y)
   if Player.moves > 0 then
	  if Player.slug:move(x,y) then
		 Player.moves = Player.moves - 1
	  end
   end
   Player.slug:destroyOverlay()
   Player.slug:movementOverlay(Player.moves)
   if Player.moves <= 0 then
	  Player.slug:destroyOverlay()
	  Player.slug:attackOverlay(Player.slug.stats.range)
	  active = Player.attack
   end
end

function Player.attack(x,y)
   local ind = map:indexOf(x,y)
   local obj = map.objects[ind]
   if Skills.Damage.can(Player.slug, obj, ind, x, y)  then
	  Skills.Damage.act(Player.slug, obj, ind, x, y)
   end
   Player.turni = Player.turni + 1
   if Player.turni > Player.nslugs then
	  Player.returnControl()
	  AI.prepareForEnemyTurns()
   else
	  Player.prepareCurrentSlug()
   end
end
