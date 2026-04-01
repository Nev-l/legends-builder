stop();
if(Number(racer1Obj.RT))
{
   tripWire(Number(racer1Obj.id),Number(racer1Obj.RT));
   raceOverlay.raceTimes1._visible = true;
}
if(Number(racer2Obj.RT))
{
   tripWire(Number(racer2Obj.id),Number(racer2Obj.RT));
   raceOverlay.raceTimes2._visible = true;
}
if(Number(racer1Obj.ET))
{
   crossWire(Number(racer1Obj.id),Number(racer1Obj.ET),Number(racer1Obj.TS));
   raceOverlay.raceTimes1.txtET = raceOverlay.raceTimes1.holdET;
   raceOverlay.raceTimes1.txtTS = raceOverlay.raceTimes1.holdTS;
   raceOverlay.raceTimes1._visible = true;
   raceOverlay.raceTimes1.breakout._visible = raceOverlay.raceTimes1.breakout.isOn;
}
if(Number(racer2Obj.ET))
{
   crossWire(Number(racer2Obj.id),Number(racer2Obj.ET),Number(racer2Obj.TS));
   raceOverlay.raceTimes2.txtET = raceOverlay.raceTimes2.holdET;
   raceOverlay.raceTimes2.txtTS = raceOverlay.raceTimes2.holdTS;
   raceOverlay.raceTimes2._visible = true;
   raceOverlay.raceTimes2.breakout._visible = raceOverlay.raceTimes2.breakout.isOn;
}
if(wid > 0)
{
   showFinish(0);
}
