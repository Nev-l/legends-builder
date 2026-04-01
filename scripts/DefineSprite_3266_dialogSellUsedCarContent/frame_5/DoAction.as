stop();
if(s == 1)
{
   classes.GlobalData.updateCarAttr(selCar,"lk",1);
   msg = "This car is now listed for sale.  The Listing ID is: \r\r" + newClassifiedID;
   _global.sectionClassifiedMC.gotoAndPlay("trade");
}
btnClose.btnLabel.text = "Close";
btnClose.onRelease = function()
{
   this._parent._parent.closeMe();
};
