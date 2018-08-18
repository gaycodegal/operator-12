require("util")
require("ui/ListButton")
require("ui/TextBox")
BattleUI = {}
local B = BattleUI

--[[--
   Makes the list button and text box that is gonna be displaying the slug's stats
]]
function BattleUI.init()
   B.actions = ListButton.new(
	  "actions",
	  {},
	  {},
	  30, 10, 3)
   B.scene = {{s="screen",c={
				  {s="actionsPanel", c={B.actions.container}}
			 }}}
   B.named, B.scene = UIElement.getNamed(
	  B.scene, getStyles({"screen", "list-button", "battle-ui"}))
   B.actions:init(B.named)
   B.actions.child.e = {bg={0,0,0,128}}
   B.t = TextBox.new({text="testing testing 123", layout=B.actions.child})
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
   B.t:setText(B.getSlugText(slug))
   B.actions:setButtons(fns,texts)
   B.t:resize()
end

--[[--
   resize shit
]]
function BattleUI.resize()
   UIElement.recalc(B.scene)
   B.actions:resize()
   B.t:resize()
end

--[[--
   draw shit
]]
function BattleUI.draw()
   B.actions:draw()
   B.t:draw()
end

--[[--
   destroy shit
]]
function BattleUI.destroy()
   B.actions:destroy()
   B.t:destroy()
   B.slug = nil
   B.scene = nil
   B.named = nil
   B.actions = nil
   B.t = nil
end

--[[--
   handle click

   @param x 
   @param y 

   @return true if click should be consumed. false otherwise
]]
function BattleUI.MouseDown(x, y)
   local b = B.actions:which(x,y)
   if b then
	  return b:click()
   end
   return false
end
