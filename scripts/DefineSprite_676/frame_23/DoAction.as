stop();
currentText = "Currently tweeting under " + _global.twitterName;
disableTwitter.onRelease = function()
{
   trace("twitterLogin on frame");
   _root.twitterLogin(usernameText,passwordText,"disable");
};
