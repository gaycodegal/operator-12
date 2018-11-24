return {
   version = "1.2",
   luaversion = "5.1",
   tiledversion = "1.2.1",
   name = "collectables",
   tilewidth = 32,
   tileheight = 32,
   spacing = 0,
   margin = 0,
   columns = 2,
   image = "collectables.png",
   imagewidth = 64,
   imageheight = 64,
   tileoffset = {
      x = 0,
      y = 0
   },
   grid = {
      orientation = "orthogonal",
      width = 32,
      height = 32
   },
   properties = {},
   terrains = {},
   tilecount = 4,
   tiles = {
      {
	 id = 0,
	 type = "money"
      },
      {
	 id = 1,
	 type = "goal"
      }
   }
}
