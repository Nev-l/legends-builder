function onOK()
{
   incorrectPW._visible = false;
   if(!attemptPW.length && (classes.GlobalData.attr.r != 1 && classes.GlobalData.attr.r != 2 && classes.GlobalData.attr.r != 8))
   {
      _root.displayAlert("warning","Password Required","This is a private room and requires the correct password to enter.");
   }
   else
   {
      _global.sectionTrackMC.enterRaceWaitRoom(typeID);
      _root.chatJoin(5,roomID,attemptPW,asInvisible);
      btnOK._visible = false;
      btnCancel._visible = false;
      fldAttemptPW.type = "dynamic";
   }
}
function showWrongPW()
{
   incorrectPW._visible = true;
   btnOK._visible = true;
   btnCancel._visible = true;
   fldAttemptPW.type = "input";
}
