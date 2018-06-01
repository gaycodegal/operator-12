require("battle/map")

function makeGlobal(x)
   for k,v in pairs(x) do
      rawset(_G, k, v)
   end
end

makeGlobal(Game)
function Start()
   t = Texture.new("turtle.png")
   map = Map.new()
end

function Update()
   map:draw()
   static.wait(math.floor(1000/60))
end

--Update = nil

function End()
   Texture.destroy(t)
   map:destroy()
   print("goodbye")
end

--[[loadScene()
   endScene()]]

