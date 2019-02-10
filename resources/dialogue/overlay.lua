require("util")
local isMain = Util.isMain()
require("flex/flex")
Dialogue = Class()
Dialogue.bHeight = 60
Dialogue.bSpace = 10
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
   self.cells = Flex.load("dialogue/layout.lua")
   local named = Flex.getNamed(self.cells.children)
   named.actions.size[1] = ListButton.heightOf(3, self.bHeight, self.bSpace) + self.bSpace + self.bHeight // 2
   self.rects = Flex.calculateRects(self.cells, {0,0,SCREEN_WIDTH,SCREEN_HEIGHT})
   self.views = Flex.new(self.cells, self.rects)
   self.named = Flex.getNamed(self.views)
   self:setButtons({}, {})

   self:go(dialogue, point)
   return self
end

function Dialogue:setButtons(fns, texts)
   ListButton.init(self.named.actions,
				   fns,
				   texts,
				   self.bHeight,
				   self.bSpace,
				   self)
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
function Dialogue:next(b, c)
   self.named.actions:moveTo(0, 0)
   if self.named.textbox:next() then
	  local buttons = self:fetch().buttons
	  if buttons then
		 self:setButtons(buttons.fns, buttons.texts)
	  end
   end
end

--[[
Goes to a dialogue/point pair, loads dialogue

@param dialogue 
@param point 
]]
function Dialogue:go(dialogue, point)
   self.named.actions:moveTo(0, 0)
   self.dialogue = dialogue
   self.point = point
   self.named.textbox:setText(self:fetchText())
   self:setButtons({self.next},{"Next"})
end

--[[--
   draw the dialogue
]]
function Dialogue:draw()
   Flex.draw(self.views)
end

--[[
click on button

@param x 
@param y 

@return whether any button was clicked
]]
function Dialogue:click(x,y)
   return Flex.click({x, y}, self.views, self.rects)
end

--[[--
   resize that boy
]]
function Dialogue:resize()
   self.rects = Flex.calculateRects(self.cells, {0,0,SCREEN_WIDTH,SCREEN_HEIGHT})
   Flex.setRects(self.views, self.rects)
end

--[[--
   destroy the boy
]]
function Dialogue:destroy()
   Flex.destroy(self.views)
   self.rects = nil
   self.views = nil
   self.named = nil
   self.cells = nil
   self.point = nil
   self.dialogue = nil
end

--[[
open a dialogue file

@param name 

@return contents
]]
function Dialogue.open(name)
   return dofile("dialogue/story/"..name..".lua")
end

--[[
   start
]]
function Dialogue.Start()
   D.test = Dialogue.new(Dialogue.open("test"), "main-entry")
end

--[[
   standard Flex mouse down

   @param x 
   @param y 
]]
function Dialogue.MouseDown(x,y)
   Flex.mouseDown(D.test, x, y)
end

--[[
   standard Flex mouse move

   @param x 
   @param y 
]]
function Dialogue.MouseMove(x,y)
   Flex.mouseMove(D.test, x, y)
end

--[[
   standard Flex mouse up

   @param x 
   @param y 
]]
function Dialogue.MouseUp(x,y)
   Flex.mouseUp(D.test, x, y)
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
