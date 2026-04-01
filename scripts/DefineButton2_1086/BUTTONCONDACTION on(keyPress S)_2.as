on(keyPress "S"){
   if(Selection.getFocus().indexOf("tfInbox") > -1)
   {
      eval(Selection.getFocus()).replaceSel("S");
   }
   else
   {
      _root.runEngineGearDown();
   }
}
