clearHelp();
selOppCarXML = null;
selOppCar = 0;
classes.Lookup.addCallback("getOtherUserCars",this,oppCarsCB,oppID);
_root.getOtherUserCars(oppID);
