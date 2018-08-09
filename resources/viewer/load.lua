require("util")
local isMain = Util.isMain()
require("text/Text")
Viewer = {}
local V = Viewer

function V.readAll(dir, sep)
   local texts = {}
   local sources = listdir(dir)
   for i, source in ipairs(sources) do
	  local f = io.open(dir..source, "r")
	  texts[i] = f:read("a")
	  f:close()
   end
   return table.concat(texts, sep)
end

function V.Start(argc, argv)
   if argc < 3 then	
	  argv = {"viewer/load", "licenses/", "\n\n"}
   end
   V.stext = V.readAll(argv[2], argv[3])
   V.reset()
end

function V.Resize(w, h)
   SCREEN_WIDTH = w
   SCREEN_HEIGHT = h
   V.reset()
end

function V.reset()
   local text = V.stext
   V.texts = {}
   V.page = 1
   local i = 1
   local l = Text.charsInTextbox(text, SCREEN_WIDTH, SCREEN_HEIGHT)
   while l > 0 do
	  V.texts[i] = string.sub(text,1,l)
	  text = string.sub(text,l + 1)
	  i = i + 1
	  l = Text.charsInTextbox(text, SCREEN_WIDTH, SCREEN_HEIGHT)
   end
   V.updateForPage(1)
end

function V.free()
   if V.tex then
	  Texture.destroy(V.tex)
   end
   V.tex = nil
   if V.spr then
	  V.spr:destroy()
   end
   V.spr = nil
end

function V.updateForPage(p)
   if V.texts[p] == nil then
	  return
   end
   V.free()
   V.page = p
   local sbox = Text.textbox(V.texts[V.page], 1, SCREEN_WIDTH, SCREEN_HEIGHT, {255,255,255,255})
   V.tex = Surface.textureFrom(sbox)
   V.spr = Sprite.new(V.tex, 0,0,SCREEN_WIDTH, SCREEN_HEIGHT,0,0)
   Surface.destroy(sbox)
end

function V.Update()
   --Update = static.quit
   V.spr:draw(0,0)
end

function V.End()
   V.free()
   V.stext = nil
end

function V.KeyDown(key)
   if key == KEY_ESCAPE then
	  static.quit()
   elseif key == KEY_UP then
	  V.updateForPage(V.page - 1)
   elseif key == KEY_DOWN then
	  V.updateForPage(V.page + 1)
   elseif key == KEY_LEFT then
	  V.updateForPage(V.page - 1)
   elseif key == KEY_RIGHT then
	  V.updateForPage(V.page + 1)
   end
end

Util.try(isMain, V)
