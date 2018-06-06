return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "1.1.5",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 13,
  height = 13,
  tilewidth = 32,
  tileheight = 32,
  nextobjectid = 21,
  properties = {},
  tilesets = {
    {
      name = "tiles",
      firstgid = 1,
      filename = "tiles.tsx",
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      image = "tiles.png",
      imagewidth = 96,
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
      tilecount = 6,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "Tile Layer 1",
      x = 0,
      y = 0,
      width = 13,
      height = 13,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        3, 6, 3, 3, 3, 6, 6, 6, 3, 3, 3, 6, 3,
        6, 3, 0, 0, 0, 3, 3, 3, 0, 0, 0, 3, 6,
        3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3,
        3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3,
        3, 0, 0, 0, 3, 3, 3, 3, 3, 0, 0, 0, 3,
        3, 6, 6, 6, 3, 6, 3, 6, 3, 6, 6, 6, 3,
        3, 6, 6, 6, 3, 3, 3, 3, 3, 6, 6, 6, 3,
        3, 6, 6, 6, 3, 6, 3, 6, 3, 6, 6, 6, 3,
        3, 0, 0, 0, 3, 3, 3, 3, 3, 0, 0, 0, 3,
        3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3,
        3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3,
        6, 3, 0, 0, 0, 3, 3, 3, 0, 0, 0, 3, 6,
        3, 6, 3, 3, 3, 6, 6, 6, 3, 3, 3, 6, 3
      }
    },
    {
      type = "objectgroup",
      name = "slug",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 3,
          name = "Slug1",
          type = "test",
          shape = "point",
          x = 144,
          y = 147,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["index"] = 1,
            ["team"] = 1
          }
        },
        {
          id = 13,
          name = "Slug1",
          type = "test",
          shape = "point",
          x = 176,
          y = 146,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["index"] = 2
          }
        },
        {
          id = 17,
          name = "Slug2",
          type = "test2",
          shape = "point",
          x = 337,
          y = 181,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["index"] = 2
          }
        },
        {
          id = 18,
          name = "Slug2",
          type = "test2",
          shape = "point",
          x = 337,
          y = 211,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["index"] = 1,
            ["team"] = 2
          }
        },
        {
          id = 19,
          name = "spawner",
          type = "spawner",
          shape = "point",
          x = 209,
          y = 19,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
			 ["index"] = 1,
            ["spawner"] = true
          }
        },
        {
          id = 20,
          name = "spawner",
          type = "spawner",
          shape = "point",
          x = 209,
          y = 402,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["index"] = 2,
            ["spawner"] = true
          }
        }
      }
    }
  }
}
