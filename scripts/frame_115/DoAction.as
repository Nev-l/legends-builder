stop();
if(classes.GlobalData.prefsObj.didFirstRun)
{
   classes.GlobalData.prefsObj.didViewRace = 1;
   classes.GlobalData.savePrefsObj();
}
if(!classes.GlobalData.prefsObj.didViewRace)
{
   delete _global.chatRoomListXML;
   _global.chatRoomListMC = null;
   _root.chatListRoom2(5,5);
}
else
{
   play();
}
