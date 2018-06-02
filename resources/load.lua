require("battle/map")
require("slug/slug")

function makeGlobal(x)
   for k,v in pairs(x) do
      rawset(_G, k, v)
   end
end

makeGlobal(Game)
function Start()
   Slug.load()
   tile, tilew, tileh = Texture.new("images/tile.png")
   slug = Slug.new({sprites="test", segs={{2,2}, {2,1}, {1,1}}})
   map = Map.new()
   
end

function Update()
   --Update = static.quit
   map:draw()
   slug:draw()
   static.wait(math.floor(1000/60))
end

--Update = nil

function End()
   Slug.unload()
   Texture.destroy(tile)
   map:destroy()
   slug:destroy()
   print("goodbye")
end

--[[loadScene()
   endScene()]]

