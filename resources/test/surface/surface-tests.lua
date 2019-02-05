require("util")
local isMain = Util.isMain()

--[[
   Draws an image with a colored background

   Demo of what surfaces can do
]]
function Start()
   print("hi")
   s = Surface.new("images/headsprites.png")
   w,h = Surface.size(s)
   s2 = Surface.newBlank(w, h)
   Surface.fill(s2, 56,56,56,56
				,250,250,0,255)
   Surface.fill(s2, 56 * 2,0,56,56
				,0,200,200,255)
   Surface.blit(s2, s, 0, 0)
   t = Surface.textureFrom(s)
   t2 = Surface.textureFrom(s2)
   spr = Sprite.new(t, 0,0,w,h,0,0)
   spr2 = Sprite.new(t2, 0,0,w,h,0,0)
   sprs = {spr, spr2}
   ts = {t, t2}
   Surface.destroy(s2)
   Surface.destroy(s)
   static.framedelay(1000//30)
end

--[[
   draw things
]]
function Update()
   --Update = static.quit
   for i, spr in ipairs(sprs) do
	  spr:draw(0,h * (i - 1))
   end
end

--[[
   destroy things
]]
function End()
   for i, t in ipairs(ts) do
	  Texture.destroy(t)
   end
   for i, spr in ipairs(sprs) do
	  spr:destroy()
   end
   print("goodbye")
end

--purely a test class, so I used globals and then just told Util to pull off the global env instead of a class
Util.try(isMain, _G)
