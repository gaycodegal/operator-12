return {
   listButton={
	  vars={"p=self.p","h=d.h","th=(d.n * h + (d.n - 1) * d.s)","a=d.align","y=p.y + d.i*(h + d.s) + ((a==1 and 0) or (p.h - th)//((a==2 and 2) or 1))"},
	  w="p.w",
	  h="h",
	  x="p.x",
	  y="y"
   },
   lbContainer={
	  vars={"p=self.p"},
	  w="p.w",
	  h="p.h",
	  x="p.x",
	  y="p.y"
   },
   lbChild={
	  vars={"p=self.p","h=d.h","th=(d.n * h + (d.n - 1) * d.s)","a=d.align","y=p.y + ((a==3 and 0) or th)"},
	  w="p.w",
	  h="p.h-th",
	  x="p.x",
	  y="y"
   }
}
