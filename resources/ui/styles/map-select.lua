return {
   screen={
	  h="SCREEN_HEIGHT",
	  w="SCREEN_WIDTH",
	  x=0,
	  y=0
   },
   button={
	  vars={"p=self.p","s=10","col=4","w=(p.w - s * (col + 1))//col",
			"h=(p.h - s * (col + 1))//col"},
	  w="w",
	  h="h",
	  x="(d[1] + 1)*s + d[1]*w",
	  y="(d[2] + 1)*s + d[2]*h"
   }
}
