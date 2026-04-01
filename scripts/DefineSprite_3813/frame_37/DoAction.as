stop();
var partOwnAndUninstalledXML = new XML();
partOwnAndUninstalledXML.ignoreWhite = true;
mb.prepPanelRemove();
menuMC.removeMovieClip();
var selectedCarXML = new XML(classes.GlobalData.getSelectedCarXML().toString());
var cloneXML = new XML(selectedCarXML.toString());
var tcs;
delete tcs;
var carID = selectedCarXML.firstChild.attributes.ci;
image_mc.removeMovieClip();
this.createEmptyMovieClip("image_mc",this.getNextHighestDepth());
image_mc._x = 192;
image_mc._y = 100;
if(locationID < 300 || bg.ta == 100)
{
   classes.Drawing.carView(image_mc,cloneXML,100,!isBack ? "front" : "back");
}
if(locationID >= 300)
{
   cprLocLogo._visible = true;
}
else
{
   cprLocLogo._visible = false;
}
if(Number(selectedCarXML.firstChild.attributes.i) != selAcid)
{
   selAcid = Number(selectedCarXML.firstChild.attributes.i);
   _root.getWheelsTires(selAcid);
}
else
{
   gotoAndStop("showroom");
   play();
}
