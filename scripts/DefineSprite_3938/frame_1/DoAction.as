function saveShiftLightRPMTimeout()
{
   clearTimeout(saveInterval);
   saveInterval = setTimeout(this,"saveShiftLightRPM",2000);
}
function saveShiftLightRPM()
{
   _root.garageSetShiftLightRPM(classes.GlobalData.attr.dc,rpm);
}
function setRPM(a_rpm)
{
   trace("setRPM: " + a_rpm);
   rpm = a_rpm;
   textMovie.rpmText = rpm;
   trace(textMovie.rpmText);
}
var saveInterval;
var rpm;
lightButtons.topButton.onRelease = function()
{
   trace("topButton onRelease");
   if(rpm < _parent.redLine)
   {
      setRPM(rpm + 100);
      saveShiftLightRPMTimeout();
   }
};
lightButtons.bottomButton.onRelease = function()
{
   trace("bottomButton onRelease");
   if(rpm > 0)
   {
      setRPM(rpm - 100);
      saveShiftLightRPMTimeout();
   }
};
