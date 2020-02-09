pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- operator 12
-- sarah maven @zythlander
-- mit license @ github.com/gaycodegal/operator-12

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
   battle:start(ind - 1, ind % #drawbg + 1)
   main = battle
end

function _init()
   main = selector.new(startbattle,
		       {"lotus", "crossroads", "swords"},
		       {accent = 12, fg = 7, bg = 1})
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
      print("\x97: next slug | \x8e: menu",0,0,7)
      print("\x94\x91\x83\x8b | moves:"..self.moves, 0, bottomline, 7)
   end,

   printatk = function(self)
      print("\x97: attack | \x8e: menu",0,0,7)
      print("\x94\x91\x83\x8b | pwr:"..self.type.attack, 0, bottomline, 7)
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
   return flr(battle.bgi % (x*2)) > x
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
      readmap(map)
      if #battle.spawners == 0 then
	 battle.spawners = nil
	 battle.mode = battle.movemode
      end
   end,

   slugdestroyed = function(slug)
      local slugs = battle.pslugs
      if slug.team == 1 then
	 for si = 1, #slugs do
	    if slug == slugs[si] then
	       splice(slugs, si, 1)
	       if si == battle.sind then
		  battle.sind -= 1
		  if battle.sind == -1 then
		     battle.sind = #battle.pslugs - 1
		  end
	       end
	    end
	 end
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
	    
	    main = selector.new(battle.placeslug,
		       opttext,
		       {accent = 11, fg = 7, bg = 3}, options)
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

      print("\x97: choose slug | \x8e: menu", 0, topline, 7)
      print("\x8b\x91: choose spawner", 0, bottomline, 7)
   end,
   
   draw = function()
      battle.drawbg(2, 5)
      mapdraw()
      for s in all(battle.pslugs) do
	 s:draw()
      end
      for s in all(battle.eslugs) do
	 s:draw()
      end
      local slug = battle.currentslug()
      if slug then
	 slug:drawdiamond()
      end
      -- draw ui
      rectfill(0, 0, 127, 6, 1)
      line(0, 6, 127, 6, 12)
      rectfill(0, 121, 127, 127, 1) 
      line(0, 121, 127, 121, 12)
      if battle.teamturn == 1 then
	 if slug then
	    slug:printstat()
	 end
      end
      if battle.spawners then
	 battle.drawspawners()
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
--types

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
   function(primary, secondary) -- hollow square tunnel
      local t0, t1, x0, x1, x3, x4, a, c2
      rectfill(0, 0, 127, 127, primary)
      t0 = sin(((battle.bgi) % 128) / 128) * 20 + 44
      t1 = sin(((battle.bgi + 32) % 128) / 128) * 5 + 48
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
      rectfill(0, 0, 127, 127, primary)
      for i = 0, 127, 2 do
	 a = 50 * sin(battle.bgi / 128)
	 x = sin(i / 127)
	 x0 = x * a + 64
	 x1 = x * -a + 64
	 line(x0, i, x1, i, secondary)
      end
   end,
   function(primary, secondary) -- x sine mirrored
      local y, a
      rectfill(0, 0, 127, 127, primary)
      for i = 0, 127 do
	 a = 50 * sin(battle.bgi / 128)
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
   new = function(callback, options, theme, data)
      self = {
	 callback = callback,
	 options = options,
	 theme = theme,
	 data = data,
	 i = 1,
	 si = 0,
      }
      setmetatable(self, selector)
      return self
   end,
   start = function() end,
   draw = function(self)
      local fg, bg, accent, color, y, options
      options = self.options
      bg = self.theme.bg
      fg = self.theme.fg
      accent = self.theme.accent
      cls(bg)
      -- options

      y = (self.si + 1) * 8
      rectfill(0, y, 126, y + 6, fg)

      for i = 0, min(13, #options - self.i) do
	 color = i == self.si and bg or fg
	 y = (i + 1) * 8 + 1
	 print(options[i + self.i], 1, y, color)
      end
      
      -- draw ui
      line(0, 6, 127, 6, accent)
      line(0, 121, 127, 121, accent)
      print("\x97: select | \x8e: close",0,0,7)
      print("\x94\x83, \x91next page \x8bback page", 0, bottomline, fg)
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
--player inventory
sluginventory = {2, 2}

-->8

worldmap = {
   start = function()
      local bridger, z, w
      mapr = 4
      bridger = 6
      z =  31 - mapr * 3 - bridger * 2
      w = 1 + z + bridger * 2
      mapbridges = {
	 {bridger, -bridger, z, bridger},
	 {w, bridger, bridger - 1, z},
	 {bridger, w, z, bridger - 1},
	 {-bridger, bridger, bridger, z},
      }
      worldmapx, worldmapy = 88 + 8 * 1, 16
   end,
   update = function()

   end,

   draw = function()
      local r, dx, dy, size, tx, ty, d, txsize, c, nd, shpx, shpy
      cls(0)
      for x = 0, 3 do
	 for y = 0, 3 do
	    r = mapr
	    dx = x * 32 + r/2
	    dy = y * 32 + r/2
	    size = 31 - r *2
	    c = sget(worldmapx + x * 2, worldmapy + y * 2)
	    rectfill(dx + r, dy + r, dx + size, dy + size, c)
	    for di = 1,4 do
	       d = mapbridges[di]
	       nd = newsdeltas[di]
	       if sget(worldmapx + nd[1] + x * 2, worldmapy + nd[2] + y * 2) == 3  then
		  tx = dx + d[1] + r
		  ty = dy + d[2] + r
		  rectfill(tx, ty, tx + d[3], ty + d[4], c)
	       end
	    end
	    shpx, shpy = dx + r + 1, dy + r + 1
	    if c == 8 then
	       print("exit", shpx, shpy, 7)
	    elseif c == 9 then
	       print("shop", shpx, shpy, 7)
	    end
	 end
      end
   end,
}

--g
__gfx__
0000000005055505508558050000060000000000000000000200002800044000000d5000000c6000000000000000000000000000000000000000000000000000
0550055005588855055555500000066000000000500000502820000200044000000d5000000c6000000000000000000000000000005555000000111000066c00
0005500000558550005b35000000cd600000000005000500020002000444444005d5dd500c6666600000440000007000004444000055550000011c00066dccc0
55555555055585555553b555000cd60005000500050005000000282040444404d0dd5d0dc06666060004c44000070700004444000055550000c110006ddddc00
0055550000588850005b35000088600000333000002220000044420040444404d055dd05c0c66606084445400077777040555504002222000011c00000550000
0505505005555555050550500888000003b3b30002e2e2000484840000444400005d5d0000c66600044445460077877004444440055555500111110005055000
050000500500000550000005878000003333333022222220444444400040040000d00d0000c00600000044640078887000000000000000000888888005050500
000000000000000050000005080000005050505050505050505050500040040000500d0000c006000000064400778770000000000000000011111c1150050050
00000000000000000000000000000000000d6d000006600060600060000e000000000000000bb0000c100000000666000006660000000000000a9a0000000000
0111111000000000000060000000600000668660006ddd006060060d0028e0000066d0000b2bbb0001618d000066d66600668666007767700055a55000000000
011dd1100222222000060d0000060d00000d6d0000617d000600060d0028e000000d0000bbb00b000011d2d006dd05d606880286073373370522522500099900
001dd1002663b3320000d0000000d0000000d00000611d0060d000d0000200000063d00008000b00000d6d806d00050068000200073b73b70528582500899980
0555555067737b37006ddd00006ddd000066dd00006ddd0060d0060d000600000063d000000bbb0b00d6d1106000500060002000077707770555055590899980
000000002777337206ddd8d006cdcdd006b3b3d008688d800d00060d006dd000063b3d0000bb000b026d01610000500000002000067777760a55555a09994999
000000000222222006ddddd006dcdcd006ddddd008688d8060d000d0060d0d0006b3bd00003bbbb30820001c0000500000002000007070700050505000099900
0000000000000000060000d0060000d0060000d008688d8060d0060d06000d0000ddd00000033333000000000000500000002000000000000000000000000000
00004040000000000008800000000cc00006d0000006d000400000040b0000b0000000000000000000004000b317131713131317131313178313131717171717
7000990000822200000880000000ca0900cccc0000cccc00400000040b0000b00000055500000070007444707737773737773777373737377777773777777777
7700929002228220000660000000c03900dddd0000dddd000400004000b33b0000050550007007e7075747579713131717131317171713171313131717171717
9900777502822280000660000000c0900006d0000006d0000044440003b33b300055850007e77770007494703737773737773777373777373777777777777777
9999970008dddd200885555009999900000dd000000dd00005844840033333300008550000787800044fff44131787171713b317171317871313131717171717
099977000d4545d0666666669300c000006ddd000555555005444450b333333b05555000e00777e0045fff547777373737773777777737777777773777777777
09909000005dd4005555555590ac0000006ddd005d6dd6d5005005003bbbbbb30550000007777000050fff05131313178713139793b31317b393131717171717
04004000000dd000055005500cc0000006ddddd00555555000000000b333333b0500000000707000000909007777777777777777777777777777777777777777
00000000000000000000000000000000000000000000000000000000c1dccd1c280000821c1c1c1c600000066076767000111100000111000a000333ee0000ee
0000000000000000000000000000000000000000000000000000000011dccd1188800888c1c1c1c10660066006700067011cc1100001c110aaa003b3ee0000ee
00000000000000000000000000000000000000000000000000000000dddccddd088008801c00001c067007607707600611cccc111111cc110a00033300000000
00000000000000000000000000000000000000000000000000000000cccccccc00088000c10cc0c100077000707777061cccccc11cccccc1033300c000000000
00000000000000000000000000000000000000000000000000000000cccccccc000880001c0cc01c0007700060767607111cc1111cccccc13bbb311100000000
00000000000000000000000000000000000000000000000000000000dddccddd08800880c10000c10670076070077006001cc1001111cc113b333ccc00000000
0000000000000000000000000000000000000000000000000000000011dccd11888008881c1c1c1c0660066076000067001cc1000001c1103bbb3111ee0000ee
00000000000000000000000000000000000000000000000000000000c1dccd1c28000082c1c1c1c160000006077776700011110000011100033300c0ee0000ee
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
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
22222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222
22222222222222226222222662222226222222222222222255555555555555555555555555555555222222222222222262222226622222262222222222222222
22222222222222222662266226622662222222222222222222222222222222222222222222222222222222222222222226622662266226622222222222222222
22222222222222222672276226722762222222222222555555555555555555555555555555555555555522222222222226722762267227622222222222222222
22222222222222222227722222277222222222222222222222222222222222222222222222222222222222222222222222277222222772222222222222222222
22222222222222222227722222277222222222222555555555555555555555555555555555555555555555522222222222277222222772222222222222222222
22222222222222222672276226722762222222222222222222222222222222222222222222222222222222222222222226722762267227622222222222222222
22222222222222222662266226622662222222555555555555555555555555555555555555555555555555555522222226622662266226622222222222222222
22222222222222226222222662222226222222222222222222222222222222222222222222222222222222222222222262222226622222262222222222222222
2222222262222226627676726276767262255556555555555555555555555555555555555555555555555555ee5552ee62767672627676726222222622222222
2222222226622662267222672672226726622662222222222222222222222222222222222222222222222222ee6226ee26722267267222672662266222222222
22222222267227627727622677276226567557655555555555555555555555555555555555555555555555555675576577276226772762262672276222222222
22222222222772227277772672777726222772222222222222222222222222222222222222222222222222222227722272777726727777262227722222222222
22222222222772226276762762767657555775555555555555555555555555555555555555555555555555555557755565767627627676272227722222222222
22222222267227627227722672277226267227622222222222222222222222222222222222222222222222222672276272277226722772262672276222222222
2222222226622662762222677622556756655665555555555555555555555555555555555555555555555555ee6556ee76552267762222672662266222222222
2222222262222226277776722777767262222226222222222222222222222222222222222222222222222222ee2222ee27777672277776726222222622222222
62222226627676721111111111111111111116116576767565767675657676756576767565767675ee7676eeee7676eeee7676ee627676726276767262222226
26622662267222671111111111111111111116612672226726722267267222672672226726722267ee7222eeee7222eeee7222ee267222672672226726622662
267227627727622611111111111111111111cd617757655677576556775765567757655677576556775765567757655677576556772762267727622626722762
22277222727777261111111111111111111cd6117277772672777726727777267277772672777726727777267277772672777726727777267277772622277222
22277222627676271111111111111111118861116576765765767657657676576576765765767657657676576576765765767657627676276276762722277222
26722762722772261111111111111111188811117227722672277226722772267227722672277226722772267227722672277226722772267227722626722762
26622662762222671111111111111111878111117655556776555567765555677655556776555567ee5555eeee5555eeee5555ee762222677622226726622662
62222226277776721111111111111111181111112777767227777672277776722777767227777672ee7776eeee7776eeee7776ee277776722777767262222226
622222266276767262767675657676756576767565767675657676756576767565767675ee7676eeee7676eeee1111eeee1111eeee1111ee6276767262222226
266226622672226726722267267222672672226726722267267222672672226726722267ee7222eeee7222eeee1111eeee1111eeee1111ee2672226726622662
26722762772762267727622677576556775765567757655677576556775765567757655677576556775765561111111111111111111111117727622626722762
22277222727777267277772672777726727777267277772672777726727777267277772672777726727777261111111111111111111111117277772622277222
22277222627676276276762765767657657676576576765765767657657676576576765765767657657676571111111111111111111111116276762722277222
26722762722772267227722672277226722772267227722672277226722772267227722672277226722772261111111111111111111111117227722626722762
266226627622226776222267765555677655556776555567765555677655556776555567ee5555eeee5555eeee1111eeee1111eeee1111ee7622226726622662
622222262777767227777672277776722777767227777672277776722777767227777672ee7776eeee7776eeee1111eeee1111eeee1111ee2777767262222226
2222222262222226627676726276767565555556555555555555555555555555ee5555eeee5555eeee5555ee11111611ee7676eeee7676eeee2222ee22222222
2222222226622662267222672672226726622662222222222222222222222222ee2222eeee2222eeee2222ee11111661ee7222eeee7222eeee6226ee22222222
22222222267227627727622677276556567557655555555555555555555555555555555555555555555555551111cd6177576226772762262672276222222222
2222222222277222727777267277772622277222222222222222222222222222222222222222222222222222111cd61172777726727777262227722222222222
22222222222772226276762762767657555775555555555555555555555555555555555555555555555555551188611165767627627676272227722222222222
22222222267227627227722672277226267227622222222222222222222222222222222222222222222222221888111172277226722772262672276222222222
2222222226622662762222677622226726655665555555555555555555555555ee5555eeee5555eeee5555ee87811111ee2222eeee2222eeee6226ee22222222
2222222262222226277776722777767262222226222222222222222222222222ee2222eeee2222eeee2222ee18111111ee7776eeee7776eeee2222ee22222222
222222222222222262767672627676722222555555555555555555555555555555555555ee5555ee28555582ee5522eeee7676eeee7676ee2222222222222222
222222222222222226722267267222672222222222222222222222222222222222222222ee2222ee88822888ee2222eeee7222eeee7222ee2222222222222222
22222222222222227727622677276226222222255555555555555555555555555555555555555555588558855222222277276226772762262222222222222222
22222222222222227277772672777726222222222222222222222222222222222222222222222222222882222222222272777726727777262222222222222222
22222222222222226276762762767627222222222255555555555555555555555555555555555555555885222222222262767627627676272222222222222222
22222222222222227227722672277226222222222222222222222222222222222222222222222222288228822222222272277226722772262222222222222222
222222222222222276222267762222672222222222222555555555555555555555555555ee5555ee88822888ee2222eeee2222eeee2222ee2222222222222222
222222222222222227777672277776722222222222222222222222222222222222222222ee2222ee28222282ee2222eeee7776eeee7776ee2222222222222222
22222222222222226276767262767672222222222222222225555555555555555555555555555552ee2222eeee2222eeee7676ee627676722222222222222222
22222222222222222672226726722267222222222222222222222222222222222222222222222222ee2222eeee2222eeee7222ee267222672222222222222222
22222222222222227727622677276226222222222222222222222555555555555555555555522222222222222222222277276226772762262222222222222222
22222222222222227277772672777726222222222222222222222222222222222222222222222222222222222222222272777726727777262222222222222222
22222222222222226276762762767627222222222222222222222222255555555555555222222222222222222222222262767627627676272222222222222222
22222222222222227227722672277226222222222222222222222222222222222222222222222222222222222222222272277226722772262222222222222222
22222222222222227622226776222267222222222222222222222222222225555552222222222222ee2222eeee2222eeee2222ee762222672222222222222222
22222222222222222777767227777672222222222222222222222222222222222222222222222222ee2222eeee2222eeee7776ee277776722222222222222222
2222222222222222999993336276767222222222222222222222222222222255552222222222222222222222ee2222ee62767672999993332222222222222222
2222222222222222911113b32672226722222222222222222222222222222222222222222222222222222222ee2222ee26722267911113b32222222222222222
2222222222222222911dd33377276226222222222222222222222222222555555555522222222222222222222222222277276226911dd3332222222222222222
2222222222222222991dd19972777726222222222222222222222222222222222222222222222222222222222222222272777726991dd1992222222222222222
22222222222222229555555962767627222222222222222222222225555555555555555552222222222222222222222262767627955555592222222222222222
22222222222222229999999972277226222222222222222222222222222222222222222222222222222222222222222272277226999999992222222222222222
2222222222222222999999997622226722222222222222222225555555555555555555555555522222222222ee2222ee76222267999999992222222222222222
2222222222222222999999992777767222222222222222222222222222222222222222222222222222222222ee2222ee27777672999999992222222222222222
22222222222222229999999962767672222222222222222555555555555555555555555555555555522222222222222262767672999999992222222222222222
22222222222222229999999926722267222222222222222222222222222222222222222222222222222222222222222226722267999999992222222222222222
22222222222222229999999977276226222222222222555555555555555555555555555555555555555522222222222277276226999999992222222222222222
22222222222222229999999972777726222222222222222222222222222222222222222222222222222222222222222272777726999999992222222222222222
22222222222222229999999962767627222222225555555555555555555555555555555555555555555555552222222262767627999999992222222222222222
22222222222222229999999972277226222222222222222222222222222222222222222222222222222222222222222272277226999999992222222222222222
22222222222222229999999976222267222225555555555555555555555555555555555555555555555555555552222276222267999999992222222222222222
22222222222222229999999927777672222222222222222222222222222222222222222222222222222222222222222227777672999999992222222222222222
22222222622222269999999962767672625555565555555555555555555555555555555555555555555555556555552662767672999999996222222622222222
22222222266226629999999926722267266226622222222222222222222222222222222222222222222222222662266226722267999999992662266222222222
22222222267227629999999977276226567557655555555555555555555555555555555555555555555555555675576577276226999999992672276222222222
22222222222772229999999972777726222772222222222222222222222222222222222222222222222222222227722272777726999999992227722222222222
22222222222772229999999962767657555775555555555555555555555555555555555555555555555555555557755565767627999999992227722222222222
22222222267227629999999972277226267227622222222222222222222222222222222222222222222222222672276272277226999999992672276222222222
22222222266226629999999976255567566556655555555555555555555555555555555555555555555555555665566576555267999999992662266222222222
22222222622222269999999927777672622222262222222222222222222222222222222222222222222222226222222627777672999999996222222622222222
62222226627676729999999999999999657676756576767565767675657676756576767565767675657676756576767565767672999999999999999962222226
26622662267222679999999999999999267222672672226726722267267222672672226726722267267222672672226726722267999999999999999926622662
26722762772762269999999999999999775765567757655677576556775765567757655677576556775765567757655677576556999999999999999926722762
22277222727777269999999999999999727777267277772672777726727777267277772672777726727777267277772672777726999999999999999922277222
22277222627676279999999999999999657676576576765765767657657676576576765765767657657676576576765765767657999999999999999922277222
26722762722772269999999999999999722772267227722672277226722772267227722672277226722772267227722672277226999999999999999926722762
26622662762222679999999999999999765555677655556776555567765555677655556776555567765555677655556776555567999999999999999926622662
62222226277776729999999999999999277776722777767227777672277776722777767227777672277776722777767227777672999999999999999962222226
62222226627676726276767565767675657676756576767565767675657676756576767565767675657676756576767565767675627676726276767262222226
26622662267222672672226726722267267222672672226726722267267222672672226726722267267222672672226726722267267222672672226726622662
26722762772762267727622677576556775765567757655677576556775765567757655677576556775765567757655677576556772762267727622626722762
22277222727777267277772672777726727777267277772672777726727777267277772672777726727777267277772672777726727777267277772622277222
22277222627676276276762765767657657676576576765765767657657676576576765765767657657676576576765765767657627676276276762722277222
26722762722772267227722672277226722772267227722672277226722772267227722672277226722772267227722672277226722772267227722626722762
26622662762222677622226776555567765555677655556776555567765555677655556776555567765555677655556776555567762222677622226726622662
62222226277776722777767227777672277776722777767227777672277776722777767227777672277776722777767227777672277776722777767262222226
22222222622222266276767262767675655555565555555555555555555555555555555555555555555555556555555665767672627676726222222622222222
22222222266226622672226726722267266226622222222222222222222222222222222222222222222222222662266226722267267222672662266222222222
22222222267227627727622677276556567557655555555555555555555555555555555555555555555555555675576577576226772762262672276222222222
22222222222772227277772672777726222772222222222222222222222222222222222222222222222222222227722272777726727777262227722222222222
22222222222772226276762762767627555775555555555555555555555555555555555555555555555555555557755562767627627676272227722222222222
22222222267227627227722672277226267227622222222222222222222222222222222222222222222222222672276272277226722772262672276222222222
22222222266226627622226776222267266556655555555555555555555555555555555555555555555555555665566276222267762222672662266222222222
22222222622222262777767227777672622222262222222222222222222222222222222222222222222222226222222627777672277776726222222622222222
22222222222222226222222662222226222255555555555555555555555555555555555555555555555555555555222262222226622222262222222222222222
22222222222222222662266226622662222222222222222222222222222222222222222222222222222222222222222226622662266226622222222222222222
22222222222222222672276226722762222222255555555555555555555555555555555555555555555555555222222226722762267227622222222222222222
22222222222222222227722222277222222222222222222222222222222222222222222222222222222222222222222222277222222772222222222222222222
22222222222222222227722222277222222222222225555555555555555555555555555555555555555552222222222222277222222772222222222222222222
22222222222222222672276226722762222222222222222222222222222222222222222222222222222222222222222226722762267227622222222222222222
22222222222222222662266226622662222222222222225555555555555555555555555555555555552222222222222226622662266226622222222222222222
22222222222222226222222662222226222222222222222222222222222222222222222222222222222222222222222262222226622222262222222222222222
22222222222222222222222222222222222222222222222222555555555555555555555555555522222222222222222222222222222222222222222222222222
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
17777711177777111777771117777711111117111111777171717771111177111111111111111111111111111111111111111111111111111111111111111111
77717771771177717711177177711771111117111111717171717171171117111111111111111111111111111111111111111111111111111111111111111111
77111771771117717711177177111771111117111111777171717711111117111111111111111111111111111111111111111111111111111111111111111111
77111771771177717771777177711771111117111111711177717171171117111111111111111111111111111111111111111111111111111111111111111111
17777711177777111777771117777711111117111111711177717171111177711111111111111111111111111111111111111111111111111111111111111111

__gff__
0001010101010101000101000000010101000000000000000000000000000000000000000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
