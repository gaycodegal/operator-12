return {
   tilesets={
      {
	 name = "heads",
	 tilewidth = 56,
	 tileheight = 56,
	 spacing = 0,
	 margin = 0,
	 image = "headsprites.png",
	 imagewidth = 168,
	 imageheight = 168,
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
	 tilecount = 9,
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
	    },
	    {
	       id = 6,
	       properties = {
		  ["color"] = "ffffff00"
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
	 imageheight = 168,
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
	 tilecount = 9,
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
	    },
	    {
	       id = 6,
	       properties = {
		  ["color"] = "00000000"
	       }
	    }
	 }
      }
   },
   slugs={
      test = {
	 tiles = {1,10},
	 stats={
	    moves = 5,
	    maxsize = 5,
	    skills={
	       {skill="Damage",
		range=1,
		damage=2
	       },
	       {skill="Flip",
		range=6
	       },
	       {skill="Heal",
		range=3,
		heal=10
	       }
	    }
	 }
      },
      test2 = {
	 tiles = {4, 13},
	 stats={
	    moves = 3,
	    maxsize = 3,
	    skills={
	       {skill="Damage",
		range=4,
		damage=1
	       }
	    }
	 }
      },
      spawner={
	 tiles={7,7},
	 stats={
	    moves = 0,
	    maxsize = 0,
	    skills={
	       {skill="Spawn",
		range=0
	       }
	    }
	 }
      }	  
   }
}
