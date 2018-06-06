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

function AI.prepareCurrentSlug()
   local slug = AI.slugs[AI.turni]
   local head = slug.head
   local all = AI.findAll(slug.team)
   if #all <= 0 then
	  AI.returnControl()
	  Player.lose()
	  return
   end
   AI.slug = slug
   AI.pos = head.pos
   AI.target = AI.sortDist(all, head.pos)[1]
   AI.tpos = AI.target.pos
   AI.moves = slug.stats.moves
   AI.state = AI.move
   AI.slug:movementOverlay(AI.moves)
end

function AI.returnControl()
   if AI.slug then
	  AI.slug:destroyOverlay()
   end
   AI.slug = nil
   AI.pos = nil
   AI.target = nil
   AI.tpos = nil
   AI.moves = nil
   AI.state = nil
   AI.slugs = nil
   AI.turni = nil
   AI.neslugs = nil
   Update = AI.oldUpdate
   AI.oldUpdate = nil
   active = AI.oldActive
   AI.oldActive = nil
   Player.prepareForTurn()
end

function AI.prepareForEnemyTurns()
   --Update=static.quit
   AI.slugs = {} -- active enemy slugs
   AI.turni = 1 -- which slug's turn is it
   j = 1
   for i, slug in pairs(slugs) do
	  if slug then
		 if slug.team ~= 1 then
			AI.slugs[j] = slug
			j = j + 1
		 end
	  end
   end
   AI.neslugs = j -- number of enemies to go.
   AI.oldUpdate = Update
   Update = AI.Update
   AI.oldActive = active
   active = nil
   if AI.neslugs <= 1 then
	  AI.returnControl()
	  Player.win()
	  return
   end
   AI.prepareCurrentSlug()
end

function AI.move()
   if AI.moves > 0 then
	  local dx = math.min(math.max(AI.tpos[1]-AI.pos[1], -1), 1)
	  local dy = math.min(math.max(AI.tpos[2]-AI.pos[2], -1), 1)
	  local indx = map:indexOf(AI.pos[1] + dx,AI.pos[2])
	  local indy = map:indexOf(AI.pos[1],AI.pos[2] + dy)
	  if dx ~= 0 and dx + AI.pos[1] > 0 and dx + AI.pos[1] < map.width and map.map[indx] and ((not map.objects[indx]) or map.objects[indx].slug == AI.slug) then
		 AI.slug:move(AI.pos[1] + dx,AI.pos[2])
		 AI.moves = AI.moves - 1
	  elseif dy ~= 0 and dy + AI.pos[2] > 0 and dy + AI.pos[2] < map.height and map.map[indy] and ((not map.objects[indy]) or map.objects[indy].slug == AI.slug) then
		 AI.slug:move(AI.pos[1],AI.pos[2] + dy)
		 AI.moves = AI.moves - 1
	  else
		 AI.moves = 0
	  end	 
   end
   AI.slug:destroyOverlay()
   AI.slug:movementOverlay(AI.moves)
   if AI.moves <= 0 then
	  AI.state = AI.attack
   end
end

function AI.attack()
   local dx = AI.tpos[1]-AI.pos[1]
   local dy = AI.tpos[2]-AI.pos[2]
   if math.abs(dx) + math.abs(dy) <= AI.slug.stats.range then
	  AI.target.slug:damage(AI.slug.stats.damage)
   end
   AI.turni = AI.turni + 1
   if AI.turni >= AI.neslugs then
	  AI.returnControl()
   else
	  AI.prepareCurrentSlug()
   end
end

function AI.Update()
   --Update = static.quit
   AI.state()
   if map then
	  map:update()
	  map:draw()
	  if AI.slug then
		 AI.slug:drawOverlay()
	  end
	  static.wait(1000/2)
   end
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
