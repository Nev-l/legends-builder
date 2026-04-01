stop();
var isNewInstaller;
var facebookLinkPage;
var facebookLogin = false;
var facebookAgreeToTerms = false;
trace("facebook link: " + facebookLinkPage);
if(facebookLinkPage == true)
{
   gotoAndStop(29);
}
btnStart.onRelease = function()
{
   this._parent.facebookLogin = false;
   this._parent.facebookLinkPage = false;
   tryLogin();
};
btnStart.onKeyDown = function()
{
   if(Key.getCode() == 13)
   {
      btnStart.onRelease();
   }
};
btnFBConnect.onRelease = function()
{
   trace("_MC.btnFBConnect.onRelease");
   this._parent.facebookLinkPage = false;
   gotoAndStop(2);
   _root.fbGetToken();
};
var kListener = new Object();
kListener.onKeyDown = function()
{
   if(Key.getCode() == 13)
   {
      btnStart.onRelease();
      Key.removeListener(kListener);
   }
};
fldUsername.tabIndex = 1;
fldPass.tabIndex = 2;
btnStart.tabIndex = 3;
fldUsername.restrict = classes.Lookup.keyboardRestrictChars;
fldPass.restrict = classes.Lookup.keyboardRestrictChars;
fldUsername.onSetFocus = function()
{
   Key.addListener(kListener);
};
fldUsername.onKillFocus = function()
{
   Key.removeListener(kListener);
};
fldPass.onSetFocus = function()
{
   Key.addListener(kListener);
};
fldPass.onKillFocus = function()
{
   Key.removeListener(kListener);
};
btnForgotPW.onRelease = function()
{
   _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),{contentName:"dialogForgotPWContent"});
};
btnTerms.onRelease = function()
{
   _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),{contentName:"dialogTermsContent"});
};
btnCreateAccount.onRelease = function()
{
   this._parent.facebookLinkPage = false;
   _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),{contentName:"dialogCreateAccountContent"});
};
btnWhatsFacebook.onRelease = function()
{
   _root.displayAlert("helmet","Facebook Connect","Click this button to sign in with your Facebook account.  You can link an existing 1320 Legends account or create a brand new one.  You’ll be automatically logged in and you’ll be able to see your Facebook friends who are playing 1320 Legends and update them with your game achievements.");
};
btnHelp.onRelease = function()
{
   _root.displayAlert("helmet","Account Login","Enter your account Name and Password, then click the START button. \r\rDon\'t have an account yet?  Just click \'OK\' to close this message, then click the \'Create an account\' button on the left.  It\'s free and perfectly safe!");
};
trace("fb: " + classes.GlobalData.prefsObj.fb);
if(classes.GlobalData.prefsObj.fb < 4)
{
   showFBOnly(false);
}
else
{
   showFBOnly(false);
}
