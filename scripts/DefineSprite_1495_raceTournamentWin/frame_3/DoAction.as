var rObj;
var r1Obj;
var r2Obj;
var scc = 0;
if(_global.chatObj.roomType == "CT")
{
   rObj = {id:classes.GlobalData.id,un:classes.GlobalData.uname,ti:classes.GlobalData.attr.ti,tn:classes.GlobalData.attr.tn,sc:classes.GlobalData.attr.sc};
   classes.SCDial.setSCDial(SCbadge2.scDial,rObj.sc);
}
else
{
   r1Obj = _global.chatObj.raceObj.r1Obj;
   r2Obj = _global.chatObj.raceObj.r2Obj;
   var fAttr = _global.chatObj.raceObj.lastResultsXML.firstChild.attributes;
   if(fAttr.wid == r1Obj.id)
   {
      rObj = r1Obj;
      scc = Number(fAttr.c1);
   }
   else if(fAttr.wid == r2Obj.id)
   {
      rObj = r2Obj;
      scc = Number(fAttr.c2);
   }
   classes.SCDial.setSCDial(SCbadge2.scDial,Number(rObj.sc) + scc);
}
if(rObj.id)
{
   fldName2.text = rObj.un;
}
else
{
   rObj = new Object();
   rObj.id = classes.Control.htourneyMC.tourneyWinnerID;
   fldName2.text = classes.Control.htourneyMC.lookupUserName(rObj.id);
}
if(Number(rObj.ti))
{
   userInfoTeam2.fldTeam.text = rObj.tn;
   classes.Drawing.portrait(teamAvatar2.holder,rObj.ti,1,0,0,2,false,"teamavatars");
}
else
{
   userInfoTeam2._visible = false;
   teamAvatar2._visible = false;
}
