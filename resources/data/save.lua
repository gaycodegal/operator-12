do
   local function str(x)
	  local t = type(x)
	  if t == "table" then
		 return table.tostring(x)
	  elseif t == "string" then
		 return string.format("%q", s)
	  else
		 return tostring(x)
	  end
   end

   function table.tostring(tbl)
	  local data = {"{"}
	  local len = #tbl
	  local c = false
	  for i = 1,len do
		 if c then
			table.insert(data,",")
		 end
		 c = true
		 table.insert(data,str(tbl[i]))
	  end
	  local t 
	  for k,v in pairs(tbl) do
		 t = type(k)
		 if t == "number" then
			if k < 1 or k > len or k ~= k // 1 then
			   if c then
				  table.insert(data,",")
			   end
			   c = true
			   table.insert(data,"["..tostring(k).."]=")
			   table.insert(data,str(v))
			end
		 elseif t == "string" then
			if c then
			   table.insert(data,",")
			end
			c = true
			table.insert(data,"["..string.format("%q", k).."]=")
			table.insert(data,str(v))
		 else
			if c then
			   table.insert(data,",")
			end
			c = true
			table.insert(data,"["..tostring(k).."]=")
			table.insert(data,str(v))
		 end
	  end
	  table.insert(data, "}")
	  return table.concat(data)
   end
end
if not Start then
   function Start()
	  file = io.open("asdf.lua","wb")
	  file:write("return " .. table.tostring({nil,true,false,2,"3",a={["as\n\r\tdf"]=12,b={"bolb", c={"cat",d={"dog",e="egg"}}}},[0]=1234,[0.4]=0.3}))
	  file:close()
   end
end
