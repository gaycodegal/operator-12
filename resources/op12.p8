pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- operator 12
-- sarah maven @zythlander
-- mit license @ github.com/gaycodegal/operator-12

--[[
   level completion are in bits 0, 63. to cheat you can do
   beatup(0) through beatup(63). To undo, you can do
   beatup(0, 0) through beatup(63, 0)
]]


nbattles = 3

--[[--
   indexing checks metatable first
   and falls back to object if that fails

   @param mt metatable
]]
function class(mt)
   mt.__index = function(t, f)
      v = rawget(t, f)
      if v ~= nil then
	 return v
      end
      return rawget(mt, f)
   end
   return mt
end

function map(t, f)
   local y
   y = {}
   for i = 1,#t do
      y[i] = f(t[i], i)
   end
   return y
end

function filtermap(t, f)
   local y, yi, r
   y = {}
   yi = 1
   for i = 1,#t do
      r = f(t[i], i)
      if r ~= nil then
	 y[yi] = r
	 yi += 1
      end
   end
   return y
end

topline = 0
bottomline = 15 * 8 + 3

colormap = {
   11, 12, 12, 11,  -- bright blue <-> bright green
   3,  1, 1, 3, -- green <-> blue
   4, 9, 9, 4,-- bright brown <-> orange
   2, 14, 14, 2, -- maroon <-> pink
   8, 2, -- red -> maroon
}

lightermap = {
    1, 13, 14, 11,
    9,  4,  7,  7,
   14, 10, 15, 10,
   10, 12, 15,  7,
}

function lighter(color)
   return lightermap[color + 1]
end

function palshift()
   for i = 0, flr(#colormap/2) - 1 do
      pal(colormap[i * 2 + 1],
	  colormap[i * 2 + 2],
	  0)
   end
end

function palunshift()
   for i = 1, #colormap do
      local v = colormap[i]
      pal(v, v, 0)
   end
end

function splice(src, ind, count, extra)
   local nextra = 0
   if extra ~= nil then
      nextra = #extra
   end
   if nextra > count then
      for i = #src, ind, -1 do
	 src[i + nextra - count] = src[i]
      end
   elseif nextra < count then
      for i = ind, #src do
	 src[i + nextra] = src[i + count]
      end
   end
   for i = 1, nextra do
      src[ind + i - 1] = extra[i]
   end
   --[[for i,v in ipairs(src) do
      print(v)
      end]]
end
--splice({1,2,3,4}, 3, 0, {6})


function eqcoord(c1, c2)
   return c1[1] == c2[1] and c1[2] == c2[2]
end

function clonecoord(c)
   return {c[1], c[2]}
end

function addcoord(c1, c2)
   return {c1[1] + c2[1], c1[2] + c2[2]}
end

function distcoord(c1, c2)
   return abs(c1[1] - c2[1]) + abs(c1[2] - c2[2])
end

function startbattle(name, ind)
   battle:start(ind, ind % #drawbg + 1)
   main = battle
end

function _init()
   cartdata("gaycodegal_op12_0")
   main = worldmap 
   main:start()
   maxinpdel = 7
   inpdelay = maxinpdel
end

function _update()
   main:update()
end

function _draw()
   main:draw()
end

function printcoord(coord)
   printh("{" .. coord[1] .. ", " .. coord[2] .. "}")
end

function tostring(b)
   return b and "true, " or "false, "
end

newsdeltas = {{0,-1},{1,0},{0,1},{-1,0}} 

-->8
--battle

slug = class({
   new = function(type, links, head, team)
      local self = {
	 team = team,
	 head = head,
	 type = type,
	 links = links,
      }
      for link in all(links) do
	 mapobjs[mapind(link)] = self
      end
      setmetatable(self, slug)
      self:nextturn()
      return self
   end,

   printmove = function(self)
      printuitext("\x97: next slug | \x8e: menu",
		  "\x94\x91\x83\x8b | moves:"..self.moves)
   end,

   printatk = function(self)
      printuitext("\x97: attack | \x8e: menu",
		  "\x94\x91\x83\x8b | pwr:"..self.type.attack)
   end,

   nextturn = function(self)
      self.moves = self.type.moves
      self.done = false
      self:movediamond()
      self.printstat = self.printmove
   end,

   attackmode = function(self, target)
      local head = self:gethead()
      if target and distcoord(target, head) > self.type.ratk then
	 target = nil
      end
      if target then
	 sfx(3)
      end
      target = target or head
      self.done = false
      self:attackdiamond()
      self.reticle = clonecoord(target)
      self.printstat = self.printatk
   end,

   didmove = function(self)
      return self.done or self.moves ~= self.type.moves
   end,

   draw = function(self)
      -- draw color squares
      local links, type, x, y, link, doshift
      links = self.links
      type = self.type
      for i = 1, #links do
	 link = links[i]
	 x, y = mapgpos(link)
	 rectfill(x, y, x + 7, y + 7, type.color) 
      end

      -- flash tail if we're at our max size
      if #links >= type.size and self.active and blink(8) then
	 link = links[1]
	 x, y = mapgpos(link)
	 rectfill(x, y, x + 7, y + 7, lighter(type.color))
      end
      
      -- draw head
      link = self:gethead()
      x, y = mapgpos(link)
      doshift = type.pflip and fget(type.head, 0)
      if doshift then
	 palshift()
      end
      spr(type.head, x, y)
      if doshift then
	 palunshift()
      end
      -- if done draw ok
      if self.done then
	 -- draw the ok in a different color than the background
	 doshift = sget(117, 24) == type.color
	 if doshift then
	    palshift()
	 end
	 sspr(117, 24, 3, 3, x + 5, y)
	 if doshift then
	    palunshift()
	 end
      end
   end,

   drawdiamond = function(self)
      local head, sprite, size, ismove, pos, x, y
      head = self:gethead()
      sprite = self.diamondspr
      ismove = sprite == 57
      size = ismove and 1 or 0
      for d in all(self.diamond) do
	 if distcoord(head, d) > size then
	    spr(sprite, mapgpos(d))
	 end
      end
      if ismove then
	 --draw the arrow keys
	 pos = addcoord(head, newsdeltas[1])
	 if battle.spaceok(pos) then
	    spr(60, mapgpos(pos))
	 end
	 pos = addcoord(head, newsdeltas[2])
	 if battle.spaceok(pos) then
	    spr(61, mapgpos(pos))
	 end
	 pos = addcoord(head, newsdeltas[3])
	 if battle.spaceok(pos) then
	    x, y = mapgpos(pos)
	    spr(60, x, y, 1, 1, false, true)
	 end
	 pos = addcoord(head, newsdeltas[4])
	 if battle.spaceok(pos) then
	    x, y = mapgpos(pos)
	    spr(61, x, y, 1, 1, true)
	 end
      end
      if self.reticle then
	 spr(56, mapgpos(self.reticle))
      end
   end,
   
   gethead = function(self)
      return self.links[self.head + 1]
   end,

   move = function(self, dx, dy)
      local next, head, replace, nind, links, obj
      self.moves -= 1
      if self.moves <= 0 then
	 self.moves = 0
	 self:endturn()
      end
      sfx(0)
      links = self.links
      head = self:gethead()
      next = addcoord(head, {dx, dy})
      if not battle.spaceok(next) then
	 self:movediamond()
	 return
      else
	 obj = mapobj(next)
	 if obj and obj.links and obj ~= self then
	    self:movediamond()
	    return
	 end
      end
      -- are we moving onto ourself
      for i = 1, #links do
	 replace = links[i]
	 if eqcoord(next, replace) then
	    nind = i
	    -- don't need to delete mapobj because we're still in the same space
	    splice(links, nind, 1)
	    -- removal without insertion can displace head
	    if nind <= self.head + 1 then
	       self.head -= 1
	    end
	    break
	 end
      end
      if nind ~= nil then
	 -- move onto self
	 nind = #links
	 splice(links, nind + 1, 0, {next})
      else
	 -- we are too big, eat our tail
	 if #links >= self.type.size then
	    self:removetail()
	    nind = self.head + 1
	    splice(links, nind + 1, 0, {next})
	 else
	    -- grow
	    nind = #links
	    splice(links, nind + 1, 0, {next})
	 end
      end
      self.head = nind

      --update map
      mapobjs[mapind(next)] = self
      self:movediamond()
   end,

   atkmove = function(self, x, y)
      sfx(3)
      local npos = addcoord(self.reticle, {x, y})
      if battle.spaceinbounds(npos) and distcoord(self:gethead(), npos) <= self.type.ratk then
	 self.reticle = npos
      end
   end,

   attack = function(self)
      local obj = mapobjs[mapind(self.reticle)]
      if obj and obj.damage and obj.team ~= self.team then
	 sfx(1)
	 obj:damage(self.type.attack)
      else
	 sfx(2)
      end
      self:endturn()
   end,

   endturn = function(self)
      self.active = false
      self.reticle = nil
      self.diamond = nil
      self.done = true      
   end,

   damage = function (self, amount)
      for i = 1, amount do
	 self:removetail()
	 if #self.links == 0 then
	    battle.slugdestroyed(self)
	    break
	 end
      end
   end,
   
   movediamond = function(self)
      self.diamond = movediamond(self.moves, self:gethead())
      self.diamondspr = 57
   end,

   attackdiamond = function(self)
      self.diamond = attackdiamond(self.type.ratk, self:gethead())
      self.diamondspr = 63
   end,

   removetail = function(self)
      local link = self.links[1]
      mapobjs[mapind(link)] = nil
      splice(self.links, 1, 1)
      self.head -= 1
   end,
})

nmedel = 0
maxnmedel = 15

function blink(x)
   return flr(main.bgi % (x*2)) < x
end

battle = {
   start = function(self, map, bg)
      battle.drawbg = drawbg[bg]
      battle.teamturn = 1 -- player turn
      battle.pslugs = {}
      battle.spawners = {}
      battle.eslugs = {}
      battle.slugs = battle.pslugs
      battle.sind = 0
      battle.mx = 0
      battle.my = 0
      battle.bgi = 0
      battle.mode = battle.spawnmode
      battle.ss = 0
      battle.map = map
      readmap(map)
      if #battle.spawners == 0 then
	 battle.spawners = nil
	 battle.mode = battle.movemode
      end
   end,

   slugdestroyed = function(slug)
      local slugs
      if slug.team == 1 then
	 slugs = battle.pslugs
      else
	 slugs = battle.eslugs
      end
      for si = 1, #slugs do
	 if slug == slugs[si] then
	    splice(slugs, si, 1)
	    if slug.team == battle.teamturn and si - 1 <= battle.sind then
	       battle.sind -= 1
	       if battle.sind == -1 then
		  battle.sind = #battle.pslugs - 1
	       end
	    end
	    break
	 end
      end
      if #slugs == 0 then
	 if slug.team != 1 then
	    beatup(battle.map)
	 end
	 battle.teamturn = -1
	 main = worldmap
	 main:start()
	 return
      end
   end,

   update = function()
      battle.mode()
      battle.updatebg()
   end,

   nextslug = function()
      battle.mode = battle.movemode
      local slug = battle.currentslug()
      if slug:didmove() then
	 slug:endturn()
      end
      battle.nextslugorturn()
   end,

   nextslugorturn = function()
      if battle.teamturn == -1 then
	 return
      end
      local sind = battle.sind
      battle.nmetarget = nil
      battle.cycleslug()
      while sind ~= battle.sind and battle.currentslug().done do
	 battle.cycleslug()
      end
      if battle.currentslug().done then
	 battle.enternextturn()
      elseif battle.teamturn == 1 then
	 battle.mode = battle.movemode
	 inpdelay = maxinpdel * 3
      else
	 battle.mode = battle.nmemove	 
      end      
   end,
   
   cycleslug = function()
      battle.sind = (battle.sind + 1) % #battle.slugs
   end,

   enternextturn = function()
      local isnmeturn = battle.teamturn == 1
      battle.slugs = isnmeturn and battle.eslugs or battle.pslugs
      local slugs = battle.slugs
      for s in all(slugs) do
	 s:nextturn()
      end
      if isnmeturn then
	 battle.teamturn = 2
	 battle.mode = battle.nmemove
	 battle.sind = 0
      else
	 battle.teamturn = 1
	 battle.mode = battle.movemode
	 battle.sind = 0
      end
      inpdelay = maxinpdel * 3
   end,

   placeslug = function(v, i, options)
      local pos, type, spawners, si
      main = battle
      if not v then
	 return
      end
      si = options[i][2]
      if sluginventory[si] <= 0 then
	 return
      end
      
      pos = battle.currentspawner()
      type = options[i][1]
      spawners = battle.spawners
      add(battle.pslugs, slug.new(type, {clonecoord(pos)}, 0, 1))
      splice(spawners, battle.ss + 1, 1)
      battle.ss %= #spawners
      sluginventory[si] -= 1
      if #spawners == 0 then
	 battle.spawners = nil
	 battle.mode = battle.movemode
      end
   end,

   currentspawner = function()
      return battle.spawners[battle.ss + 1]
   end,

   insertslug = function()
      battle.spawners = nil
      battle.mode = battle.movemode
   end,

   spawnmode = function()
      local options, opttext
      if inpdelay == 0 then
	 inpdelay = maxinpdel
	 -- news movement
	 if btn(0) then
	    sfx(3)
	    battle.ss = (battle.ss - 1) % #battle.spawners
	 elseif btn(1) then
	    sfx(3)
	    battle.ss = (battle.ss + 1) % #battle.spawners
	 elseif btn(5) then
	    sfx(3)
	    options = filtermap(types,
				      function (x, i)
					 return sluginventory[i] > 0 and {x, i} or nil
	    end)
	    opttext = map(options,
			  function(x) return x[1][1] .. ": " .. sluginventory[x[2]] end)
	    
	    main = selector.new(battle.placeslug, opttext, options)
	 else
	    inpdelay = 0
	 end
      else
	 inpdelay -= 1
      end
      
   end,

   movemode = function()
      local slug = battle.currentslug()
      slug.active = true
      if inpdelay == 0 then
	 inpdelay = maxinpdel
	 -- news movement
	 if btn(2) then
	    slug:move(0, -1)
	 elseif btn(1) then
	    slug:move(1, 0)
	 elseif btn(3) then
	    slug:move(0, 1)
	 elseif btn(0) then
	    slug:move(-1, 0)
	 elseif btn(5) then
	    battle.nextslug()
	 else
	    inpdelay = 0
	 end
      else
	 inpdelay -= 1
      end
      slug = battle.currentslug()
      if slug.done then
	 slug:attackmode()
	 battle.mode = battle.attackmode
	 inpdelay = maxinpdel
      end
   end,

   attackmode = function()
      local slug = battle.currentslug()
      if inpdelay == 0 then
	 inpdelay = maxinpdel
	 -- news movement
	 if btn(2) then
	    slug:atkmove(0, -1)
	 elseif btn(1) then
	    slug:atkmove(1, 0)
	 elseif btn(3) then
	    slug:atkmove(0, 1)
	 elseif btn(0) then
	    slug:atkmove(-1, 0)
	 elseif btn(5) then
	    slug:attack()
	 else
	    inpdelay = 0
	 end
      else
	 inpdelay -= 1
      end
      if slug.done then
	 battle.nextslugorturn()
      end
   end,

   nmemove = function()
      local closest, dist,slug,head, tdist
      slug = battle.currentslug()
      head = slug:gethead()
      dist = 100 -- greater than any distance
      for s in all(battle.pslugs) do
	 for link in all(s.links) do
	    tdist = distcoord(link, head)
	    if tdist < dist then
	       closest = link
	       dist = tdist
	    end
	 end
      end
      nmedel = maxnmedel
      battle.mode = battle.nmeslowmove
      battle.nmetarget = closest
   end,

   nmeslowmove = function()
      if nmedel ~= 0 then
	 nmedel -= 1
	 return
      end
      nmedel = maxnmedel
      battle.nmemovecloser()
   end,

   nmemovecloser = function()
      local slug, target, dir, pos, head
      slug = battle.currentslug()
      head = slug:gethead()
      target = battle.nmetarget
      for d in all(newsdeltas) do
	 pos = addcoord(head, d)
	 if distcoord(target, pos) < distcoord(target, head) and mgetcoord(pos) ~= 0 and not mapobjs[mapind(pos)] then
	    dir = d
	 end
      end
      if not dir then
	 slug:attackmode(target)
	 battle.mode = battle.nmeattack
      else
	 slug:move(dir[1], dir[2])
	 if slug.done then
	    slug:attackmode(target)
	    battle.mode = battle.nmeattack
	 end
      end
   end,

   nmeattack = function()
      if nmedel ~= 0 then
	 nmedel -= 1
	 return
      end
      battle.currentslug():attack()
      battle.nextslugorturn()
   end,

   spaceinbounds = function(coord)
      local x,y
      x= coord[1]
      y = coord[2]
      return x >= 0 and x < 16 and y >= 0 and y < 16
   end,
   
   spaceok = function(coord)
      return battle.spaceinbounds(coord) and mgetcoord(coord) ~= 0
   end,

   drawspawners = function()
      local ss, x, y, spawners
      spawners = battle.spawners
      for s in all(spawners) do
	 spr(55, mapgpos(s))
      end
      ss = battle.currentspawner()
      if blink(8) then
	 x, y = mapgpos(ss)
	 rectfill(x, y, x + 7, y + 7, 13)
      end

      drawfullui("\x97: choose slug | \x8e: menu",
		  "\x8b\x91: choose spawner")
   end,
   
   draw = function()
      battle.drawbg(worldmap.theme.bg, worldmap.theme.accent)
      mapdraw()
      for s in all(battle.pslugs) do
	 s:draw()
      end
      for s in all(battle.eslugs) do
	 s:draw()
      end
      if battle.spawners then
	 battle.drawspawners()
      else
	 local slug = battle.currentslug()
	 if slug then
	    slug:drawdiamond()
	 end
	 drawui()
	 if battle.teamturn == 1 then
	    if slug then
	       slug:printstat()
	    end
	 end
      end
   end,

   updatebg = function()
      battle.bgi += 0.5
      battle.bgi %= 128
   end,

   currentslug = function()
      return battle.slugs[battle.sind + 1]
   end,
}

function attackdiamond(size, hpos)
   local diamond, pos
   diamond = {}
   for x = 0, size * 2 do
      for y = 0, size * 2 do
	 pos = addcoord(hpos, {x - size, y - size})
	 if distcoord(pos, hpos) <= size then
	    add(diamond, pos)
	 end
      end
   end
   return diamond
end

function movediamond(size, hpos)
   -- >v, <v,<^,>^
   -- the queue
   local tmp,cur,ind,mind,s,diamond,deltas,q,low,visited,swidth,pos
   q = {s=0,e=1,n=1}
   -- lowest {x, y} possible for bound checking
   low = {0 - size, 0 - size}
   visited = {}
   q[q.s] = {0,0,size}
   swidth = size*2 + 1
   diamond={}
   listi = 0
   while q.n >= 1 do
      cur = q[q.s]
      q.s = q.s + 1
      q.n = q.n - 1
      s = cur[3]
      for d in all(newsdeltas) do
	 tmp = addcoord(cur, d)
	 tmp[3] = s - 1
	 if tmp[3] >= 0 and tmp[1] >= low[1] and tmp[1] < low[1] + swidth and tmp[2] >= low[2] and tmp[2] < low[2] + swidth then
	    ind = (tmp[1] - low[1]) + (tmp[2] - low[2])*swidth
	    pos = addcoord(tmp, hpos)
	    mind = mapind(pos)
	    if battle.spaceok(pos) and not visited[ind] then
	       visited[ind] = true
	       add(diamond, pos)
	       q[q.e] = tmp
	       q.e = q.e + 1
	       q.n = q.n + 1
	    end
	 end
      end
   end
   return diamond
end


-->8
--data

sluginventory = {2, 2}

types = {
   {
      "knife",
      ratk = 3,
      attack = 1,
      moves = 2,
      color = 1,
      head = 3,
      size = 4,
   },
   {
      "warden",
      ratk = 3,
      attack = 1,
      moves = 3,
      color = 9,
      head = 16,
      size = 5,
   },
}

-->8
--backgrounds

drawbg = {
   function(primary, secondary) -- pride orb
      local t0, n, r0, r1, s0, s1, s, k, f, c, cs
      cs = {8,9,11,12,2,4,0}
      cls(primary)
      n = 130
      r0 = 14
      r1 = 30
      s = 8
      k = 3
      for z = -k, k do
	 c = cs[z + k + 1]
	 f = (1 + k - abs(z))/((k + 1) * 4)
	 for i = 1, n do
	    t0 = ((main.bgi/2 + i * 128/n) % 128) / 128
	    s0 = sin(t0)*r0 * sin(f)
	    s1 = cos(t0)*r1 * sin(f)
	    pset(s0 + s1 + 64 - z * s, s1 + 64 + z * s, c)
	 end
      end
   end,
   function(primary, secondary) -- hollow square tunnel
      local t0, t1, x0, x1, x3, x4, a, c2
      cls(primary)
      t0 = sin(((main.bgi) % 128) / 128) * 20 + 44
      t1 = sin(((main.bgi + 32) % 128) / 128) * 5 + 48
      x0 = 64 - t1
      x1 = 64 + t1
      rectfill(x0, x0, x1, x1, secondary)

      c2 = t0 < t1 and primary or secondary
      x3 = 64 - t0
      x4 = 64 + t0
      rect(x3, x3, x4, x4, c2)
      
      line(x3, x3, x0, x0, c2)
      line(x3, x4, x0, x1, c2)
      line(x4, x3, x1, x0, c2)
      line(x4, x4, x1, x1, c2)
   end,
   function(primary, secondary) -- y sine mirrored
      local x, x0, x1, a
      cls(primary)
      for i = 0, 127, 2 do
	 a = 50 * sin(main.bgi / 128)
	 x = sin(i / 127)
	 x0 = x * a + 64
	 x1 = x * -a + 64
	 line(x0, i, x1, i, secondary)
      end
   end,
   function(primary, secondary) -- x sine mirrored
      local y, a
      cls(primary)
      for i = 0, 127 do
	 a = 50 * sin(main.bgi / 128)
	 y = sin(i / 127)
	 pset(i, y * a + 64, secondary)
	 pset(i, y * -a + 64, secondary)
      end
   end,
}

-->8
-- map manipulation

mapdata = {}

mapobjs = {}

-- by news numbers
slugshapes = {
   -- zero is a single tile shape
   {2,3,2}, -- squiggle right
   {2,3,4,3}, -- snake down
   {3,3,3,3}, -- pole down
   {4, 3, 3}, -- l upsidedown
}

--[[
#e
 se

#
s
s
s

#e
ws
s

w#
s
s

]]

-- read a binary map into existence
function readmap(mapnum)
   -- map starts with 2hex n the number of mapthings following the map
   -- maps are of size 56 hex (each bit is a tile, maps are 14 * 16)
   -- map thing is 2 hex id then 2 hex location 1 hex tetris shape 2 bit rotation 1 bit team
   -- first locate the map in memory
   -- total size is 29 + 3 * n
   local address, n, nomapthings, data, bit, mapi, mapitem
   address = 0x2000
   n = mapnum
   --global
   mapdata = {}
   for i = 1,256 do
      mapdata[i] = 0
   end
   while n > 0 do
      nomapthings = peek(address)
      address += 29 + 3 * nomapthings
      n -= 1
   end
   nomapthings = peek(address)
   address += 1
   mapi = 17 -- skip the first 16 as those are under the ui
   for i = 1, 28 do -- 28 = 56/2
      data = peek(address)
      address += 1
      for di = 1, 8 do
	 data, bit = readnextbit(data, 0, 59)
	 mapdata[mapi] = bit
	 mapi += 1
      end
   end
   for i = 1, nomapthings do
      mapitem = {}
      mapitem.id = peek(address)
      address += 1
      mapitem.location = peek(address)
      address += 1
      data = peek(address)
      address += 1
      mapitem.data = data
      mapitem.shape = flr(shr(band(0xF0, data), 4))
      mapitem.rotation = flr(shr(band(0xC, data), 2))
      data, mapitem.team = readnextbit(shl(data, 6), 1, 2)
      makeitem(mapitem)
   end
   correctmap()
end

function readnextbit(data, v1, v2)
   local bit = band(128, data) == 0 and v1 or v2
   data = shl(data, 1)
   return data, bit
end

function makeitem(item)
   if item.id > 2 then
      makeslug(item)
   elseif item.id == 0 then
      add(battle.spawners, posloc(item.location))
   end
end

function posloc(location)
   return {location % 16, flr(location / 16)}
end

function makeslug(item)
   local type, pos, dir, rlinks, links, nlinks, slugs, id, shape
   id = item.id - 2
   type = types[id]
   rlinks = {}
   links = {}
   pos = posloc(item.location)
   shape = item.shape > 0 and slugshapes[item.shape]
   for i = 0, type.size - 1 do
      if mgetcoord(pos) ~= 0 and not mapobj(pos) then
	 add(rlinks, pos)
      else
	 break
      end
      if not shape then
	 break
      end
      pos = addcoord(pos, newsdeltas[shape[i % #shape + 1]])
   end
   nlinks = #rlinks
   for i = 1, nlinks do
      links[i] = rlinks[nlinks - i + 1]
   end
   slugs = item.team == 2 and battle.eslugs or battle.pslugs
   add(slugs, slug.new(type, links, #links - 1, item.team))
end

-- pretty up the map
function correctmap()
   local coord, check, n
   for x = 0, 15 do
      for y = 0, 15 do
	 coord = {x, y}
	 n = 0
	 if mgetcoord(coord) ~= 0 then
	    for d in all(newsdeltas) do
	       check = addcoord(coord, d)
	       if battle.spaceok(check) then
		  n += 1
	       end
	    end
	    if n < 3 then
	       msetcoord({battle.mx + coord[1], battle.my + coord[2]}, 58)
	    end
	 end
      end
   end
end

function mapdraw()
   for x = 0, 15 do
      for y = 0, 15 do
	 i = x + y * 16 + 1
	 local cell = mapdata[i]	    
	 if cell ~= 0 then
	    spr(cell, 8 * x, 8 * y)
	 end
      end
   end
end

function msetcoord(coord, v)
   mapdata[mapind(coord)] = v
end

function mgetcoord(coord)
   return mapdata[mapind(coord)]
end

function mapind(coord)
   return coord[1] + coord[2] * 16 + 1
end

function mapobj(coord)
   return mapobjs[mapind(coord)]
end

-- graphical x, y of coord
function mapgpos(coord)
   return coord[1] * 8, coord[2] * 8
end

-->8
-- selection

selector = class({
   new = function(callback, options, data)
      self = {
	 callback = callback,
	 options = options,
	 theme = worldmap.theme,
	 data = data,
	 i = 1,
	 si = 0,
      }
      setmetatable(self, selector)
      return self
   end,
   start = function() end,
   draw = function(self)
      local fg, bg, accent, color, y, options, text
      options = self.options
      bg = self.theme.bg
      fg = self.theme.fg
      accent = self.theme.accent
      text = self.theme.text
      cls(bg)
      -- options

      y = (self.si + 1) * 8
      rectfill(0, y, 126, y + 6, fg)

      for i = 0, min(13, #options - self.i) do
	 color = i == self.si and text or fg
	 y = (i + 1) * 8 + 1
	 print(options[i + self.i], 1, y, color)
      end
      
      -- draw ui
      drawfullui("\x97: select | \x8e: close",
		 "\x94\x83, \x91next page \x8bback page")
   end,
   update = function(self)
      if inpdelay == 0 then
	 inpdelay = flr(maxinpdel * 2 / 3)
	 -- news movement
	 if btn(2) then
	    sfx(3)
	    -- up
	    self:setsi(self.si - 1)
	 elseif btn(1) then
	    sfx(3)
	    -- next page
	    self:seti(self.i + 14)
	 elseif btn(3) then
	    sfx(3)
	    -- down
	    self:setsi(self.si + 1)
	 elseif btn(0) then
	    sfx(3)
	    -- previous page
	    self:seti(self.i - 14)
	 elseif btn(4) then
	    sfx(3)
	    inpdelay = maxinpdel * 3
	    self.callback(nil, -1, self.data)
	 elseif btn(5) then
	    sfx(3)
	    inpdelay = maxinpdel * 3
	    local ind = self.si + self.i
	    self.callback(self.options[ind], ind, self.data)
	 else
	    inpdelay = 0
	 end
      else
	 inpdelay -= 1
      end
   end,

   seti = function(self, i)
      i = i < 0 and 0 or i
      i = i >= #self.options and #self.options - 1 or i
      self.i = flr(i / 14) * 14 + 1
      self.si = 0
   end,

   setsi = function(self, si)
      local i, options
      i = self.i
      options = self.options
      if i + si > #options then
	 self:seti(0)
	 si = 0
      elseif i + si < 1 then
	 self:seti(#self.options)
      end
      self.si = si

      if si < 0 then
	 self:seti(i - 14)
	 self.si = i + 13 > #options and #options - i or 13
      elseif si >= 14 then
	 self:seti(i + 14)
      end
   end
})

-->8

function textbox(str, x, y, w, h)
   rectfill(x,y,w,h,13)
   rect(x,y,w,h,6)
   painttext(str, x + 2,y + 2,w-4,h-4, 7)
end

function painttext(str, x, y, w, h, c)
   w+=1
   local s,i,a,b
   i=1
   for q=y,y+h-7,9 do
      s=sub(str,i,i+flr(w/4)-1)
      a=1
      b=1
      while b<=#s do
	 if sub(s,b,b)=="=" then
	    if a~=b then
	       print(sub(s,a,b-1),(a-1)*4+x,q+1,c)
	    end
	    if b+3<=#s then
	       spr(tonum("0x"..sub(s,b+1,b+3)),(b)*4+x,q)
	    else
	       i-=#s-b+1
	    end
	    b+=4
	    a=b
	 else
	    b+=1
	 end
      end
      if a<=#s then
	 print(sub(s,a),(a-1)*4+x,q+1,c)
      end
      i+=#s
   end
end


-->8


function drawui()
   local t = worldmap.theme
   rectfill(0, 0, 127, 6, t.fg)
   line(0, 6, 127, 6, t.accent)
   rectfill(0, 121, 127, 127, t.fg) 
   line(0, 121, 127, 121, t.accent)
end

function printuitext(top, bottom)
   local c = worldmap.theme.text
   print(top,0,0,c)
   print(bottom, 0, bottomline, c)
end

function drawfullui(top, bottom)
   drawui()
   printuitext(top, bottom)
end

function wcolorf(n)
   return sget(worldmapx + n * 2 - 1, worldmapy + 7)   
end

function levelnumber(x, y)
   return x + y * 4 + (worldmap.worldn - 1) * 16
end

function isbeaten(level)
   return band(shr(peek(0x5e00 + flr(level / 8)), 7 - (level % 8)), 1) == 1
end

function beatup(level, v)
   v = v or 1
   local addr = 0x5e00 + flr(level / 8)
   poke(addr, bor(peek(addr), shl(v, 7 - (level % 8))))
end

worldmap = {
   theme = {fg = 1, bg = 2, accent = 3, text = 4},
   start = function()
      local bx, by, zx, zy, wx, wy
      mapr = 4 
      bx = 6
      by = 4
      zx =  32 - mapr * 3 - bx * 2
      zy =  32 - mapr * 3 - by * 2
      wx = zx + bx * 2
      wy = zy + by * 2
      mapbridgerects = {
	 {bx, -by, zx - 1, by},
	 {wx,  bx, bx - 1, zx - 1},
	 {bx,  wy, zx - 1, by - 1},
	 {-bx, bx, bx,     zx - 1},
      }
      mapbridges = {}
      for i = 0, 15 do
	 mapbridges[i] = {false, false, false, false}
      end

      worldmap.worldn = 1
      worldmapx, worldmapy = 88 + 8 * (worldmap.worldn - 1), 16
      worldmap.theme = {fg = wcolorf(1), bg = wcolorf(2), accent = wcolorf(3), text = wcolorf(4)}
      worldmap.bgi = 0
      worldmap.drawbg = drawbg[((worldmap.worldn - 1) % #drawbg) + 1]
      
      -- find player location
      for x = 0, 3 do
	 for y = 0, 3 do
	    if sget(worldmapx + x * 2, worldmapy + y * 2) == 11 then
	       wplayerx = x
	       wplayery = y
	    end
	    if isbeaten(levelnumber(x, y)) then
	       worldmap.mapset(x, y)
	    end
	 end
      end
   end,
   update = function()
      if inpdelay == 0 then
	 inpdelay = maxinpdel
	 -- news movement
	 if btn(2) then
	    sfx(3)
	    -- up
	    worldmap.move(1)
	 elseif btn(1) then
	    sfx(3)
	    -- right
	    worldmap.move(2)
	 elseif btn(3) then
	    sfx(3)
	    -- down
	    worldmap.move(3)
	 elseif btn(0) then
	    sfx(3)
	    -- left
	    worldmap.move(4)
	 elseif btn(5) then
	    startbattle("asdf", levelnumber(wplayerx, wplayery)  % nbattles)
	    sfx(1)
	 else
	    inpdelay = 0
	 end
      else
	 inpdelay -= 1
      end
      worldmap.bgi += 0.5
      worldmap.bgi %= 128
   end,

   move = function(di)
      if worldmap.bridgeopen(wplayerx, wplayery, di) then
	 local d = newsdeltas[di]
	 wplayerx += d[1]
	 wplayery += d[2]
      end
   end,

   mapset = function(x, y)
      local mapi, crd, d
      mapi = x + y * 4
      mapbridges[mapi] = {true, true, true, true}
      for di = 0,3 do
	 d = newsdeltas[di + 1]
	 crd = addcoord({x, y}, d)
	 if crd[1] >= 0 and crd[1] < 4 and crd[2] >= 0 and crd[2] < 4 then
	    mapi = crd[1] + crd[2] * 4
	    mapbridges[mapi][(di + 2) % 4 + 1] = true
	 end
      end
   end,

   bridgeopen = function(x, y, direction)
      local mapi, delta
      delta = newsdeltas[direction]
      mapi = x + y * 4
      return x >= 0 and y >= 0 and x < 4 and y < 4 and mapbridges[mapi][direction] and sget(worldmapx + delta[1] + x * 2, worldmapy + delta[2] + y * 2) == 12
   end,

   draw = function()
      local r, dx, dy, size, tx, ty, d, txsize, c, nd, shpx, shpy, mapi
      worldmap.drawbg(worldmap.theme.bg, worldmap.theme.accent)
      for x = 0, 3 do
	 for y = 0, 3 do
	    mapi = x + y * 4
	    r = mapr
	    dx = x * 32 + r/2
	    dy = y * 28 + r * 2
	    size = 31 - r *2
	    c = sget(worldmapx + x * 2, worldmapy + y * 2)
	    rectfill(dx + r, dy + r, dx + size, dy + size, c)
	    for di = 1,4 do
	       d = mapbridgerects[di]
	       nd = newsdeltas[di]
	       if worldmap.bridgeopen(x, y, di) then
		  tx = dx + d[1] + r
		  ty = dy + d[2] + r
		  rectfill(tx, ty, tx + d[3], ty + d[4], c)
	       end
	    end
	    shpx, shpy = dx + r + 2, dy + r + 14
	    print(levelnumber(x, y) + 1, shpx, shpy - 13, 7)
	    if c == 8 then
	       print("exit", shpx, shpy, 7)
	    elseif c == 9 then
	       print("shop", shpx, shpy, 7)
	    end
	 end
      end

      
      if blink(16) or inpdelay ~= 0 then
	 r = mapr
	 dx = wplayerx * 32 + r/2 - 1
	 dy = wplayery * 28 + r * 2 - 1
	 size = 31 - r *2 + 2
	 rect(dx + r, dy + r, dx + size, dy + size, 10)
      end
      
      drawfullui("\x97: begin battle", "\x94\x91\x83\x8b")
   end,
}

--g
__gfx__
0000000000888800508558050000060000000000000000000200002800044000000d5000000c6000000000000000000006677660000000000000000000000000
0550055008888880055555500000066000000000500000502820000200044000000d5000000c6000000000000000000067878286000000000055550000001110
0005500008800880005b35000000cd600000000005000500020002000444444005d5dd500c666660000044000000700067277726004444000055550000011c00
55555555000008805553b555000cd60005000500050005000000282040444404d0dd5d0dc06666060004c4400007070077878287004444000055550000c11000
0055550000088800005b35000088600000333000002220000044420040444404d055dd05c0c6660608444540007777707727277740555504002222000011c000
0505505000088000050550500888000003b3b30002e2e2000484840000444400005d5d0000c66600044445460077877067878286044444400555555001111100
050000500000000050000005878000003333333022222220444444400040040000d00d0000c00600000044640078887067777776000000000000000008888880
000000000008800050000005080000005050505050505050505050500040040000500d0000c00600000006440077877006677660000000000000000011111c11
00000000000000000000000000000000000d6d000006600060600060000e000000000000000bb0000c100000000666000006660000000000000a9a0005055505
0111111000000000000060000000600000668660006ddd006060060d0028e0000066d0000b2bbb0001618d000066d66600668666007767700055a55005588855
011dd1100222222000060d0000060d00000d6d0000617d000600060d0028e000000d0000bbb00b000011d2d006dd05d606880286073373370522522500558550
001dd1002663b3320000d0000000d0000000d00000611d0060d000d0000200000063d00008000b00000d6d806d00050068000200073b73b70528582505558555
0555555067737b37006ddd00006ddd000066dd00006ddd0060d0060d000600000063d000000bbb0b00d6d1106000500060002000077707770555055500588850
000000002777337206ddd8d006cdcdd006b3b3d008688d800d00060d006dd000063b3d0000bb000b026d01610000500000002000067777760a55555a05555555
000000000222222006ddddd006dcdcd006ddddd008688d8060d000d0060d0d0006b3bd00003bbbb30820001c0000500000002000007070700050505005000005
0000000000000000060000d0060000d0060000d008688d8060d0060d06000d0000ddd00000033333000000000000500000002000000000000000000000000000
00004040000000000008800000000cc00006d0000006d000400000040b0000b0000000000000000000000000bc171c173c3c3c375c5c5c578c2c2c2717171717
7000990000822200000880000000ca0900cccc0000cccc00400000040b0000b000000555000000700000000077c777c7c777c777c7c7c7c7777777c777777777
7700929002228220000660000000c03900dddd0000dddd000400004000b33b0000050550007007e700000000971c1c17373c3c3757575c572c2c2c2717171717
9900777502822280000660000000c0900006d0000006d0000044440003b33b300055850007e7777000000000c7c777c7c777c777c7c777c7c777777777777777
9999970008dddd200885555009999900000dd000000dd00005844840033333300008550000787800000000001c178717373cbc37575c57872c2c2c2717171717
099977000d4545d0666666669300c000006ddd000555555005444450b333333b05555000e00777e0000000007777c7c7c777c7777777c777777777c777777777
09909000005dd4005555555590ac0000006ddd005d6dd6d5005005003bbbbbb30550000007777000000000001c1c1c17873c3c979cbc5c57bc9c2c2717171717
04004000000dd000055005500cc0000006ddddd00555555000000000b333333b05000000007070000000000071757d77737175777974717572757f7777777777
00000000066666600900009000044000005555000011c00000000000c1dccd1c280000821c1c1c1c600000066076767000111100000111000a000333ee0000ee
00066c0061cc7776909009090044440000555500011111000000000011dccd1188800888c1c1c1c10660066006700067011cc1100001c110aaa003b3ee0000ee
066dccc0611ccccda090090a40555504002222000888888000000000dddccddd088008801c00001c067007607707600611cccc111111cc110a00033300000000
6ddddc006111cccd00099000044444400555555011111c1100000000cccccccc00088000c10cc0c100077000707777061cccccc11cccccc1033300c000000000
0055000006ddddd00899998008999980089999800899998000000000cccccccc000880001c0cc01c0007700060767607111cc1111cccccc13bbb311100000000
05055000000660000899998008999980089999800899998000000000dddccddd08800880c10000c10670076070077006001cc1001111cc113b333ccc00000000
05050500006dd600999449999994499999944999999449990000000011dccd11888008881c1c1c1c0660066076000067001cc1000001c1103bbb3111ee0000ee
5005005066dddddd0099990000999900009999000099990000000000c1dccd1c28000082c1c1c1c160000006077776700011110000011100033300c0ee0000ee
05000005000040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04000004007444700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00445440075747570000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00744470007494700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07574757044fff440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00749470045fff540000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
044fff44050fff050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
045fff54000909000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010
10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010100000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000100010000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000100010000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000000000000000000000000000000000
__label__
17777711111111117771777177717771177171711111171111111777771111111111777177717711717111111111111111111111111111111111111111111111
77171771171111117171171117117171711171711111171111117711177117111111777171117171717111111111111111111111111111111111111111111111
77717771111111117771171117117771711177111111171111117717177111111111717177117171717111111111111111111111111111111111111111111111
77171771171111117171171117117171711171711111171111117711177117111111717171117171717111111111111111111111111111111111111111111111
17777711111111117171171117117171177171711111171111111777771111111111717177717171177111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
555555555555555565555556655555565555555555555555555555555555555555555555555555555555555555555555ee5555ee655555565555555555555555
555555555555555556655665566556655555555555555555555555555555555555555555555555555555555555555555ee6556ee566556655555555555555555
55555555555555555675576556755765555555555555555555555555555555555555555555555555555555555555555556755765567557655555555555555555
55555555555555555557755555577555555555555555555555555555555555555555555555555555555555555555555555577555555775555555555555555555
55555555555555555557755555577555555555555555555555555555555555555555555555555555555555555555555555577555555775555555555555555555
55555555555555555675576556755765555555555555555555555555555555555555555555555555555555555555555556755765567557655555555555555555
555555555555555556655665566556655555555555555555555555555555555555555555555555555555555555555555ee6556ee566556655555555555555555
555555555555555565555556655555565555555555555555555555555555555555555555555555555555555555555555ee5555ee655555565555555555555555
5555555565555556657676756576767565555556555555555555555555555555555555555555555555555555ee5555eeee7676eeee7676ee6555555655555555
5555555556655665567555675675556756655665555555555555555555555555555555555555555555555555ee6556eeee7555eeee7555ee5665566555555555
55555555567557657757655677576556567557655555555555555555555555555555555555555555555555555675576577576556775765565675576555555555
55555555555775557577775675777756555775555555555555555555555555555555555555555555555555555557755575777756757777565557755555555555
55555555555775556576765765767657555775555555555555555555555555555555555555555555555555555557755565767657657676575557755555555555
55555555567557657557755675577556567557655555555555555555555555555555555555555555555555555675576575577556755775565675576555555555
5555555556655665765555677655556756655665555555555555555555555555555555555555555555555555ee6556eeee5555eeee5555ee5665566555555555
5555555565555556577776755777767565555556555555555555555555555555555555555555555555555555ee5555eeee7776eeee7776ee6555555655555555
65555556657676756576767565767675657676756576767565767675657676756576767565767675ee7676eeee7676eeee7676eeee7676eeee7676ee65555556
56655665567555675675556756755567567555675675556756755567567555675675556756755567ee7555eeee7555eeee7555eeee7555eeee7555ee56655665
56755765775765567757655677576556775765567757655677576556775765567757655677576556775765567757655677576556775765567757655656755765
55577555757777567577775675777756757777567577775675777756757777567577775675777756757777567577775675777756757777567577775655577555
55577555657676576576765765767657657676576576765765767657657676576576765765767657657676576576765765767657657676576576765755577555
56755765755775567557755675577556755775567557755675577556755775567557755675577556755775567557755675577556755775567557755656755765
56655665765555677655556776555567765555677655556776555567765555677655556776555567ee5555eeee5555eeee5555eeee5555eeee5555ee56655665
65555556577776755777767557777675577776755777767557777675577776755777767557777675ee7776eeee7776eeee7776eeee7776eeee7776ee65555556
655555566576767565767675657676756576767565767675657676756576767565767675ee7676eeee7676eeee7676ee11111611ee1111eeee7676eeee5555ee
566556655675556756755567567555675675556756755567567555675675556756755567ee7555eeee7555eeee7555ee11111661ee1111eeee7555eeee6556ee
5675576577576556775765567757655677576556775765567757655677576556775765567757655677576556775765561111cd61111111117757655656755765
555775557577775675777756757777567577775675777756757777567577775675777756757777567577775675777756111cd611111111117577775655577555
55577555657676576576765765767657657676576576765765767657657676576576765765767657657676576576765711886111111111116576765755577555
56755765755775567557755675577556755775567557755675577556755775567557755675577556755775567557755618881111111111117557755656755765
566556657655556776555567765555677655556776555567765555677655556776555567ee5555eeee5555eeee5555ee87811111ee1111eeee5555eeee6556ee
655555565777767557777675577776755777767557777675577776755777767557777675ee7776eeee7776eeee7776ee18111111ee1111eeee7776eeee5555ee
55555555655555561111161165767675655555565555555555555555555555555555555555555555ee5555eeee5555eeee7676eeee9993eeee5555ee55555555
5555555556655665111116615675dd67d66d56655555555555555555555555555555555555555555ee5555eeee65d6eeee7d55eeee1113eeee6556ee55555555
55555555567557651111cd6177d765565675d76d555555555555555555555555555555555555555555555555d67d576577576dd6911dd3335675576555555555
5555555555577555111cd6117577775655577555dd55555555555555555555555555555555555555555555dd5557755575777756991dd1995557755555555555
555555555557755511886111657676575557755555dd5555555555555555555555555555555555555555dd555557755565767657955555595557755555555555
55555555567557651888111175577556567557655555d55555555555555555555555555555555555555d55555675576575577556999999995675576555555555
555555555665566587811111765555675665566555555dd555555555555555555555555555555555eed555eeee6556eeee5555eeee9999eeee6556ee55555555
55555555655555561811111157777675655555565555555d55555555555555555555555555555555ee5555eeee5555eeee7776eeee9999eeee5555ee55555555
555555555555555d99999333657676755555555555555555d555555555555555555555555555555d5555555528555582ee7676eeee9999eed555555555555555
55555555555555d5911113b35675556755555555555555555d5555555555555555555555555555d55555555588855888ee7555eeee9999ee5d55555555555555
5555555555555d55911dd33377576556555555555555555555dd555555555555555555555555dd555555555558855885775765569999999955d5555555555555
555555555555d555991dd1997577775655555555555555555555d5555555555555555555555d555555555555555885557577775699999999555d555555555555
55555555555d55559555555965767657555555555555555555555d55555555555555555555d55555555555555558855565767657999999995555d55555555555
5555555555d5555599999999755775565555555555555555555555d555555555555555555d5555555555555558855885755775569999999955555d5555555555
555555555d555555999999997655556755555555555555555555555d5555555555555555d55555555555555588855888ee5555eeee9999ee555555d555555555
55555555d55555559999999957777675555555555555555555555555d55555555555555d555555555555555528555582ee7776eeee9999ee5555555d55555555
5555555d5555555599999999657676755555555555555555555555555d555555555555d5555555555555555555555555ee7676ee9999999955555555d5555555
555555d555555555999999995675556755555555555555555555555555d5555555555d55555555555555555555555555ee7555ee99999999555555555d555555
55555d55555555559999999977576556555555555555555555555555555555555555555555555555555555555555555577576556999999995555555555d55555
5555d555555555559999999975777756555555555555555555555555555d55555555d555555555555555555555555555757777569999999955555555555d5555
555d55555555555599999999657676575555555555555555555555555555d555555d55555555555555555555555555556576765799999999555555555555d555
55d5555555555555999999997557755655555555555555555555555555555d5555d5555555555555555555555555555575577556999999995555555555555d55
5d555555555555559999999976555567555555555555555555555555555555d55d555555555555555555555555555555ee5555ee9999999955555555555555d5
555555555555555599999999577776755555555555555555555555555555555dd5555555555555555555555555555555ee7776ee999999995555555555555555
d55555555555555599999999657676755555555555555555555555555555555dd55555555555555555555555555555556576767599999999555555555555555d
5d555555555555559999999956755567555555555555555555555555555555d55d555555555555555555555555555555567555679999999955555555555555d5
55d5555555555555999999997757655655555555555555555555555555555d5555d5555555555555555555555555555577576556999999995555555555555d55
555d55555555555599999999757777565555555555555555555555555555d555555d55555555555555555555555555557577775699999999555555555555d555
5555d555555555559999999965767657555555555555555555555555555d55555555d555555555555555555555555555657676579999999955555555555d5555
55555d55555555559999999975577556555555555555555555555555555555555555555555555555555555555555555575577556999999995555555555d55555
555555d555555555999999997655556755555555555555555555555555d5555555555d555555555555555555555555557655556799999999555555555d555555
5555555d5555555599999999577776755555555555555555555555555d555555555555d5555555555555555555555555577776759999999955555555d5555555
55555555d55555559999999965767675555555555555555555555555d55555555555555d55555555555555555555555565767675999999995555555d55555555
555555555d555555999999995675556755555555555555555555555d5555555555555555d555555555555555555555555675556799999999555555d555555555
5555555555d5555599999999775765565555555555555555555555d555555555555555555d5555555555555555555555775765569999999955555d5555555555
55555555555d55559999999975777756555555555555555555555d55555555555555555555d55555555555555555555575777756999999995555d55555555555
555555555555d555999999996576765755555555555555555555d5555555555555555555555d555555555555555555556576765799999999555d555555555555
5555555555555d559999999975577556555555555555555555dd555555555555555555555555dd555555555555555555755775569999999955d5555555555555
55555555555555d5999999997655556755555555555555555d5555555555555555555555555555d5555555555555555576555567999999995d55555555555555
555555555555555d99999999577776755555555555555555d555555555555555555555555555555d55555555555555555777767599999999d555555555555555
55555555655555569999999965767675655555565555555d55555555555555555555555555555555d55555556555555665767675657676756555555655555555
555555555665566599999999567555675665566555555dd5555555555555555555555555555555555dd55555566556655675556756755d675665566555555555
55555555567557659999999977576556567557655555d55555555555555555555555555555555555555d55555675576577576556775765565675576555555555
555555555557755599999999757777565557755555dd5555555555555555555555555555555555555555dd5555577555757777567d7777565557755555555555
5555555555577555999999996576765755577555dd55555555555555555555555555555555555555555555dd5557755565767657657676575557755555555555
5555555556755765999999997dd775565675d76d555555555555555555555555555555555555555555555555d67d576575577dd6755775565675576555555555
5555555556655665999999997655dd67d66d56655555555555555555555555555555555555555555555555555665d66d76dd5567765555675665566555555555
55555555655555569999999957777675655555565555555555555555555555555555555555555555555555556555555657777675577776756555555655555555
65555556657676756576767565767675657676756576767565767675657676756576767565767675657676756576767565767675657676756576767565555556
56655665567555675675556756755567567555675675556756755567567555675675556756755567567555675675556756755567567555675675556756655665
56755765775765567757655677576556775765567757655677576556775765567757655677576556775765567757655677576556775765567757655656755765
55577555757777567577775675777756757777567577775675777756757777567577775675777756757777567577775675777756757777567577775655577555
55577555657676576576765765767657657676576576765765767657657676576576765765767657657676576576765765767657657676576576765755577555
56755765755775567557755675577556755775567557755675577556755775567557755675577556755775567557755675577556755775567557755656755765
56655665765555677655556776555567765555677655556776555567765555677655556776555567765555677655556776555567765555677655556756655665
65555556577776755777767557777675577776755777767557777675577776755777767557777675577776755777767557777675577776755777767565555556
65555556657676756576767565767675657676756576767565767675657676756576767565767675657676756576767565767675657676756576767565555556
56655665567555675675556756755567567555675675556756755567567555675675556756755567567555675675556756755567567555675675556756655665
56755765775765567757655677576556775765567757655677576556775765567757655677576556775765567757655677576556775765567757655656755765
55577555757777567577775675777756757777567577775675777756757777567577775675777756757777567577775675777756757777567577775655577555
55577555657676576576765765767657657676576576765765767657657676576576765765767657657676576576765765767657657676576576765755577555
56755765755775567557755675577556755775567557755675577556755775567557755675577556755775567557755675577556755775567557755656755765
56655665765555677655556776555567765555677655556776555567765555677655556776555567765555677655556776555567765555677655556756655665
65555556577776755777767557777675577776755777767557777675577776755777767557777675577776755777767557777675577776755777767565555556
55555555655555566576767565767675655555565555555555555555555555555555555555555555555555556555555665767675657676756555555655555555
55555555566556655675556756755567566556655555555555555555555555555555555555555555555555555665566556755567567555675665566555555555
55555555567557657757655677576556567557655555555555555555555555555555555555555555555555555675576577576556775765565675576555555555
55555555555775557577775675777756555775555555555555555555555555555555555555555555555555555557755575777756757777565557755555555555
55555555555775556576765765767657555775555555555555555555555555555555555555555555555555555557755565767657657676575557755555555555
55555555567557657557755675577556567557655555555555555555555555555555555555555555555555555675576575577556755775565675576555555555
55555555566556657655556776555567566556655555555555555555555555555555555555555555555555555665566576555567765555675665566555555555
55555555655555565777767557777675655555565555555555555555555555555555555555555555555555556555555657777675577776756555555655555555
55555555555555556555555665555556555555555555555555555555555555555555555555555555555555555555555565555556655555565555555555555555
55555555555555555665566556655665555555555555555555555555555555555555555555555555555555555555555556655665566556655555555555555555
55555555555555555675576556755765555555555555555555555555555555555555555555555555555555555555555556755765567557655555555555555555
55555555555555555557755555577555555555555555555555555555555555555555555555555555555555555555555555577555555775555555555555555555
55555555555555555557755555577555555555555555555555555555555555555555555555555555555555555555555555577555555775555555555555555555
55555555555555555675576556755765555555555555555555555555555555555555555555555555555555555555555556755765567557655555555555555555
55555555555555555665566556655665555555555555555555555555555555555555555555555555555555555555555556655665566556655555555555555555
55555555555555556555555665555556555555555555555555555555555555555555555555555555555555555555555565555556655555565555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
17777711177777111777771117777711111117111111777171717771111177111111111111111111111111111111111111111111111111111111111111111111
77717771771177717711177177711771111117111111717171717171171117111111111111111111111111111111111111111111111111111111111111111111
77111771771117717711177177111771111117111111777171717711111117111111111111111111111111111111111111111111111111111111111111111111
77111771771177717771777177711771111117111111711177717171171117111111111111111111111111111111111111111111111111111111111111111111
17777711177777111777771117777711111117111111711177717171111177711111111111111111111111111111111111111111111111111111111111111111

__gff__
0000010101010101000101000000000101000000000000000000000000000001000000000101000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0201c079407b407e007a04330411fe003c0038007400f2006000000000048b1200320004300c781effffffff781e300c300c300c300c781effffffff781e300c04bd12033d0004b212033200040000381c2c34366c1bd80db00660024007e02e747c3ef81f700e200404c21200cd00002200002d000201c079407b407e007a04
000000000000003b3b3b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000000000000000000000000000000
003b3b3b3b00003b003b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000
003b3b3b3b003b3b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010101010101000000000000000000
003b3b3b3b3b3b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000001010000000000000000
003b3b3b3b003b000000000000003b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000010000000000000000
00003b3b00003b3b0000000000003b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000010000000000000000
0000003b0000003b3b3b3b3b3b3b3b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000010000000000000000
000000000000000000003b3b3b3b3b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000
0000000000000000003b3b3b3b3b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000
0000000000000000003b3b3b3b3b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000
00000000000000003b3b3b3b00003b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010000000000000000
0000000000000000003b3b3b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000
__sfx__
00010000110500d0500f0500e050150501b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00020000300102c0102a0102f01027000280000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0002000011050110500b0500b0500000000000000002c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00020000060500e050000000000000000000000000000000000000c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
