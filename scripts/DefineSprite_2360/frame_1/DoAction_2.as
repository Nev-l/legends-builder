stop();
var carXML;
var accountCarID;
var carID;
var isBack = false;
_global.viewerGarageMC = this;
classes.Lookup.addCallback("getOtherUserCars",this,userCarsCB,_parent.uID);
_root.getOtherUserCars(_parent.uID);
