stop();
_global.emailLimitedAccessAlert = this.limitedAccessAlert;
classes.LimitedAccessFunctions.checkForLimitedAccessAlert(this.limitedAccessAlert);
fld1.restrict(classes.Lookup.emailRestrictChars);
fld2.restrict(classes.Lookup.emailRestrictChars);
if(classes.GlobalData.attr.em)
{
   txtMsg = "Your current email is:\r\r" + classes.GlobalData.attr.em + "\r\rTo change your email, enter your new email below.  A confirmation email will be sent to your current email address (You must have access to your current email address in order to confirm the change). You will be required to reactivate your account when you change your email.";
}
else
{
   txtMsg = "You have not yet registered an email with this account.  Certain features such as Password Reset will not be available until you register an email.  You can use the form below to register your email address now.";
}
btnUpdate.onRelease = function()
{
   if(!email.length || !email2.length)
   {
      _root.displayAlert("warning","Invalid Email","Please enter your email in both fields.");
   }
   else if(email != email2)
   {
      _root.displayAlert("warning","Email Mismatch","You must enter your new email in both fields. The emails in the two fields must match each other. Please check the fields and submit again.");
   }
   else
   {
      gotoAndStop("updatingEmail");
      play();
   }
};
