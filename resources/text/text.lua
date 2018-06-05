Text = {}

-- figures out how much text can go on a line
-- up to width pix long
function Text.charsInLine(text, width)
   local len = #text
   local best = 0
   local mini = 1
   local maxi = len
   local curi = len, w
   while mini <= maxi do
	  curi = (mini + maxi) // 2
	  w = TTF.size(string.sub(text, 1,curi))
	  if w < width then
		 if best < curi then
			best = curi
		 end
		 mini = curi + 1
	  elseif w > width then
		 maxi = curi - 1
	  else
		 return curi
	  end
   end
   w = TTF.size(string.sub(text, 1, curi))
   if w <= width and curi > best then
	  return curi
   end
   return best
end

function Text.textbox(text, w, h, r,g,b,a)
   local x, th = TTF.size("M")
   h = h // th
   local s = Surface.newBlank(w, h * th)
   local s2, y, tmp
   local len = 0
   for i = 1,h do
	  x = Text.charsInLine(text, w)
	  if x == 0 then
		 return s
	  end
	  y = string.find(text,"\n",1,true)
	  if y and y < x then
		 tmp = string.sub(text,1,y-1)
		 text = string.sub(text,y+1)
		 len = len + y
	  else
		 tmp = string.sub(text,1,x)
		 text = string.sub(text,x+1)
		 len = len + x
	  end
	  if #tmp > 0 then
		 s2 = TTF.surface(tmp, r,g,b,a)
		 Surface.blit(s, s2,0,(i-1)*th)
		 Surface.destroy(s2)
	  end
	  s2 = nil
   end
   return s, len
end

function Text.charsInTextbox(text, w, h)
   local x, th = TTF.size("M")
   h = h // th
   local s2, y, tmp
   local len = 0
   for i = 1,h do
	  x = Text.charsInLine(text, w)
	  if x == 0 then
		 return len
	  end
	  y = string.find(text,"\n",1,true)
	  if y and y < x then
		 tmp = string.sub(text,1,y-1)
		 text = string.sub(text,y+1)
		 len = len + y
	  else
		 tmp = string.sub(text,1,x)
		 text = string.sub(text,x+1)
		 len = len + x
	  end
   end
   return len
end
