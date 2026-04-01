stop();
facebookLogin = false;
facebookAgreeToTerms = true;
facebookLinkPage = true;
trace("facebookLogin!: " + facebookLogin);
btnFacebookLink.onRelease = function()
{
   trace("btnFacebookLink::onRelease");
   tryLoginWithFB();
};
btnBack.onRelease = function()
{
   _root.clearFB();
   facebookLinkPage = false;
   gotoAndStop(1);
};
btnFacebookNewName.onRelease = function()
{
   _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),{contentName:"dialogCreateAccountContent"});
   _root.abc.facebookCreate = true;
};
