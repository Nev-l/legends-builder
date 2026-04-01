stop();
_global.clearTimeout(sendSI);
fldError.text = err;
btnOK.btnLabel.text = "Back";
btnOK.onRelease = function()
{
   gotoAndStop("form");
   play();
};
btnCancel.btnLabel.text = "Cancel";
btnCancel.onRelease = function()
{
   _parent.closeMe();
};
