stop();
var tu = _parent.u;
var tp = _parent.p;
var fbLogin = classes.Frame._MC.loginGroup.facebookLogin;
if(classes.Frame._MC.loginGroup.facebookAgreeToTerms == true)
{
   tu = classes.Frame._MC.loginGroup.fbUsername;
   tp = classes.Frame._MC.loginGroup.fbPass;
}
else
{
   if(!tu.length)
   {
      tu = classes.Frame._MC.loginGroup.username;
   }
   if(!tp.length)
   {
      tp = classes.Frame._MC.loginGroup.pass;
   }
}
if(_parent.askAgree)
{
   btnOK.btnLabel.text = "Agree";
   btnOK.onRelease = function()
   {
      _root.agreeToTerms(tu,tp,fbLogin);
      gotoAndStop("sending");
      play();
   };
}
else
{
   btnOK.btnLabel.text = "Close";
   btnOK.onRelease = function()
   {
      _parent.closeMe();
   };
}
var agreement;
var termsLV = new LoadVars();
termsLV.onLoad = function()
{
   delete this.onLoad;
   agreement = unescape(this);
   agreement = agreement.split("\r").join("");
   agreement = agreement.split("\n").join("");
   agreement = agreement.split("\n").join("");
   gotoAndStop("show");
   play();
};
termsLV.load(_global.mainURL + "termsOfUse.html");
