require("util")
Player = {}

---Player.__index = metareplacer(Player)

function Player.prepareCurrentSlug()
   local slug = Player.slugs[Player.turni]
   local head = slug.head
   Player.slug = slug
   Player.pos = head.pos
   Player.moves = slug.stats.moves
   active = Player.move
end

function Player.returnControl()
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
	  print("you lose...")
	  Player.returnControl()
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
   if Player.moves <= 0 then
	  active = Player.attack
   end
end

function Player.attack(x,y)
   local dx = x-Player.pos[1]
   local dy = y-Player.pos[2]
   if math.abs(dx) + math.abs(dy) <= Player.slug.stats.range then
	  local ind = map:indexOf(x,y)
	  if map.objects[ind] and map.objects[ind].slug.team ~= 1 then
		 map.objects[ind].slug:damage(Player.slug.stats.damage)
	  end
   end
   Player.turni = Player.turni + 1
   if Player.turni > Player.nslugs then
	  Player.returnControl()
	  AI.prepareForEnemyTurns()
   else
	  Player.prepareCurrentSlug()
   end
end
