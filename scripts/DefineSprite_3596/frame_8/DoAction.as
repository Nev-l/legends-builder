stop();
queueGroup._visible = false;
intervieweeHilite._visible = false;
interviewTalkBubble._visible = false;
trace("in election interview room");
_root.chatListUsers();
electionLogo.txtQuarter.text = "Q" + classes.SectionModElection.MC._electionSchedule.quarter;
judgeDisplay.txtJudge1.text = "";
judgeDisplay.txtJudge2.text = "";
judgeDisplay.txtJudge3.text = "";
var tnum = Number(_global.broadcastXML.firstChild.firstChild.attributes.i);
if(!classes.GlobalData.prefsObj.broadcastRead || classes.GlobalData.prefsObj.broadcastRead < tnum)
{
   _root.abc.closeMe();
   _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),{contentName:"dialogBroadcastContent",msg:_global.broadcastXML.firstChild.firstChild.attributes.m});
   classes.GlobalData.prefsObj.broadcastRead = tnum;
   classes.GlobalData.savePrefsObj();
}
