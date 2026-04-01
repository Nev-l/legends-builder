stop();
_global.clearTimeout(sendSI);
btnCancel.btnLabel.text = "OK";
btnCancel.onRelease = function()
{
   onCancel();
};
