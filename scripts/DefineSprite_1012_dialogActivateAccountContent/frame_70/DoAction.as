stop();
_global.clearTimeout(sendSI);
btnOK.btnLabel.text = "Back";
btnOK.onRelease = function()
{
   gotoAndPlay(1);
};
btnCancel.btnLabel.text = "Cancel";
btnCancel.onRelease = function()
{
   onCancel();
};
