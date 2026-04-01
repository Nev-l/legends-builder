on(keyPress "w"){
   if(Selection.getFocus().indexOf("tfInbox") > -1)
   {
      eval(Selection.getFocus()).replaceSel("w");
   }
   else
   {
      _root.runEngineGearUp();
   }
}
