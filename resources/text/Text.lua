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
   if w <= width and best < curi then
	  return curi
   end
   return best
end

-- figures out how much text can go on a line
-- up to width pix long
function Text.charsInLineRev(text, width)
   local len = #text
   local best = 0
   local mini = 1
   local maxi = len
   local curi = len, w
   local v
   while mini <= maxi do
	  curi = (mini + maxi) // 2
	  v = len - curi
	  w = TTF.size(string.sub(text, curi, len))
	  if w < width then
		 if best < v then
			best = v
		 end
		 maxi = curi - 1
	  elseif w > width then
		 mini = curi + 1
	  else
		 return v
	  end
   end
   w = TTF.size(string.sub(text, 1, curi))
   if w <= width and best < v then
	  return v
   end
   return best
end

function Text.sub(text, n)
   return string.sub(text, 1, n)
end

function Text.subRev(text, n)
   return string.sub(text, n, #text)
end

function Text.textbox(text, align, w, h, c, charsInLine, sub)
   sub = sub or Text.sub
   charsInLine = charsInLine or Text.charsInLine
   local x, th = TTF.size("M")
   h = h // th
   local s = Surface.newBlank(w, h * th)
   local s2, y, tmp, l
   local len = 0
   for i = 1,h do
	  x = Text.charsInLine(text, w)
	  if x == 0 then
		 break
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
		 s2 = TTF.surface(tmp, c[1],c[2],c[3],c[4])
		 if align == 1 then -- left align
			Surface.blit(s, s2,0,(i-1)*th)
		 elseif align == 2 then -- center align
			x = Surface.size(s2)
			Surface.blit(s, s2,(w - x) // 2,(i-1)*th)
		 elseif align == 3 then -- right
			x = Surface.size(s2)
			Surface.blit(s, s2,w-x,(i-1)*th)			 
		 end
		 Surface.destroy(s2)
		 l = i
	  end
	  s2 = nil
   end
   return s, len, l * th
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
