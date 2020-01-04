require("util")

function Start()
   test = {6,4294967294,121029,0xFFFFFFFF,44,1}
   array = UIntArray.new(6)
   for i=1,6 do
      array[i-1] = test[i]
      assert(tostring(array[i-1]) == tostring(test[i]), "failed to convert " .. test[i] .. " got " .. array[i-1])
   end
   assert(#array == 6, "wrong size: " .. #array)
   -- try to break things
   array[-1] = 12
   array[#array] = 12
   assert(array[-1] == nil, "negative indexing allowed")
   assert(array[#array] == nil, "size + 1 indexing allowed")

   unit_byte = array:bytes() // #array
   assert(unit_byte * #array == array:bytes(), "invalid bytes")
      assert(array:bytes() >= 1, "invalid bytes")
   print("byte size for uint is ", unit_byte)
   
   -- normal destroy
   array:destroy()
   -- access after destruction
   array[0] = 1
   assert(array[0] == nil, "access allowed after destroy")
   assert(#array == -1, "size available after destroy")
   assert(array:bytes() == -1, "bytes available after destroy")
   -- try to corrupt with a double free
   array:destroy()

   print("ok")
end
