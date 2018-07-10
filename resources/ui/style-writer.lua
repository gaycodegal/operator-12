require("ui/UIElement")
require("data/save")
--[=[
Takes stylesheet lua files and converts
them into functions that will calculate
their size automatically. Useful for when
you need elements that can respond to
screen resizing.

usage:
./main ui/style-writer <name>
]=]
function Start(argc, argv)
   if argc < 2 then
	  print("usage:")
	  print(argv[1] .. " <name>")
	  return nil
   end
   generateStyle("ui/styles/"..argv[2]..".style.lua", dofile("ui/styles/"..argv[2]..".lua"))
   print("done")
end

function generateStyle(fname, style)
   local handle = io.open(fname, "w")
   handle:write("return {\n")
   for k,v in pairs(style) do
	  local e = table.tostring(v.e or {})
	  handle:write(k .. " = {e=")
	  handle:write(e)
	  handle:write(",\nresize=function(self)\nlocal d = self.d\n")
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
	  handle:write("end\n},\n")
   end
   handle:write("}")
   handle:close()
end
