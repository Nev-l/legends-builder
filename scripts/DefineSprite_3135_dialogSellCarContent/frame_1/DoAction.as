_global.sellCarObj = new Object();
_global.sellCarObj.cid = Number(_parent.carXML.firstChild.attributes.i);
_global.sellCarObj.cb = _parent.cb;
amount = "$" + _parent.carXML.firstChild.attributes.vw;
msg = "This is an instant sale.";
if(Number(_parent.carXML.firstChild.attributes.ii) || _parent.impounded)
{
   msg += "  After impound fees, the selected car with its currently installed parts has a market value of the amount shown below.";
}
else
{
   msg += "  The selected car with its currently installed parts has a market value of the amount shown below.";
}
btnOK.btnLabel.text = "Sell Now";
btnOK.onRelease = function()
{
   if(_global.sellCarObj.cid)
   {
      classes.Lookup.addCallback("sellCar",_root,_global.sellCarObj.cb,"");
      _root.sellCar(_global.sellCarObj.cid);
      _parent.closeMe();
   }
};
btnCancel.btnLabel.text = "Cancel";
btnCancel.onRelease = function()
{
   _parent.closeMe();
};
