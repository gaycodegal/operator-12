return {
   actionsPanel={
	  vars={"p=self.p"},
	  w="200",
	  h="p.h",
	  x="p.x",
	  y="p.y"
   },
   money={
	  vars={"p=self.p", "w=200"},
	  w="w",
	  h="30",
	  x="p.x + p.w - w",
	  y="p.y",
	  e={
	     bg={255,0,0,255},
	     justify=3
	    }
   }
}
