require("util")


function Start()
   print("hi")
   page = 1
   maps = listdir("maps/")
   ts = {}
   ss = {}
   for i = page,page+16 do
	  local name = maps[i]
	  if name then
		 local s = Surface.newText(name, 255,255,255,255)
		 local w,h = Surface.sizeOf(s)
		 ts[i] = Surface.textureFrom(s)
		 ss[i] = Sprite.new(ts[i], SCREEN_WIDTH * ((i-1) % 4) // 5, SCREEN_HEIGHT * ((i-1) // 4) // 5, w,h,0,0)
		 Surface.destroy(s)
		 print(name)
	  end
   end
   
end

function Update()
   --Update = static.quit
   for i,s in ipairs(ss) do
	  s:draw(0,0)
   end
end

function End()
   for i,s in ipairs(ss) do
	  s:destroy()
   end
   for i,t in ipairs(ts) do
	  Texture.destroy(t)
   end
   print("goodbye")
end
