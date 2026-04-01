on(keyPress "W"){
   if(Selection.getFocus().indexOf("tfInbox") > -1 || Selection.getFocus().indexOf("txtIgnoreMe") > -1 || Selection.getFocus().indexOf("txt_to") > -1 || Selection.getFocus().indexOf("txt_subj") > -1 || Selection.getFocus().indexOf("txt_msg") > -1)
   {
      eval(Selection.getFocus()).replaceSel("W");
   }
   else
   {
      _root.runEngineGearUp();
   }
}
