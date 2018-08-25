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
   self.dialogue = dialogue
   self.point = point
   self.buttons = ListButton.new("dialogue",{self.next},{"Next"},60,10,3)
   
   local style = getStyles({"list-button", "screen"})
   local named, scene = UIElement.getNamed(
	  {{s="screen",c={self.buttons.container}}}, style)
   self.buttons:init(named)
   self.scene = scene
   self.buttons.child.e = {}
   self.textbox = TextBox.new({
		 text=self:fetchText(),
		 layout=self.buttons.child})
   return self
end

--[[--
   fetches the text from a dialogue at a point

   @return text
]]
function Dialogue:fetchText()
   return self.dialogue[self.point].text
end

--[[--
   fetches the point's node from a dialogue

   @return node {text=,buttons={fns=,texts=}}
]]
function Dialogue:fetch()
   return self.dialogue[self.point]
end

--[[--
   go to the next bit of unread text
   if all text is read, display the current dialogue node's buttons
]]
function Dialogue:next()
   table.print(self)
   print("a")
   if self.textbox:next() then
	  print("B")
	  local buttons = self:fetch().buttons
	  if buttons then
		 print("C")
		 self.buttons:setButtons(buttons.fns, buttons.texts)
	  end
   end
end

function Dialogue:go(dialogue, point)
   self.dialogue = dialogue
   self.point = point
   print(self:fetchText())
   self.textbox:setText(self:fetchText())
   self.buttons:setButtons({self.next},{"Next"})
end

--[[--
   draw the dialogue
]]
function Dialogue:draw()
   self.buttons:draw()
   self.textbox:draw()
end

function Dialogue:click(x,y)
   local b = self.buttons:which(x,y)
   if b then
	  b.click(self)
	  return true
   end
   return false
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

function Dialogue.open(name)
   return dofile("dialogue/story/"..name..".lua")
end

--[[
   start
]]
function Dialogue.Start()
   D.test = Dialogue.new(Dialogue.open("test"), "main-entry")
end

function Dialogue.MouseDown(x,y)
   if D.test then
	  D.test:click(x,y)
   end
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
   D.test = nil
end

Util.try(isMain, D)
