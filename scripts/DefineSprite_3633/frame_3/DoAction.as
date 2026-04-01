function cont()
{
   play();
}
stop();
var tCarXML = new XML(_global.chatObj.twoRacersCarsXML.firstChild.childNodes[0]);
classes.Drawing.carView(carPair.car1,tCarXML,72);
classes.Drawing.plateView(licensePlate1.holder,tCarXML.firstChild.attributes.pi,tCarXML.firstChild.attributes.pn,33,true,true);
var tCarXML = new XML(_global.chatObj.twoRacersCarsXML.firstChild.childNodes[1]);
classes.Drawing.carView(carPair.car2,tCarXML,72);
classes.Drawing.plateView(licensePlate2.holder,tCarXML.firstChild.attributes.pi,tCarXML.firstChild.attributes.pn,33,true,true);
_global.setTimeout(this,"cont",1000);
