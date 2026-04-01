function pickSetting(pNum)
{
   setting = pNum;
   optionsGroup.gotoAndStop(pNum);
   switch(pNum)
   {
      case 1:
         isPrivate = 0;
         isMember = 0;
         break;
      case 2:
         isPrivate = 1;
         isMember = 0;
         break;
      case 3:
         isPrivate = 0;
         isMember = 1;
      default:
         return undefined;
   }
}
function onOK()
{
   if(newRoomName.length)
   {
      if(setting == 2 && !optionsGroup.newPW.length)
      {
         _root.displayAlert("warning","Password Missing","You must set a password to create a Private Room. Please try again.");
      }
      else
      {
         _global.newRoomName = newRoomName;
         _global.sectionTrackMC.enterRaceWaitRoom(typeID);
         _root.chatCreateRoom(5,typeID,newRoomName,isPrivate,optionsGroup.newPW,isMember,isPro);
         _parent.closeMe();
      }
   }
}
