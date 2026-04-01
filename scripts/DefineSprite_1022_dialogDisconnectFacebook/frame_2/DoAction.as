stop();
fldP.restrict = classes.Lookup.keyboardRestrictChars;
fldPC.restrict = classes.Lookup.keyboardRestrictChars;
btnOK.btnLabel.text = "Disconnect";
btnOK.onRelease = function()
{
   if(!fldPassword.length || !fldPasswordConfirm.length)
   {
      err = "Please enter password in both fields.";
      gotoAndStop("error");
      play();
   }
   else if(fldPassword != fldPasswordConfirm)
   {
      err = "Passwords don\'t match.";
      gotoAndStop("error");
      play();
   }
   else
   {
      _root.fbRemoveFacebook(fldPassword,fldPasswordConfirm);
      gotoAndStop("sending");
      play();
   }
};
btnCancel.btnLabel.text = "Cancel";
btnCancel.onRelease = function()
{
   _parent.closeMe();
};
