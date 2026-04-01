stop();
fldU.restrict = classes.Lookup.alphaNumRestrictChars + " ";
btnOK.btnLabel.text = "Send";
btnOK.onRelease = function()
{
   if(fldU.text.length)
   {
      _root.forgotPassword(fldU.text);
      gotoAndStop("sending");
      play();
   }
};
btnCancel.btnLabel.text = "Cancel";
btnCancel.onRelease = function()
{
   _parent.closeMe();
};
