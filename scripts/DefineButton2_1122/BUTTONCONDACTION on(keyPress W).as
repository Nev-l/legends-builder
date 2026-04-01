on(keyPress "W"){
   if(Selection.getFocus().indexOf("tfInbox") > -1)
   {
      eval(Selection.getFocus()).replaceSel("W");
   }
   else
   {
      _root.runEngineGearUp();
   }
}
