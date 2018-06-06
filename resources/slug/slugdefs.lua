return {
   tilesets={{
		 name = "heads",
		 tilewidth = 56,
		 tileheight = 56,
		 spacing = 0,
		 margin = 0,
		 image = "headsprites.png",
		 imagewidth = 168,
		 imageheight = 112,
		 tileoffset = {
			x = 0,
			y = 0
		 },
		 grid = {
			orientation = "orthogonal",
			width = 56,
			height = 56
		 },
		 properties = {},
		 terrains = {},
		 tilecount = 6,
		 tiles = {
			{
			   id = 0,
			   properties = {
				  ["color"] = "008cff"
			   }
			},
			{
			   id = 1,
			   properties = {
				  ["color"] = "008cff"
			   }
			},
			{
			   id = 2,
			   properties = {
				  ["color"] = "008cff"
			   }
			},
			{
			   id = 3,
			   properties = {
				  ["color"] = "ff7200"
			   }
			},
			{
			   id = 4,
			   properties = {
				  ["color"] = "ff7200"
			   }
			},
			{
			   id = 5,
			   properties = {
				  ["color"] = "ff7200"
			   }
			}
		 }
			 },
	  {
		 name = "tails",
		 tilewidth = 56,
		 tileheight = 56,
		 spacing = 0,
		 margin = 0,
		 image = "tailsprites.png",
		 imagewidth = 168,
		 imageheight = 112,
		 tileoffset = {
			x = 0,
			y = 0
		 },
		 grid = {
			orientation = "orthogonal",
			width = 56,
			height = 56
		 },
		 properties = {},
		 terrains = {},
		 tilecount = 6,
		 tiles = {
			{
			   id = 0,
			   properties = {
				  ["color"] = "008cff"
			   }
			},
			{
			   id = 1,
			   properties = {
				  ["color"] = "008cff"
			   }
			},
			{
			   id = 2,
			   properties = {
				  ["color"] = "008cff"
			   }
			},
			{
			   id = 3,
			   properties = {
				  ["color"] = "ff7200"
			   }
			},
			{
			   id = 4,
			   properties = {
				  ["color"] = "ff7200"
			   }
			},
			{
			   id = 5,
			   properties = {
				  ["color"] = "ff7200"
			   }
			}
		 }
	  }
   },
   slugs={
	  test = {
		 tiles = {1,7},
		 stats={
			moves = 5,
			range = 1,
			damage = 1
		 }
	  },
	  test2 = {
		 tiles = {4, 10},
		 stats={
			moves = 3,
			range = 4,
			damage = 1
		 }
	  },
	  spawner={
		 tiles={3,3},
		 stats={
			moves = 0,
			range = 0,
			damage = 0
		 }
	  }
	  
   }
}
