stop();
_global.homeAccountSecurityMC = this;
fld0.restrict = classes.Lookup.keyboardRestrictChars;
fld1.restrict = classes.Lookup.keyboardRestrictChars;
fld2.restrict = classes.Lookup.keyboardRestrictChars;
if(classes.GlobalData.facebookConnected == true)
{
   btnRemoveFacebook._visible = true;
   btnRemoveFacebook.onRelease = function()
   {
      trace("btnRemoveFacebook.onRelease");
      _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),{contentName:"dialogDisconnectFacebook"});
   };
}
else
{
   btnRemoveFacebook._visible = false;
   btnRemoveFacebook.onRelease = null;
}
btnUpdate.onRelease = function()
{
   if(!txtfld0.length)
   {
      _root.displayAlert("warning","Invalid Password","Please enter your Old Password.");
   }
   else if(!txtfld1.length || !txtfld2.length)
   {
      _root.displayAlert("warning","Invalid New Password","Please enter your new password in both New Password fields.");
   }
   else if(txtfld1 != txtfld2)
   {
      _root.displayAlert("warning","Password Mismatch","You must enter your new password in both fields. The password in the two fields must match each other. Please check the fields and submit again.");
   }
   else
   {
      gotoAndStop("updatingPass");
      play();
   }
};
