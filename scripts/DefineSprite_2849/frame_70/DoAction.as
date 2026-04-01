_global.clearTimeout(detailObj.liveSI);
extraDetail();
countdownGroup.onEnterFrame = setCountdownTime;
btnEnter.onRelease = function()
{
   _global.sectionTrackMC.tourneyScheduleID = Number(detailObj.it);
   startTourney(Number(detailObj.i),Number(detailObj.it),Number(detailObj.mp),Number(detailObj.pp),Number(detailObj.b),detailObj);
};
