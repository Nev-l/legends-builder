stop();
mb.prepPanelRemove();
menuMC.removeMovieClip();
var selectedCarXML;
var cloneXML;
var tcs;
delete tcs;
var carID = selectedCarXML.firstChild.attributes.ci;
cloneGarageCar();
if(Number(selectedCarXML.firstChild.attributes.i) != selAcid)
{
   selAcid = Number(selectedCarXML.firstChild.attributes.i);
   _root.getParts(selAcid);
}
else
{
   gotoAndStop("showroom");
   play();
}
