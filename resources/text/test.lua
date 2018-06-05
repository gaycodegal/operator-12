require("util")
require("text/text")

function Start()
   --print(Text.charsInLine("test", 100))
   print("hi")
   page = 1
   --[=[
   maps = listdir("maps/")
   ts = {}
   ss = {}
for i = page,page+16 do
	  local name = maps[i]
	  if name then
		 local s = TTF.surface(name, 255,255,255,255)
		 local w,h = Surface.size(s)
		 ts[i] = Surface.textureFrom(s)
		 ss[i] = Sprite.new(ts[i], SCREEN_WIDTH * ((i-1) % 4) // 5, SCREEN_HEIGHT * ((i-1) // 4) // 5, w,h,0,0)
		 Surface.destroy(s)
		 print(name)
	  end
	  end]=]
   local f = io.open("../README.md", "r")
   text = f:read("a")
   f:close()
   texts = {}
   local i = 1
   local l = Text.charsInTextbox(text, SCREEN_WIDTH, SCREEN_HEIGHT)
   while l > 0 do
	  texts[i] = string.sub(text,1,l)
	  text = string.sub(text,l + 1)
	  i = i + 1
	  l = Text.charsInTextbox(text, SCREEN_WIDTH, SCREEN_HEIGHT)
   end
   updateForPage(1)
end

function free()
   if tex then
	  Texture.destroy(tex)
   end
   tex = nil
   if spr then
	  spr:destroy()
   end
   spr = nil
end

function updateForPage(p)
   if texts[p] == nil then
	  return
   end
   free()
   page = p
   local sbox = Text.textbox(texts[page], SCREEN_WIDTH, SCREEN_HEIGHT, 255,255,255,255)
   tex = Surface.textureFrom(sbox)
   spr = Sprite.new(tex, 0,0,SCREEN_WIDTH, SCREEN_HEIGHT,0,0)
   Surface.destroy(sbox)
end

function Update()
   --Update = static.quit
   spr:draw(0,0)
end

function End()
   free()
   print("goodbye")
end

function KeyDown(key)
   if key == KEY_ESCAPE then
	  static.quit()
   elseif key == KEY_UP then
	  updateForPage(page - 1)
   elseif key == KEY_DOWN then
	  updateForPage(page + 1)
   elseif key == KEY_LEFT then
	  updateForPage(page - 1)
   elseif key == KEY_RIGHT then
	  updateForPage(page + 1)
   end
end
