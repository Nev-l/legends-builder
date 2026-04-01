_parent._parent.drawQueue(true);
txtBetType = "";
var r1Obj = _global.chatObj.raceObj.r1Obj;
var r2Obj = _global.chatObj.raceObj.r2Obj;
fldName1.text = r1Obj.un;
fldName2.text = r2Obj.un;
classes.SCDial.setSCDial(SCbadge1.scDial,r1Obj.sc);
classes.SCDial.setSCDial(SCbadge2.scDial,r2Obj.sc);
if(Number(r1Obj.ti))
{
   userInfoTeam1.fldTeam.text = r1Obj.tn;
   classes.Drawing.portrait(teamAvatar1.holder,r1Obj.ti,1,0,0,2,false,"teamavatars");
}
else
{
   userInfoTeam1._visible = false;
   teamAvatar1._visible = false;
}
if(Number(r2Obj.ti))
{
   userInfoTeam2.fldTeam.text = r2Obj.tn;
   classes.Drawing.portrait(teamAvatar2.holder,r2Obj.ti,1,0,0,2,false,"teamavatars");
}
else
{
   userInfoTeam2._visible = false;
   teamAvatar2._visible = false;
}
