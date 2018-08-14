require("util")
AI = Class()
--[[--
   creates a new AI

   @param algo Supposed to be algorithm to calculate distance/path or whatnot but like there's only one way we do that so kinda moot. Also should be reworked if we intend to have multiple algos

   @return an AI
]]
function AI.new (algo)
   self = {algo=algo}
   setmetatable(self, AI)
   return self
end

--[[--
   find all segments not on <nteam>

   @param nteam the team's number. Usually player's team is 1
]]
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

--[[--
   Prepare for each new AI controlled slug's turn
]]
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
   AI.slug:movementOverlay(AI.moves)
   AI.state = AI.delay
   AI.path = AI.pathTo(AI.tpos[1], AI.tpos[2])
   AI.pathi = #AI.path - 1
end

--[[
   Delay???
]]
function AI.delay()
   AI.state = AI.move
end

--[[--
   Return control to the usurped class, trigger's player turn
]]
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
   framedelay = AI.oldDelay
   static.framedelay(framedelay)
   AI.oldDelay = nil
   Player.prepareForTurn()
end

--[[
   score options by distance (for heap)

   @param x
   @param y
]]
local function scoreDist(x,y)
   return x[4] > y[4]
end

--[[--
   Calculates path between current enemy slug and position

   @param x 
   @param y 

   @return the path
]]
function AI.pathTo(x,y)
   local heap = require 'algorithms/heap'
   local H = AI.manhatten
   local closed = heap.valueheap{cmp = scoreDist} -- scoreDist determines whether heap is min or max
   local open = heap.valueheap{cmp = scoreDist}
   local swidth = map.width
   local sheight = map.height
   local visited = {}
   local tmp,cur,ind,owner,old,g
   local hpos = AI.slug.head.pos
   local goal = {x,y}
   local deltas = {{0,-1},{1,0},{0,1},{-1,0}}

   tmp = H(hpos, goal)
   open:push({hpos[1],hpos[2],0,tmp, tmp})
   --print("start", hpos[1], hpos[2])
   --print("goal", goal[1], goal[2])
   repeat
	  cur = open:pop()
	  closed:push(cur)
	  --print("seeing", cur[1], cur[2], ":", cur[3])
	  if cur[1] == goal[1] and cur[2] == goal[2] then
		 break -- found
	  end
	  
	  for i, d in ipairs(deltas) do
		 g = cur[3] + 1
		 tmp = {cur[1] + d[1], cur[2] + d[2], g}
		 if tmp[1] >= 0 and tmp[1] < swidth and tmp[2] >= 0 and tmp[2] < sheight then
			ind = map:indexOf(tmp[1], tmp[2])
			if visited[ind] then
			   owner = visited[ind][1]
			   old = visited[ind][2]
			else
			   owner = nil
			   old = nil
			end
			if map.map[ind] and (not map.objects[ind] or map.objects[ind].slug == AI.slug) and owner ~= closed then
			   if owner ~= open then
				  tmp[4] = H(tmp, goal)
				  tmp[5] = tmp[4] + tmp[3]
				  tmp[6] = cur
				  open:push(tmp)
				  visited[ind] = {open, tmp}
			   elseif old[4] + g < old[5] then
				  old[6] = cur-- test if using the current G score make the aSquare F score lower, if yes update the parent because it means its a better path
			   end
			end
		 end
	  end
	  cur = nil
   until #open == 0
   if cur == nil then
	  --path not found
	  cur = closed:pop()
   end
   local tmp = {}
   i = 1
   while cur do
	  --print(cur[1], cur[2], cur[3])
	  tmp[i] = {cur[1], cur[2]}
	  cur = cur[6]
	  i = i + 1
   end
   return tmp
end

--[[--
   Prepare for the enemy's turn, where it will control all slugs in it's team.
   Usurps Update function
]]
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
   AI.oldDelay = framedelay
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
   framedelay = 1000 // 3
   static.framedelay(framedelay)
end

--[[--
   Moves the current slug a single tile, consumes one movement
   sets the AI state to attack when no moves are left
]]
function AI.move()
   if AI.moves > 0 then
	  --[=[local dx = math.min(math.max(AI.tpos[1]-AI.pos[1], -1), 1)
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
		 end]=]
	  if AI.path[AI.pathi] then
		 AI.slug:move(AI.path[AI.pathi][1],AI.path[AI.pathi][2])
		 AI.pathi = AI.pathi - 1
		 AI.moves = AI.moves - 1
	  else
		 AI.moves = 0
	  end
   end
   AI.slug:destroyOverlay()
   AI.slug:movementOverlay(AI.moves)
   if AI.moves <= 0 then
	  AI.slug:destroyOverlay()
	  AI.slug:basicOverlay(AI.slug.action.range, Slug.attackOverlayFn)
	  AI.state = AI.attack
   end
end

--[[--
   Does the enemy slug's attack, continues onto next slug or returns control to player if no slugs left to move
]]
function AI.attack()
   local x, y = AI.tpos[1], AI.tpos[2]
   local ind = map:indexOf(x,y)
   local obj = map.objects[ind]
   local skill = Skills[AI.slug.action.skill]
   if skill.can(AI.slug, obj, ind, x, y)  then
	  skill.act(AI.slug, obj, ind, x, y)
   end
   AI.turni = AI.turni + 1
   if AI.turni >= AI.neslugs then
	  AI.returnControl()
   else
	  AI.prepareCurrentSlug()
   end
end

--[[--
   Continue the enemy slug's turn

   This update function does the enemy's turn part by part until there are no more parts and turns to take.

   A turn for an individual slug consists of targeting, moving, and attacking if posible.

   Once there are no more turns to process, control will revert to the usurped Update function
]]
function AI.Update()
   --Update = static.quit
   AI.state()
   if map then
	  map:update()
	  map:draw()
	  if AI.slug then
		 AI.slug:drawOverlay()
	  end
   end
end

--[[--
   Manhatten/taxicab distance between points a and b

   @param a 
   @param b 

   @return distance score
]]
function AI.manhatten(a, b)
   return math.abs(a[1] - b[1]) + math.abs(a[2] - b[2])
end

--[[--
   comparator for manhatten function.

   segments have a ._pos field temporarily, which provides the reference position they are to be compared with

   @param a Slug segment
   @param b Slug segment

   @return whether distance from A to reference pos is less than B
]]
function AI.mancomp (a, b)
   local c = AI.manhatten(a.pos, a._pos) < AI.manhatten(b.pos, a._pos)
   return c
end

--[[--
   Sort list of possible targets by distance

   @param all list of segments that might be possible targets
   @param pos reference position

   @return sorted list (same list)
]]
function AI.sortDist(all, pos)
   Segment._pos = pos
   Segment.__lt = AI.mancomp
   table.sort(all)
   Segment.__lt = nil
   Segment._pos = nil
   return all   
end
