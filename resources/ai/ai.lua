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
   local slug = AI.eslugs[AI.eturni]
   local head = slug.head
   local all = AI.findAll(slug.team)
   if #all <= 0 then
	  print("you lose...")
	  AI.returnControl()
	  return
   end
   AI.eslug = slug
   AI.epos = head.pos
   AI.etarget = AI.sortDist(all, head.pos)[1]
   AI.etpos = AI.etarget.pos
   AI.emoves = slug.stats.moves
   AI.estate = AI.move
end

function AI.returnControl()
   AI.eslug = nil
   AI.epos = nil
   AI.etarget = nil
   AI.etpos = nil
   AI.emoves = nil
   AI.estate = nil
   AI.eslugs = nil
   AI.eturni = nil
   AI.neslugs = nil
   Update = AI.oldUpdate
   AI.oldUpdate = nil
   active = AI.oldActive
   AI.oldActive = nil
end

function AI.prepareForEnemyTurns()
   AI.eslugs = {} -- active enemy slugs
   AI.eturni = 1 -- which slug's turn is it
   j = 1
   for i, slug in pairs(slugs) do
	  if slug then
		 if slug.team ~= 1 then
			AI.eslugs[j] = slug
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
	  print("you won...")
	  AI.returnControl()
	  return
   end
   AI.prepareCurrentSlug()   
end

function AI.move()
   if AI.emoves > 0 then
	  local dx = math.min(math.max(AI.etpos[1]-AI.epos[1], -1), 1)
	  local dy = math.min(math.max(AI.etpos[2]-AI.epos[2], -1), 1)
	  local indx = map:indexOf(AI.epos[1] + dx,AI.epos[2])
	  local indy = map:indexOf(AI.epos[1],AI.epos[2] + dy)
	  if dx ~= 0 and map.map[indx] and ((not map.objects[indx]) or map.objects[indx].slug == AI.eslug) then
		 AI.eslug:move(AI.epos[1] + dx,AI.epos[2])
		 AI.emoves = AI.emoves - 1
	  elseif dy ~= 0 and map.map[indy] and ((not map.objects[indy]) or map.objects[indy].slug == AI.eslug) then
		 AI.eslug:move(AI.epos[1],AI.epos[2] + dy)
		 AI.emoves = AI.emoves - 1
	  else
		 AI.emoves = 0
	  end	 
   end
   if AI.emoves <= 0 then
	  AI.estate = AI.attack
   end
end

function AI.attack()
   local dx = AI.etpos[1]-AI.epos[1]
   local dy = AI.etpos[2]-AI.epos[2]
   if math.abs(dx) + math.abs(dy) <= AI.eslug.stats.range then
	  AI.etarget.slug:damage(AI.eslug.stats.damage)
   end
   AI.eturni = AI.eturni + 1
   if AI.eturni >= AI.neslugs then
	  AI.returnControl()	  
   else
	  AI.prepareCurrentSlug()
   end
end

function AI.Update()
   --Update = static.quit
   AI.estate()
   map:update()
   map:draw()
   static.wait(1000/10)
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
