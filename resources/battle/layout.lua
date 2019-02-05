return {
   axis=horizontal,
   children={
	  {size={200,"dp"},
	   axis=vertical,
	   children={
		  {class=UIButton,
		   name="info",
		   text="testing",
		   color="000000cc",
		   size={1,"w"}},
		  {class=UIList,
		   name = "actions",
		   size={100,"dp"}}
	   }},
	  {size={1,"w"},
	   axis=vertical,
	   children={
		  {class=UIButton,
		   name="money",
		   text="$yeet",
		   color="00ff00",
		   size={30,"sp"}},
	  }},
   }
}
