raceOverlay.swapDepths(20);
if(!_global.chatObj.raceRoomMC.isTeamRivals)
{
   raceOverlay.raceCheerGaugesCover._visible = false;
}
raceResultsOverlay.swapDepths(30);
raceResultsOverlay._visible = false;
raceResultsTimes.swapDepths(31);
raceResultsTimes._visible = false;
if(Number(racer1Obj.bt) > 0)
{
   dialin1.txt = classes.NumFuncs.zeroFill(Number(racer1Obj.bt),3);
}
else
{
   dialin1._visible = false;
}
if(Number(racer2Obj.bt) > 0)
{
   dialin2.txt = classes.NumFuncs.zeroFill(Number(racer2Obj.bt),3);
}
else
{
   dialin2._visible = false;
}
if(isSpectator)
{
   var controlsMC;
   car1._visible = true;
   car2._visible = true;
   _root.raceTreeMovie = tree;
}
