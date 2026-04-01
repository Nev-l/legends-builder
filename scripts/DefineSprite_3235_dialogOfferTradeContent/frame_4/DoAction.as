stop();
if(s == 1)
{
   msg = "Your trade offer has been sent.  You can monitor the status of your offer in the Trade Offers Sent section of this page.";
   _global.sectionClassifiedMC.gotoAndPlay("trade");
}
btnClose.btnLabel.text = "Close";
btnClose.onRelease = function()
{
   this._parent._parent.closeMe();
};
