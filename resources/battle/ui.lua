require("util")
require("ui/TextBox")
BattleUI = {}
local B = BattleUI

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
   B.actions.child.e = {bg={200,0,0,255}}
   B.t = TextBox.new({text="testing testing 123", layout=B.actions.child})
end

function BattleUI.getSlugText(slug)
   local s = slug.stats
   return table.concat({"moves: ", tostring(s.moves),"\n",
						"max size: ", tostring(s.maxsize),"\n"})
		   
		   
end

function BattleUI.fn(i, slug)
   return function ()
	  slug.action = slug.stats.skills[i]
	  return true
   end
end

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

function BattleUI.draw()
   B.actions:draw()
   B.t:draw()
end

function BattleUI.destroy()
   B.actions:destroy()
   B.t:destroy()
   B.slug = nil
   B.scene = nil
   B.named = nil
   B.actions = nil
   B.t = nil
end

function BattleUI.MouseDown(x, y)
   local b = B.actions:which(x,y)
   if b then
	  return b:click()
   end
   return false
end
