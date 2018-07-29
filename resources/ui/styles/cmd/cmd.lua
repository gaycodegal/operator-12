cmdline_height = 30

return {
   screen={
	  h="SCREEN_HEIGHT",
	  w="SCREEN_WIDTH",
	  x=0,
	  y=0
   },
   input={
	  e={
		 direction=2,
		 fg={0,0,0,255},
		 bg={255,255,255,255}
	  },
	  vars={"p=self.p", "h="..cmdline_height},
	  w="p.w",
	  h="h",
	  x=0,
	  y="p.h - h"
   },
   log={
	  e={
		 direction=2,
		 fg={255,255,255,255},
		 bg={0,0,0,255}
	  },
	  vars={"p=self.p", "ch="..cmdline_height},
	  w="p.w",
	  h="p.h - ch",
	  x=0,
	  y=0
   }
}
