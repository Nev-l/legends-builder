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
var txtStats4 = "";
var txtWinner = "";
r1Obj = _global.chatObj.raceObj.r1Obj;
r2Obj = _global.chatObj.raceObj.r2Obj;
var fAttr = _global.chatObj.raceObj.lastResultsXML.firstChild.attributes;
r1Obj.rt = fAttr.rt1;
r1Obj.et = fAttr.et1;
r1Obj.ts = fAttr.ts1;
r2Obj.rt = fAttr.rt2;
r2Obj.et = fAttr.et2;
r2Obj.ts = fAttr.ts2;
var r1Tot = Number(r1Obj.rt) + Number(r1Obj.et) - Number(r1Obj.bt);
var r2Tot = Number(r2Obj.rt) + Number(r2Obj.et) - Number(r2Obj.bt);
var winGap = Math.round(Math.abs(r1Tot - r2Tot) * 1000) / 1000;
if(_global.chatObj.wid == r1Obj.id)
{
   rObj = r1Obj;
   oObj = r2Obj;
   tCarXML = new XML(_global.chatObj.twoRacersCarsXML.firstChild.childNodes[0]);
   txtWinner = "\r";
}
else if(_global.chatObj.wid == r2Obj.id)
{
   rObj = r2Obj;
   oObj = r1Obj;
   tCarXML = new XML(_global.chatObj.twoRacersCarsXML.firstChild.childNodes[1]);
   txtWinner = "\r\r";
}
if(rObj.un)
{
   if(Number(oObj.rt) < 0 || Number(oObj.et) < 0)
   {
      txtWinner += "Winner by default";
   }
   else
   {
      txtWinner += "Winner by: +" + winGap;
   }
   scc = rObj.scc;
   fldName2.text = rObj.un;
   txtNames = "\r" + r1Obj.un + "\r" + r2Obj.un;
   txtStats1 = "RT";
   if(r1Obj.rt != "-1")
   {
      txtStats1 += "\r" + classes.NumFuncs.toDecimalPlaces(Number(r1Obj.rt),3);
   }
   else
   {
      txtStats1 += "\r-";
   }
   if(r2Obj.rt != "-1")
   {
      txtStats1 += "\r" + classes.NumFuncs.toDecimalPlaces(Number(r2Obj.rt),3);
   }
   else
   {
      txtStats1 += "\r-";
   }
   var tStatsET = "ET";
   if(r1Obj.et != "-1")
   {
      tStatsET += "\r" + classes.NumFuncs.toDecimalPlaces(Number(r1Obj.et),3);
   }
   else
   {
      tStatsET += "\r-";
   }
   if(r2Obj.et != "-1")
   {
      tStatsET += "\r" + classes.NumFuncs.toDecimalPlaces(Number(r2Obj.et),3);
   }
   else
   {
      tStatsET += "\r-";
   }
   var tStatsTS = "TS";
   if(r1Obj.ts != "-1")
   {
      tStatsTS += "\r" + classes.NumFuncs.toDecimalPlaces(Number(r1Obj.ts),2);
   }
   else
   {
      tStatsTS += "\r-";
   }
   if(r2Obj.ts != "-1")
   {
      tStatsTS += "\r" + classes.NumFuncs.toDecimalPlaces(Number(r2Obj.ts),2);
   }
   else
   {
      tStatsTS += "\r-";
   }
   if(r1Obj.bt != "-1" || r2Obj.bt != "-1")
   {
      txtStats2 = "DI\r" + classes.NumFuncs.toDecimalPlaces(Number(r1Obj.bt),3) + "\r" + classes.NumFuncs.toDecimalPlaces(Number(r2Obj.bt),3);
      txtStats3 = tStatsET;
      txtStats4 = tStatsTS;
   }
   else
   {
      txtStats2 = tStatsET;
      txtStats3 = tStatsTS;
   }
}
else
{
   fldName2.text = "";
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
