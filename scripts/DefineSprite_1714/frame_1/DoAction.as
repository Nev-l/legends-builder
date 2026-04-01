var rObj;
var oObj;
var r1Obj;
var r2Obj;
var tCarXML;
var scc;
var txtNames = "";
var txtStats1 = "";
var txtStats2 = "";
var txtStats3 = "";
var txtWinner = "";
r1Obj = _global.chatObj.raceObj.r1Obj;
r2Obj = _global.chatObj.raceObj.r2Obj;
var r1Tot = Number(r1Obj.rt) + Number(r1Obj.et) - Number(r1Obj.bt);
var r2Tot = Number(r2Obj.rt) + Number(r2Obj.et) - Number(r2Obj.bt);
var winGap = Math.round(Math.abs(r1Tot - r2Tot) * 1000) / 1000;
if(classes.GlobalData.id == r1Obj.id)
{
   rObj = r1Obj;
   oObj = r2Obj;
   tCarXML = new XML(_global.chatObj.twoRacersCarsXML.firstChild.childNodes[0]);
   txtWinner = "";
}
else if(classes.GlobalData.id == r2Obj.id)
{
   rObj = r2Obj;
   oObj = r1Obj;
   tCarXML = new XML(_global.chatObj.twoRacersCarsXML.firstChild.childNodes[1]);
   txtWinner = "\r";
}
txtWinner += "Winner by: +" + winGap;
scc = rObj.scc;
fldName2.text = rObj.un;
txtNames = r1Obj.un + "\r" + r2Obj.un;
if(r1Obj.rt != "-1")
{
   txtStats1 = r1Obj.rt;
}
if(r1Obj.et != "-1")
{
   txtStats2 = r1Obj.et;
}
if(r1Obj.ts != "-1")
{
   txtStats3 = r1Obj.ts;
}
if(r2Obj.rt != "-1")
{
   txtStats1 += "\r" + r2Obj.rt;
}
if(r2Obj.et != "-1")
{
   txtStats2 += "\r" + r2Obj.et;
}
if(r2Obj.ts != "-1")
{
   txtStats3 += "\r" + r2Obj.ts;
}
classes.SCDial.setSCDial(SCbadge2.scDial,rObj.sc);
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
bet = classes.Control.ctourneyMC.roundsArr[classes.Control.ctourneyMC.roundsArr.length - 1].winAmt;
