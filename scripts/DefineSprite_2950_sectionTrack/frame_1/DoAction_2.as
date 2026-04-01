stop();
var cid;
var tourneyID;
var tourneyScheduleID;
var detailObj;
_global.electionChatRoom = false;
_global.sectionTrackMC = this;
classes.Control.setMapButton("track");
if(!classes.GlobalData.prefsObj.didViewRace)
{
   _root.joinRivalsRoom();
}
else
{
   _root.htInfo();
   if(classes.GlobalData.priorStreetCredit < Number(_global.loginXML.firstChild.firstChild.attributes.sc))
   {
      classes.GlobalData.priorStreetCredit = Number(_global.loginXML.firstChild.firstChild.attributes.sc);
      _root.checkTestDrive();
   }
}
