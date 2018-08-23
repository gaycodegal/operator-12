require("util")
local isMain = Util.isMain()
require("ui/UIElement")
require("ui/ListButton")
require("ui/TextBox")
Dialogue = Class()
local D = Dialogue

--[[--
   Dialogue - basic ui for textual interactions with the story,
   other npcs and such

   @param dialogue Tree of currently loaded dialogue
   @param point Entry point into `dialogue` tree

   @return new boy
]]
function Dialogue.new(dialogue, point)
   local self = New(D)
   self.next = function () D.next(self) end
   self.buttons = ListButton.new("dialogue",{self.next},{"Next"},60,10,3)
   
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

--[[--
   fetches the text from a dialogue at a point

   @param dialogue 
   @param point 

   @return text
]]
function Dialogue:fetchText(dialogue, point)
   return dialogue[point].text
end

--[[--
   go to the next bit of unread text
]]
function Dialogue:next()
   self.textbox:next()
end

--[[--
   draw the dialogue
]]
function Dialogue:draw()
   self.buttons:draw()
   self.textbox:draw()
end

--[[--
   resize that boy
]]
function Dialogue:resize()
   UIElement.recalc(self.scene)
   self.buttons:resize()
   self.textbox:resize()
end

--[[--
   destroy the boy
]]
function Dialogue:destroy()
   self.buttons:destroy()
   self.textbox:destroy()
end

--[[
   start
]]
function Dialogue.Start()
   D.test = Dialogue.new({
		 catpoint={text="cats"}
						 }, "catpoint")
end

--[[
   updato
]]
function Dialogue.Update()
   --Update=static.quit
   D.test:draw()
end

--[[
   resizando

   @param w 
   @param h 
]]
function Dialogue.Resize(w,h)
   SCREEN_WIDTH, SCREEN_HEIGHT = w,h
   local x = D.test
   D.test:resize()
end

--[[
   end
]]
function Dialogue.End()
   D.test:destroy()
end

Util.try(isMain, D)
