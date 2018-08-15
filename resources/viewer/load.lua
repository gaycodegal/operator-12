require("util")
local isMain = Util.isMain()
require("text/Text")
Viewer = {}
local V = Viewer

--[[--
   read all docs in a dir, and concat them together

   @param dir 
   @param sep 

   @return full text
]]
function Viewer.readAll(dir, sep)
   local texts = {}
   local sources = listdir(dir)
   for i, source in ipairs(sources) do
	  local f = io.open(dir..source, "r")
	  texts[i] = f:read("a")
	  f:close()
   end
   return table.concat(texts, sep)
end

--[[--
   view all things in a dir

   @param argc 
   @param argv[2] dir
   @param argv[3] sep
]]
function Viewer.Start(argc, argv)
   if argc < 3 then	
	  argv = {"viewer/load", "licenses/", "\n\n"}
   end
   V.stext = V.readAll(argv[2], argv[3])
   V.reset()
end

--[[
   resize

   @param w 
   @param h 

   @return
]]
function Viewer.Resize(w, h)
   SCREEN_WIDTH = w
   SCREEN_HEIGHT = h
   V.reset()
   if map then map:recenter() end
end

--[[
   reset viewer
]]
function Viewer.reset()
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

--[[
   free viewer's stuff
]]
function Viewer.free()
   if V.tex then
	  Texture.destroy(V.tex)
   end
   V.tex = nil
   if V.spr then
	  V.spr:destroy()
   end
   V.spr = nil
end

--[[
   show page `p` of content

   @param p 
]]
function Viewer.updateForPage(p)
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

--[[
   draw shit
]]
function Viewer.Update()
   --Update = static.quit
   V.spr:draw(0,0)
end

--[[
   destroy shit
]]
function Viewer.End()
   V.free()
   V.stext = nil
end

--[[
   move around pages

   @param key 
]]
function Viewer.KeyDown(key)
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
