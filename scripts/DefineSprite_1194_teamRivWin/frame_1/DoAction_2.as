var rxml = _global.chatObj.raceObj.teamResultsXML;
var txml = _global.chatObj.challengeXML;
var winnerID = Number(rxml.firstChild.attributes.wid);
var winnerName = _global.chatObj.raceRoomMC.lookupTeamName(winnerID);
var loserID = 0;
var loserName = "";
var moneyWon = 0;
var scWon = 0;
var scTotal;
var winGap = Math.abs(Number(rxml.firstChild.attributes.td));
var txtNames = "";
var txtStats1 = "";
var txtStats2 = "";
var txtStats3 = "";
var txtStats4 = "";
var txtStatsBT = "";
var txtDefeat = "";
var txtCol1 = "";
var txtCol2 = "";
var txtCol3 = "";
var txtCol4 = "";
if(winnerID == rxml.firstChild.attributes.ti1)
{
   moneyWon = Number(rxml.firstChild.attributes.m1);
   scWon = Number(rxml.firstChild.attributes.c1);
   scTotal = Number(txml.firstChild.attributes.sc1) + scWon;
   loserID = Number(rxml.firstChild.attributes.ti2);
   loserName = _global.chatObj.raceRoomMC.lookupTeamName(loserID);
}
else if(winnerID == rxml.firstChild.attributes.ti2)
{
   moneyWon = Number(rxml.firstChild.attributes.m2);
   scWon = Number(rxml.firstChild.attributes.c2);
   scTotal = Number(txml.firstChild.attributes.sc2) + scWon;
   loserID = Number(rxml.firstChild.attributes.ti1);
   loserName = _global.chatObj.raceRoomMC.lookupTeamName(loserID);
}
SCbadge2.scDial.ticks.txt = scTotal;
classes.Drawing.portrait(userPic2.holder,winnerID,1,0,0,2,false,"teamavatars");
classes.Drawing.portrait(loserPic.holder,loserID,1,0,0,4,false,"teamavatars");
txtDefeat = "DEFEATED BY: +" + classes.NumFuncs.zeroFill(winGap,3);
