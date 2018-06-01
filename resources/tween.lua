require("util")
Tween = {}

--function Tween.interpolate

Tween.__index = metareplacer(Tween)

function Tween.new (dx, dt, param, target)
   local t = {step=Tween.linear, dx=dx, dt=dt, s=0, t=target, l=0, p=param}
   setmetatable(t, Tween)
   return t
end


function Tween.reset(self)
   self.s = 0
   self.l = 0
end

--function Tween..

function Tween.linear(self, dt)
   local time = self.s + dt
   local done = false
   if time > self.dt then
      time = self.dt
      done = true
   end
   self.s = time
   local val = math.floor(time * self.dx / self.dt)
   local tar = self.t
   local last = self.l
   self.l = val
   local p = self.p
   --print(tar, tar[p])
   tar[p] = tar[p] + val - last
   return done
end

function Tween.destroy(self)
   --nothing to see here
end

Animation = {}

Animation.__index = metareplacer(Animation)

function Animation.new(tweens, dorepeat)
   tweens.dorepeat = dorepeat
   tweens.i = 1
   tweens.mi = #tweens
   setmetatable(tweens, Animation)
   return tweens
end

function Animation.destroy(self)
   for k, v in ipairs(self) do
      v:destroy()
   end
end

function Animation.step(self, dt)
   local tween = self[self.i]
   if tween:step(dt) then
      tween:reset()
      self.i = (self.i % self.mi) + 1
   end
end
