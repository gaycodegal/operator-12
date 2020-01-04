require("util")
local isMain = Util.isMain()
Demo = {}
local D = Demo
D.box = {
      -0.9, 0.9, 0.9, -- Top left
   0.9, 0.9, 0.9, -- Top right
   0.9,-0.9, 0.9, -- Bottom right 
      -0.9,-0.9, 0.9 -- Bottom left
}
D.colors = {
   0.0, 1.0, 0.0, 1.0, -- Top left
   1.0, 1.0, 0.0, 1.0, -- Top right
   1.0, 0.0, 0.0, 1.0, -- Bottom right 
   0.0, 0.0, 1.0, 1.0, -- Bottom left
}
D.box.indices = {
   0, 1, 3, -- First triangle
   1, 2, 3, -- Second triangle
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
   indices = UIntArray.new(#D.box.indices)
   for i = 1, #D.box.indices do
      indices[i - 1] = D.box.indices[i]
   end

   vb_point = GL.genBuffer()
   vb_color = GL.genBuffer()
   eab = GL.genBuffer()
   va = GL.genVertexArray()
   
   GL.bindVertexArray(va)

   GL.bindBuffer(GL_ARRAY_BUFFER, vb_point)
   GL.bufferData(GL_ARRAY_BUFFER, box:bytes(), box, GL_STATIC_DRAW)
   -- each point is of size 3
   GL.vertexAttribPointer(positionAttr, 3, GL_FLOAT, false, 0, 0)
   GL.enableVertexAttribArray(positionAttr)

   GL.bindBuffer(GL_ARRAY_BUFFER, vb_color)
   GL.bufferData(GL_ARRAY_BUFFER, colors:bytes(), colors, GL_STATIC_DRAW)
   -- each color is of size 4
   GL.vertexAttribPointer(colorAttr, 4, GL_FLOAT, false, 0, 0)

   GL.bindBuffer(GL_ELEMENT_ARRAY_BUFFER, eab)
   GL.bufferData(GL_ELEMENT_ARRAY_BUFFER, indices:bytes(), indices, GL_STATIC_DRAW);
   
   GL.bindBuffer(GL_ARRAY_BUFFER, 0)

   mode = GL_FILL
end

--[[
   draw things
]]
function Demo.Update()
   --Update=static.quit
   GL.enableVertexAttribArray(colorAttr)
   -- Equivalent of LINE_LOOP for triangles
   --GL.drawArrays(GL_TRIANGLE_FAN, 0, 4)
   GL.bindBuffer(GL_ELEMENT_ARRAY_BUFFER, eab)
   GL.drawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0)

end

--[[
   destroy things
]]
function Demo.End()
   D.shader:destroy()
   colors:destroy()
   box:destroy()
   indices:destroy()
end

function Demo.KeyUp(key)
   if key == KEY_0 then
      if mode == GL_FILL then
	 mode = GL_LINE
      else
	 mode = GL_FILL
      end
      GL.polygonMode(GL_FRONT_AND_BACK, mode)
   end
   Util.KeyUp(key)
end

Util.try(isMain, D)
