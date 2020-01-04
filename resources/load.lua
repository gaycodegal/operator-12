require("util")
local isMain = Util.isMain()
Demo = {}
local D = Demo
D.box = {
      -1, 1, 1, -- Top left
   1, 1, 1, -- Top right
   1,-1, 1, -- Bottom right 
      -1,-1, 1
} -- Bottom left
D.colors = {
   0.0, 1.0, 0.0, 1.0, -- Top left
   1.0, 1.0, 0.0, 1.0, -- Top right
   1.0, 0.0, 0.0, 1.0, -- Bottom right 
   0.0, 0.0, 1.0, 1.0, -- Bottom left
}

positionAttr = 0
colorAttr = 1
--[[
   draw things
]]
function Demo.Start()
   D.shader = Shader.new("shaders/shader.vert", "shaders/shader.frag")
   D.shader:use()
   box = FloatArray.new(#D.box)
   for i = 1, #D.box do
      box[i - 1] = D.box[i]
   end
   colors = FloatArray.new(#D.colors)
   for i = 1, #D.colors do
      colors[i - 1] = D.colors[i]
   end

   vb_point = GL.genBuffer()
   vb_color = GL.genBuffer()
   va = GL.genVertexArray()
   
   GL.bindVertexArray(va)

   GL.bindBuffer(GL_ARRAY_BUFFER, vb_point)
   GL.bufferData(GL_ARRAY_BUFFER, #box * GLFLOAT_SIZE, box, GL_STATIC_DRAW)
   -- each point is of size 3
   GL.vertexAttribPointer(positionAttr, 3, GL_FLOAT, false, 0, 0)
   GL.enableVertexAttribArray(positionAttr)

   GL.bindBuffer(GL_ARRAY_BUFFER, vb_color)
   GL.bufferData(GL_ARRAY_BUFFER, #colors * GLFLOAT_SIZE, colors, GL_STATIC_DRAW)
   -- each color is of size 4
   GL.vertexAttribPointer(colorAttr, 4, GL_FLOAT, false, 0, 0)

   GL.bindBuffer(GL_ARRAY_BUFFER, 0)

end

--[[
   draw things
]]
function Demo.Update()
   --Update=static.quit
   GL.enableVertexAttribArray(colorAttr)
   -- Equivalent of LINE_LOOP for triangles
   GL.drawArrays(GL_TRIANGLE_FAN, 0, 4)
end

--[[
   destroy things
]]
function Demo.End()
   D.shader:destroy()
   colors:destroy()
   box:destroy()
end

Util.try(isMain, D)
