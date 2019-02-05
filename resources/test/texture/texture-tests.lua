print("hero thereo")
require("util")
local isMain = Util.isMain()

--[[
   Render to texture + glitch art.

   Also a good demo of what textures can do currently
]]
function Start()
   t,w,h = Texture.new("images/headsprites.png")
   static.renderBlendmode(BLENDMODE_BLEND);
   tar = Texture.newTarget(SCREEN_WIDTH, SCREEN_HEIGHT)
   Texture.blendmode(tar, BLENDMODE_BLEND)
   Texture.blendmode(t, BLENDMODE_NONE)
   static.setRenderTarget(tar)
   static.renderClear()
   for x = 0,SCREEN_WIDTH//w do
	  for y = 0,SCREEN_WIDTH//h do
		 Texture.renderCopy(t,0,0,w,h,x*w,y*h,w,h)
	  end
   end
   static.unsetRenderTarget(tar)
   static.framedelay(1000//60)
end

--[[
   draw some random colored copies
]]
function Update()
   local y = 20
   Texture.setRGBMask(tar,255,255,255)
   Texture.setAMask(tar,255)
   Texture.renderCopy(tar,0,0,SCREEN_WIDTH, SCREEN_HEIGHT,0,0,SCREEN_WIDTH, SCREEN_HEIGHT)
   makeGlitch(tar, {0,0,SCREEN_WIDTH, SCREEN_HEIGHT})
   --Update = static.quit
end

--[[
   destroy things
]]
function End()
   Texture.destroy(t)
   Texture.destroy(tar)
end

--[[
   Render one colored copy of a portion of target texture to the screen

   @param tar Texture to copy
   @param r rect size of area to copy to
]]
function makeOneGlitch(tar, r)
   local d={}
   local e={}
   local f = {}
   local minw = 5
   for i=1,2 do
	  local w = r[i+2]
	  d[i]=math.random(r[i],r[i]+w-5)
	  e[i]=math.random(r[i],r[i]+w-5)

	  d[i+2]=math.random(5,w-(d[i]-r[i]))
   end
   if math.random(1,100) > 20 then
	  d[math.random(3,4)]=minw
   end
   for i =1,4 do
	  f[i]=math.random(255,255)
   end
   for i=1,2 do
	  f[math.random(1,3)]=0
   end
   --f[4] = 255
   Texture.setRGBMask(tar,f[1],f[2],f[3])
   Texture.setAMask(tar,f[4])
   Texture.renderCopy(tar,d[1],d[2],d[3],d[4], e[1],e[2],d[3],d[4])
end

--[[
   Render many colored copy of a portion of target texture to the screen

   @param tar Texture to copy
   @param r rect size of area to copy to
]]
function makeGlitch(tar, r)
   for i = 1,20 do
	  makeOneGlitch(tar, r)
   end
end

--purely a test class, so I used globals and then just told Util to pull off the global env instead of a class
Util.try(isMain, _G)
