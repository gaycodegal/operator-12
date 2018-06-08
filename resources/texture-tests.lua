require("util")


function Start()
   print("hi")
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
   static.framedelay(1000//30)
end

function Update()
   local y = 20
   Texture.setRGBMask(tar,255,255,255)
   Texture.setAMask(tar,255)
   Texture.renderCopy(tar, 0,0,SCREEN_WIDTH, SCREEN_HEIGHT,0,0,SCREEN_WIDTH, SCREEN_HEIGHT)
   Texture.setRGBMask(tar,255,0,0)
   Texture.setAMask(tar,100)
   Texture.renderCopy(tar, 0,0,SCREEN_WIDTH, SCREEN_HEIGHT,10,y,SCREEN_WIDTH, SCREEN_HEIGHT)
   Texture.setRGBMask(tar,0,0,255)
   Texture.setAMask(tar,100)
   Texture.renderCopy(tar, 0,0,SCREEN_WIDTH, SCREEN_HEIGHT,-10,y,SCREEN_WIDTH, SCREEN_HEIGHT)
   Texture.setRGBMask(tar,0,255,0)
   Texture.setAMask(tar,100)
   Texture.renderCopy(tar, 0,0,SCREEN_WIDTH, SCREEN_HEIGHT,0,y,SCREEN_WIDTH, SCREEN_HEIGHT)
   --Update = static.quit
end

function End()
   Texture.destroy(t)
   Texture.destroy(tar)
   print("goodbye")
end
