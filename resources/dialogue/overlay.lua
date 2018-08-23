require("util")
local isMain = Util.isMain()
require("ui/UIElement")
require("ui/ListButton")
require("ui/TextBox")
Dialogue = {}
local D = Dialogue

--[[--
@param dialogue Dialogue 
]]
function Dialogue.new(dialogue, point)
   self = {}--New(Dialogue)
   setmetatable(self, D)
   self.next = function () D.next(self) end
   local x = ListButton.new("dialogue",{self.next},{"Next"},60,10,3)
   self.buttons = x
   
   local style = getStyles({"list-button", "screen"})
   local named, scene = UIElement.getNamed(
	  {{s="screen",c={self.buttons.container}}}, style)
   self.buttons:init(named)
   self.scene = scene
   self.dialogue = named[1]
   self.buttons.child.e = {}
   self.textbox = TextBox.new({
		 text=D:fetchText(dialogue, point),
		 layout=self.buttons.child})
   return self
end

function Dialogue:fetchText(dialogue, point)
   return dialogue[point].text
end

function Dialogue:next()
   self.textbox:next()
end

function Dialogue:draw()
   self.buttons:draw()
   self.textbox:draw()
end

function Dialogue:resize()
   UIElement.recalc(self.scene)
   self.buttons:resize()
   self.textbox:resize()
end

function Dialogue:destroy()
   self.buttons:destroy()
   self.textbox:destroy()
end

function Dialogue.Start()
   D.test = Dialogue.new({
		 catpoint={text="cats"}
   }, "catpoint")
end

function Dialogue.Update()
   --Update=static.quit
   D.test:draw()
end

function Dialogue.Resize(w,h)
   SCREEN_WIDTH, SCREEN_HEIGHT = w,h
   Dialogue:resize()
end

function Dialogue.End()
   D.test:destroy()
end

Util.try(isMain, D)
