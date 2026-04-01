function CB_getTwoRacersCars(txml)
{
   trace("CB_getTwoRacersCars ht");
   _global.chatObj.twoRacersCarsXML = txml;
   showContainer("racePlay");
   countdownGroup.swapDepths(10);
   rankingBoardGroup.swapDepths(9);
   loadinBG.swapDepths(8);
}
stop();
rankingBoardGroup._visible = true;
opponentPrestaged = false;
_global.chatObj.raceObj.r1Obj = {id:classes.GlobalData.id,un:classes.GlobalData.uname,cid:selCarID,ti:classes.GlobalData.attr.ti,sc:classes.GlobalData.attr.sc};
if(bracketTime > 0)
{
   _global.chatObj.raceObj.r1Obj.bt = bracketTime;
}
classes.Lookup.addCallback("raceGetTwoRacersCars",this,CB_getTwoRacersCars,selCarID);
_root.raceGetTwoRacersCars(selCarID,0);
