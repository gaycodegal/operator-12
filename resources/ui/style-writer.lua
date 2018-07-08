require("ui/UIElement")
--[=[
Takes stylesheet lua files and converts
them into functions that will calculate
their size automatically. Useful for when
you need elements that can respond to
screen resizing.

usage:
./main ui/style-writer <input.lua> <output.lua>
]=]
function Start(argc, argv)
   if argc < 2 then
	  print("usage:")
	  print(argv[1] .. " <input.lua> <output.lua>")
	  return nil
   end
   generateStyle(argv[3], dofile(argv[2]))
   print("done")
end

function generateStyle(fname, style)
   local handle = io.open(fname, "w")
   handle:write("return {\n")
   for k,v in pairs(style) do
	  handle:write(k .. " = function(self)\nlocal d = self.d\n")
	  if v.vars then
		 for i,var in ipairs(v.vars) do
			handle:write("local " .. var .. "\n")
		 end
	  end
	  todo = {"h", "w", "x", "y"}
	  for i,var in ipairs(todo) do
		 local val = v[var] or 0
		 handle:write("self." .. var .. " = " .. v[var] .. "\n")
	  end
	  handle:write("end,\n")
   end
   handle:write("}")
   handle:close()
end
