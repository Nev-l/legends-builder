var setting = classes.GlobalData.prefsObj.raceQuality;
var watchSetting = classes.GlobalData.prefsObj.spectateQuality;
samples.gotoAndStop(2);
pickSetting(setting);
pickWatchSetting(watchSetting);
btnBest.onRollOver = btnWatchBest.onRollOver = function()
{
   samples.gotoAndStop(1);
};
btnBest.onRelease = function()
{
   pickSetting(5);
};
btnWatchBest.onRelease = function()
{
   pickWatchSetting(5);
};
btnMed.onRollOver = btnWatchMed.onRollOver = function()
{
   samples.gotoAndStop(2);
};
btnMed.onRelease = function()
{
   pickSetting(3);
};
btnWatchMed.onRelease = function()
{
   pickWatchSetting(3);
};
btnLow.onRollOver = btnWatchLow.onRollOver = function()
{
   samples.gotoAndStop(3);
};
btnLow.onRelease = function()
{
   pickSetting(1);
};
btnWatchLow.onRelease = function()
{
   pickWatchSetting(1);
};
btnOff.onRollOver = function()
{
   samples.gotoAndStop(4);
};
btnOff.onRelease = function()
{
   pickSetting(0);
};
btnOK.btnLabel.text = "Save";
btnOK.onRelease = function()
{
   classes.GlobalData.prefsObj.raceQuality = setting;
   classes.GlobalData.prefsObj.spectateQuality = watchSetting;
   classes.GlobalData.savePrefsObj();
   _parent.closeMe();
};
btnCancel.btnLabel.text = "Cancel";
btnCancel.onRelease = function()
{
   _parent.closeMe();
};
