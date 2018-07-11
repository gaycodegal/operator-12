do
   local f = io.open("../README.md", "r")
   local text = f:read("a")
   f:close()
   return text
end
