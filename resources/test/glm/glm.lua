require("util")

function Start()
   transform = Mat4.new()
   print(transform, "\n")
   axis = Vec3.new(0, 0, 1)
   print("rotated 90 deg around", axis, "\n")
   transform = transform:rotate(GLM.radians(90), axis)
   print(transform, "\n")
   
   print("ok")
end
