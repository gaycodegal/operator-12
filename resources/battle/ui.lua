require("util")
require("ui/ListButton")
require("ui/TextBox")
require("money/ui")
BattleUI = {bHeight=30, bSpace=10}
local B = BattleUI

--[[--
   Makes the list button and text box that is gonna be displaying the slug's stats
]]
function BattleUI.init()
   B.cells = Flex.load("battle/layout.lua")
   local named = Flex.getNamed(B.cells.children)
   named.actions.size[1] = ListButton.heightOf(3, B.bHeight, B.bSpace) + B.bSpace + B.bHeight // 2
   B.rects = Flex.calculateRects(B.cells, {0,0,SCREEN_WIDTH,SCREEN_HEIGHT})
   B.views = Flex.new(B.cells, B.rects)
   B.named = Flex.getNamed(B.views)
   BattleUI.setButtons({}, {})
   local money = MoneyUI.new(B.named)
   player.money:listen(money)
end

--[[--
   Get the text that our actions List is supposed to display as the slug's overall info

   @param slug Slug we need info of.

   @return said text
]]
function BattleUI.getSlugText(slug)
   local s = slug.stats
   return table.concat({"moves: ", tostring(s.moves),"\n",
			"max size: ", tostring(s.maxsize),"\n"})
end

--[[--
   On actions click closure generater

   sets slug attack mode; moves slug onto attack phase

   @param i Index of skill
   @param slug slug in focus

   @return a on click closure
]]
function BattleUI.fn(i, slug)
   return function ()
      slug.action = slug.stats.skills[i]
      Player.beginAttack()
      return true
   end
end

--[[--
   set slug in focus

   @param slug our focus
]]
function BattleUI.setSlug(slug)
   local s = slug.stats
   local fns = {}
   local texts = {}
   for i = 1,#slug.stats.skills do
      table.insert(fns, B.fn(i, slug))
      table.insert(texts, slug.stats.skills[i].skill)
   end
   B.slug = slug
   B.setButtons(fns, texts)
   B.named.info:setData({text=B.getSlugText(slug)})
   --B.actions:setButtons(fns,texts)
   --B.t:resize()
end

function BattleUI.setButtons(fns, texts, context)
   ListButton.init(B.named.actions,
				   fns,
				   texts,
				   B.bHeight, B.bSpace, context)
end

--[[--
   resize things
]]
function BattleUI.resize()
   B.rects = Flex.calculateRects(B.cells, {0,0,SCREEN_WIDTH,SCREEN_HEIGHT})
   Flex.setRects(B.views, B.rects)
end

--[[--
   draw things
]]
function BattleUI.draw()
   Flex.draw(B.views)
end

--[[--
   destroy things
]]
function BattleUI.destroy()
   Flex.destroy(B.views)
   B.slug = nil
   B.scene = nil
   B.named = nil
   B.views = nil
   B.cells = nil
   B.rects = nil
   B.map = nil
   B.draggable = nil
end

--[[
   standard Flex mouse down

   @param x 
   @param y 
]]
function BattleUI.MouseDown(x,y)
   Flex.mouseDown(B, x, y)
   if B.draggable then
	  return true
   end
   B.draggable = B.map
   return true
end

--[[
   standard Flex mouse move

   @param x 
   @param y 
]]
function BattleUI.MouseMove(x,y)
   Flex.mouseMove(B, x, y)
end

--[[
   standard Flex mouse up

   @param x 
   @param y 
]]
function BattleUI.MouseUp(x,y)
   return Flex.mouseUp(B, x, y)
end
