require("util")

function Start()
   test = {6,-2.1123415,121029,123.7123123,44.2,1.3}
   array = FloatArray.new(6)
   for i=1,6 do
      array[i-1] = test[i]
      assert(math.floor((array[i-1] - test[i])*100000 + 0.5) == 0, "failed to convert " .. test[i] .. " got " .. array[i-1])
   end
   assert(#array == 6, "wrong size: " .. #array)
   -- try to break things
   array[-1] = 12
   array[#array] = 12
   assert(array[-1] == nil, "negative indexing allowed")
   assert(array[#array] == nil, "size + 1 indexing allowed")

   -- normal destroy
   array:destroy()
   -- access after destruction
   array[0] = 1
   assert(array[0] == nil, "access allowed after destroy")
   assert(#array == -1, "size available after destroy")
   -- try to corrupt with a double free
   array:destroy()

   print("ok")
end
