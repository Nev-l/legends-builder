_root.repairPartMC = this;
var selCarXML = new XML(classes.GlobalData.getSelectedCarXML().toString());
var selCar = selCarXML.firstChild.attributes.i;
classes.Drawing.carView(carHolder,selCarXML,100,"front");
