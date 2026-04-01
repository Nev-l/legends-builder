on(keyPress "s"){
   if(Selection.getFocus().indexOf("tfInbox") > -1)
   {
      eval(Selection.getFocus()).replaceSel("s");
   }
   else
   {
      _root.runEngineGearDown();
   }
}
