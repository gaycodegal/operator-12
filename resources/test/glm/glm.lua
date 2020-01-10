require("util")

function Start()
   local oldMat4 = Mat4.__gc
   local oldVec3 = Vec3.__gc
   local mat4_garbage_count = 0
   local v3_garbage_count = 0
   Mat4.__gc = function(self)
      oldMat4(self)
      -- test double free
      oldMat4(self)
      mat4_garbage_count = mat4_garbage_count + 1
   end
   Vec3.__gc = function(self)
      oldVec3(self)
      -- test double free
      oldVec3(self)
      v3_garbage_count = v3_garbage_count + 1
   end
   garbage_collection_test()
   collectgarbage()
   assert(mat4_garbage_count == 2, "mat4 garbage collection isn't working")
   assert(v3_garbage_count == 1, "vec3 garbage collection isn't working")
   print("ok")
end

function garbage_collection_test()
   local transform = Mat4.new()
   assert(tostring(transform) == "mat4x4((1.000000, 0.000000, 0.000000, 0.000000), (0.000000, 1.000000, 0.000000, 0.000000), (0.000000, 0.000000, 1.000000, 0.000000), (0.000000, 0.000000, 0.000000, 1.000000))", "mat isn't proper format")
   local axis = Vec3.new(0, 0, 1)
   -- rotated 90 deg around axis
   assert(tostring(axis) == "vec3(0.000000, 0.000000, 1.000000)", "vec isn't proper format")
   
   transform = transform:rotate(GLM.radians(90), axis)
   assert(tostring(transform) == "mat4x4((-0.000000, 1.000000, 0.000000, 0.000000), (-1.000000, -0.000000, 0.000000, 0.000000), (0.000000, 0.000000, 1.000000, 0.000000), (0.000000, 0.000000, 0.000000, 1.000000))", "mat isn't proper format")
end
