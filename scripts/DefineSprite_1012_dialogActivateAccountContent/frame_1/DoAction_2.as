stop();
var tu = _parent.u;
var tp = _parent.p;
if(!tu.length)
{
   tu = classes.Frame._MC.loginGroup.username;
}
if(!tp.length)
{
   tp = classes.Frame._MC.loginGroup.pass;
}
fldA.text = "";
fldA.restrict = classes.Lookup.keyboardRestrictChars;
btnResend.onRelease = function()
{
   gotoAndStop("resending");
   play();
};
btnOK.btnLabel.text = "Activate";
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
