stop();
var contentName = "dialogActivateAccountContentNew";
var tu = username;
trace("myEmail!: " + myEmail);
if(!myEmail)
{
   trace("myEmail is undefined");
   myEmail = classes.GlobalData.attr.em;
   trace("now it\'s: " + myEmail);
}
trace("username in dialogActivateAccountContent");
trace(tu);
if(!tu.length)
{
   tu = classes.GlobalData.uname;
}
fldA.text = "";
fldA.restrict = classes.Lookup.keyboardRestrictChars;
txtEmailSent.text = "";
btnOK.btnLabel.text = "Verify";
btnOK.onRelease = function()
{
   if(fldA.text.length)
   {
      ac = fldA.text;
      gotoAndStop("activating");
      play();
   }
};
btnCancel.btnLabel.text = "Cancel";
btnCancel.onRelease = function()
{
   onCancel();
};
btnResendCode._visible = true;
btnResendCode.btnLabel.autoSize = "center";
btnResendCode.btnLabel.text = "Resend Code";
btnResendCode.onRelease = function()
{
   gotoAndStop("resending");
   play();
};
