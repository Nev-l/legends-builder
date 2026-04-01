btnOK.btnLabel.text = "Update";
btnOK.onRelease = function()
{
   classes.Frame._MC.loginGroup.isNewInstaller = true;
   classes.Frame._MC.loginGroup.gotoAndPlay("updater");
   this._parent._parent.closeMe();
};
btnQuit.btnLabel.text = "Quit";
btnQuit.onRelease = function()
{
   fscommand("quit");
};
