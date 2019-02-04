ListButton = {}

function ListButton.init(elem, fns, texts, height, space, align)
   space = space or 0
   height = height or 30
   local nb = #fns
   local cells = {}
   local buttons = {}
   local spacer = {size={space, "dp"}}
   local btn = {size={height,"dp"}}
   table.insert(cells, {size={1, "w"}})
   -- have to insert buttons by index due to #tbl not counting nils
   local bi = 1
   buttons[bi] = nil
   bi = bi + 1
   for i = 1, nb do
	  table.insert(cells, btn)
	  local b = UIButton.new({})
	  b:setData({
			color="0000ff",
			text=texts[i],
			click=fns[i],
	  })
	  buttons[bi] = b
	  bi = bi + 1
	  if i ~= nb then
		 buttons[bi] = nil
		 bi = bi + 1
		 table.insert(cells, spacer)
	  end
   end
   buttons.n = nb * 2 + 1 -- #buttons + #spaces + 2
   table.insert(cells, {size={1, "w"}})
   buttons[bi] = nil
   bi = bi + 1
   elem:setData(cells, buttons)
end

