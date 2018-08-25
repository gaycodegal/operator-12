require("dialogue/util")

return {
   ["main-entry"]={
	  text="Each dialogue has its own text field. This is all the text that is displayed before a choice. Then the choices are presented. Choice functions take a first argument of the Dialogue element that is currently displaying them.",
	  buttons={
		 texts={"reshow that message", "go to another dialogue bit","Main Menu"},
		 fns={DUtil.reload, DUtil.go("second"), DUtil.loadGlobalController("MainMenu")}
	  }
   },
   second={
	  text="That's it! you visited a new piece of dialogue",
	  buttons={
		 texts={"back to main topic"},
		 fns={DUtil.go("main-entry")}
	  }
   }
}
