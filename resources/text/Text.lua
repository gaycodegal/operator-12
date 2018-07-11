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

function Text.textbox(text, align, w, h, c, direction)
   direction = direction or 1
   local charsInLine = Text.charsInLine
   if direction == 2 then
	  charsInLine = Text.charsInLineRev
   end
   local x, th = TTF.size("M")
   h = h // th
   local s = Surface.newBlank(w, h * th)
   local s2, y, tmp
   local l = 0
   local len = 0
   local spl
   for i = 1,h do
	  x = Text.charsInLine(text, w)
	  if x == 0 then
		 break
	  end
	  y = nil
	  if direction == 2 then
		 y = string.find(string.reverse(text),"\n",1,true)
	  else
		 y = string.find(text,"\n",1,true)
	  end
	  if y and y < x then
		 spl = y
		 if direction == 2 then
			spl = #text - y
		 end
		 if direction == 2 then
			tmp = string.sub(text,spl+2,-1)
			text = string.sub(text,1,spl)
		 else
			tmp = string.sub(text,1,spl-1)
			text = string.sub(text,spl+1,-1)
		 end
		 len = len + y
	  else
		 spl = x
		 if direction == 2 then
			spl = #text - x
		 end
		 tmp = string.sub(text,1,spl)
		 text = string.sub(text,spl+1,-1)
		 if direction == 2 then
			tmp, text = text, tmp
			if string.sub(text, -1, -1) == "\n" then
			   text = string.sub(text, 1, -2)
			end
		 else
			if string.sub(text, 1, 1) == "\n" then
			   text = string.sub(text, 2, -1)
			end
		 end
		 len = len + x
	  end
	  if #tmp > 0 then
		 y = (i-1)*th
		 if direction == 2 then
			y = (h-i)*th
		 end
		 s2 = TTF.surface(tmp, c[1],c[2],c[3],c[4])
		 if align == 1 then -- left align
			Surface.blit(s, s2,0,y)
		 elseif align == 2 then -- center align
			x = Surface.size(s2)
			Surface.blit(s, s2,(w - x) // 2,y)
		 elseif align == 3 then -- right
			x = Surface.size(s2)
			Surface.blit(s, s2,w-x,y)
		 end
		 Surface.destroy(s2)
		 l = i
	  end
	  s2 = nil
   end
   s2 = Surface.newBlank(w, h * th)
   if direction == 2 then
	  Surface.blit(s2, s, 0, -(h - l) * th)
   else
	  Surface.blit(s2, s, 0, 0)
   end
   Surface.destroy(s)
   return s2, len, l * th
end

function Text.charsInTextbox(text, w, h, direction)
   direction = direction or 1
   local charsInLine = Text.charsInLine
   if direction == 2 then
	  charsInLine = Text.charsInLineRev
   end
   local x, th = TTF.size("M")
   h = h // th
   local y, tmp
   local l = 0
   local len = 0
   local spl
   for i = 1,h do
	  x = Text.charsInLine(text, w)
	  if x == 0 then
		 break
	  end
	  y = nil
	  if direction == 2 then
		 y = string.find(string.reverse(text),"\n",1,true)
	  else
		 y = string.find(text,"\n",1,true)
	  end
	  if y and y < x then
		 spl = y
		 if direction == 2 then
			spl = #text - y
		 end
		 if direction == 2 then
			tmp = string.sub(text,spl+2,-1)
			text = string.sub(text,1,spl)
		 else
			tmp = string.sub(text,1,spl-1)
			text = string.sub(text,spl+1,-1)
		 end
		 len = len + y
	  else
		 spl = x
		 if direction == 2 then
			spl = #text - x
		 end
		 tmp = string.sub(text,1,spl)
		 text = string.sub(text,spl+1,-1)
		 if direction == 2 then
			tmp, text = text, tmp
			if string.sub(text, -1, -1) == "\n" then
			   text = string.sub(text, 1, -2)
			end
		 else
			if string.sub(text, 1, 1) == "\n" then
			   text = string.sub(text, 2, -1)
			end
		 end
		 len = len + x
	  end
	  if #tmp > 0 then
		 l = i
	  end
   end
   return len, l * th
end
