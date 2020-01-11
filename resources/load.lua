require("util")
local isMain = Util.isMain()
Demo = {}
local D = Demo
D.box = {
      -0.9, 0.9, 1, -- Top left
   0.9, 0.9, 1, -- Top right
   0.9,-0.9, 1, -- Bottom right 
      -0.9,-0.9, 1, -- Bottom left
}
D.tex = {
   0, 0, -- Bottom left
   1, 0, -- Top left
   1, 1, -- Top right
   0, 1, -- Bottom right
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

--[[
   draw things
]]
function Demo.Start()
   GL.clearColor(1,1,1,1)
   shader = Shader.new("shaders/shader.vert", "shaders/shader.frag")
   local surface = Surface.new("images/test.png")
   image = surface:texture()
   surface:destroy()
   surface = Surface.new("images/testhead.png")
   image2 = surface:texture()
   surface:destroy()
   shader:use()
   positionAttr = shader:getAttribLocation("iposition")
   colorAttr = shader:getAttribLocation("icolor")
   texposAttr = shader:getAttribLocation("itexpos")
   texUniform = shader:getUniformLocation("texSample")
   transformUniform = shader:getUniformLocation("transform")

   transform = Mat4.new()
   transform = transform:scale(Vec3.new(0.4, 0.5, 0.5))
   GL.uniformMatrix4f(transformUniform, false, transform)
   
   box = FloatArray.new(#D.box)
   for i = 1, #D.box do
      box[i - 1] = D.box[i]
   end

   tex = FloatArray.new(#D.tex)
   for i = 1, #D.tex do
      tex[i - 1] = D.tex[i]
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
   vb_tex = GL.genBuffer()
   --vb_color = GL.genBuffer()
   eab = GL.genBuffer()
   va = GL.genVertexArray()
   
   GL.bindVertexArray(va)

   GL.bindBuffer(GL_ARRAY_BUFFER, vb_point)
   GL.bufferData(GL_ARRAY_BUFFER, box:bytes(), box, GL_STATIC_DRAW)
   -- each point is of size 3
   GL.vertexAttribPointer(positionAttr, 3, GL_FLOAT, false, 0, 0)
   GL.enableVertexAttribArray(positionAttr)

   GL.bindBuffer(GL_ARRAY_BUFFER, vb_tex)
   GL.bufferData(GL_ARRAY_BUFFER, tex:bytes(), tex, GL_STATIC_DRAW)
   -- each tex coord is of size 2
   GL.vertexAttribPointer(texposAttr, 2, GL_FLOAT, false, 0, 0)

   GL.bindBuffer(GL_ELEMENT_ARRAY_BUFFER, eab)
   GL.bufferData(GL_ELEMENT_ARRAY_BUFFER, indices:bytes(), indices, GL_STATIC_DRAW);

   -- tex stuff

   GL.uniform1i(0, 0)

   GL.activeTexture(0)
   GL.bindTexture(image)
   GL.activeTexture(1)
   GL.bindTexture(image2)

   GL.enableVertexAttribArray(0)

   mode = true

   
   -- texture settings
   --GL.texParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR)
   --GL.texParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
end

--[[
   draw things
]]
function Demo.Update()
   --Update=static.quit
   GL.enableVertexAttribArray(texposAttr)
   GL.bindVertexArray(va)
   GL.bindBuffer(GL_ELEMENT_ARRAY_BUFFER, eab)

   GL.drawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0)

   GL.bindVertexArray(0)
   GL.enableVertexAttribArray(0)

end

--[[
   destroy things
]]
function Demo.End()
   shader:destroy()
   colors:destroy()
   tex:destroy()
   box:destroy()
   indices:destroy()
end

function Demo.KeyUp(key)
   if key == KEY_0 then
      mode = not mode
      GL.uniform1i(texUniform, mode and 0 or 1)
      -- GL.polygonMode(GL_FRONT_AND_BACK, mode and GL_FILL or GL_LINE)
      --GL.activeTexture(mode and 1 or 2)
   end
   Util.KeyUp(key)
end

Util.try(isMain, D)
