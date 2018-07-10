require("util/static")
TextBox = Class()

function TextBox.new(self)
   setmetatable(self, TextBox)
   self.rect = self.layout:rect()
end
