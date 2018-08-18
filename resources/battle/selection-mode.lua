require("util")
require("ai/ai")
SlugSelect = {}
local S = SlugSelect

--[[--
callback gen, set active choice to slug.

should probably update textbox text

@param i index into choice
@param slugs slugs

@return callback
]]
function SlugSelect.fn(i, slugs)
   return function()
	  S.choice = slugs[i]
   end
end

--[[--
Set up buttons so one can choose which slug to place.

Should include pagination.
]]
function SlugSelect.setUI()
   local slugs = S.inv.slugs
   local fns = {}
   local texts = {}
   for i = 1,#slugs do
	  table.insert(fns, S.fn(i, slugs))
	  table.insert(texts, slugs[i].type)
   end
   table.insert(texts,"done")
   table.insert(fns, S.Finish)
   BattleUI.t:setText("Click a slug type, then click a spawn-spot to set the slug!")
   BattleUI.actions:setButtons(fns,texts)
   BattleUI.t:resize()
end

--[[--
Sets self as controller, takes some functions from Battle
Loads possible slug choices for use

@param inv Player's inventory
]]
function SlugSelect.Begin(inv)
   for i,v in pairs({"Resize", "Start", "End"}) do
	  S[v] = Battle[v]
   end

   Util.setController(S)
   S.inv = inv
   S.mates = AI.findSpawners()
   
   S.imates = {}
   S.choices = {}
   
   for i,m in ipairs(S.mates) do
	  S.imates[map:indexOf(m.pos[1], m.pos[2])] = true
   end

   S.setUI()
end

--[[--
cleans up memory, hands control back to Battle
]]
function SlugSelect.Finish()
   local spawners = slugs["spawner"]
   if spawners then
	  spawners:damage(spawners.size)
   end
   for i,c in ipairs(S.choices) do
	  local name = "spawned-"..i
	  slugs[name] = Slug.new({sprites = c[3].type, segs = {{c[1],c[2]}}, name=name, team=1, spawner = false})
   end
   S.inv = nil
   S.choice = nil
   S.choices = nil
   S.mates = nil
   S.imates = nil
   Util.setController(Battle)
   Player.prepareForTurn()
end

--[[--
   draw shit, update map
]]
function SlugSelect.Update()
   --Update = static.quit
   map:update()
   map:draw()
   for i,v in ipairs(S.choices) do
	  local x,y,s = v[1],v[2],v[3].type
	  local t = Slug.defs[s].tiles[1]
	  x, y = Map.basePosition(x, y)
	  Texture.renderCopy(t.tex,
						 t.x,t.y,t.w,t.h,
						 x + map.x,
						 y + map.y,
						 map.tilesize,
						 map.tilesize)
   end
   BattleUI.draw()
end

--[[--
either click buttons, or try and place a slug

@param x 
@param y 
]]
function SlugSelect.MouseDown(x,y)
   if BattleUI.MouseDown(x,y) then
	  return
   end
   local px, py = Map.positionToCoords(x,y)	  
   if map:valid(px, py) then
	  local ind = map:indexOf(px, py)
	  if S.imates[ind] and S.choice then
		 local choice = {px, py, S.choice}
		 if S.imates[ind] ~= true then
			S.choices[S.imates[ind]] = choice
		 else
			local cind = #S.choices + 1
			table.insert(S.choices, cind, choice)
			S.imates[ind] = cind
		 end
	  end
   end
end

--[[--
   pan camera about map or quit

@param key 
]]
function SlugSelect.KeyDown(key)
   if key == KEY_ESCAPE then
	  static.quit()
   elseif key == KEY_UP then
	  map.dy = -map.speed
   elseif key == KEY_DOWN then
	  map.dy = map.speed
   elseif key == KEY_LEFT then
	  map.dx = -map.speed
   elseif key == KEY_RIGHT then
	  map.dx = map.speed
   end
end

--[[--
Stop panning or quit

@param key 
]]
function SlugSelect.KeyUp(key)
   if key == KEY_ESCAPE then
	  static.quit()
   elseif key == KEY_UP and map.dy < 0 then
	  map.dy = 0
   elseif key == KEY_DOWN and map.dy > 0 then
	  map.dy = 0
   elseif key == KEY_LEFT and map.dx < 0 then
	  map.dx = 0
   elseif key == KEY_RIGHT and map.dx > 0 then
	  map.dx = 0
   end
end
