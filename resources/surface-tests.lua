require("util")


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

function Update()
   --Update = static.quit
   for i, spr in ipairs(sprs) do
	  spr:draw(0,h * (i - 1))
   end
end

function End()
   for i, t in ipairs(ts) do
	  Texture.destroy(t)
   end
   for i, spr in ipairs(sprs) do
	  spr:destroy()
   end
   print("goodbye")
end
