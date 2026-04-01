stop();
_global.homeTwitterAccountMC = this;
fld2.password = true;
btnTwitter.onRelease = function()
{
   if(!usernameText.length || !passwordText.length)
   {
      _root.displayAlert("warning","Invalid Entry","Please enter both username and password.");
   }
   else
   {
      trace("twitterLogin on frame");
      _root.twitterLogin(usernameText,passwordText,"saveuser");
   }
};
