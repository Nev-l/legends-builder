_global.sellCarObj = new Object();
_global.sellCarObj.cid = Number(_parent.tObj.carXML.firstChild.attributes.i);
_global.sellCarObj.tObj = _parent.tObj;
_root.getCarPrice(_global.sellCarObj.cid);
btnCancel.btnLabel.text = "Close";
btnCancel.onRelease = function()
{
   _parent.closeMe();
};
