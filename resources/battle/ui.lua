require("util")
require("ui/ListButton")
require("ui/TextBox")
require("money/ui")
BattleUI = {}
local B = BattleUI

--[[--
   Makes the list button and text box that is gonna be displaying the slug's stats
]]
function BattleUI.init()
   B.cells = dofile("battle/layout.lua")
   local named = Flex.getNamed(B.cells.children)
   named.actions.size[1] = ListButton.heightOf(3, 30, 10)
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
   ListButton.init(B.named.actions,
				   fns,
				   texts,
				   30, 10)
   B.named.info:setData({text=B.getSlugText(slug)})
   --B.actions:setButtons(fns,texts)
   --B.t:resize()
end

function BattleUI.setButtons(fns, texts)
   ListButton.init(B.named.actions,
				   fns,
				   texts,
				   30, 10)
end

--[[--
   resize shit
]]
function BattleUI.resize()
   B.rects = Flex.calculateRects(B.cells, {0,0,SCREEN_WIDTH,SCREEN_HEIGHT})
   Flex.setRects(B.views, B.rects)
end

--[[--
   draw shit
]]
function BattleUI.draw()
   Flex.draw(B.views)
end

--[[--
   destroy shit
]]
function BattleUI.destroy()
   Flex.destroy(B.views)
   B.slug = nil
   B.scene = nil
   B.named = nil
   B.views = nil
   B.cells = nil
   B.rects = nil
end

--[[--
   handle click

   @param x 
   @param y 

   @return true if click should be consumed. false otherwise
]]
function BattleUI.MouseDown(x, y)
   return Flex.click({x, y}, B.views, B.rects)
end
