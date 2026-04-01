function cont()
{
   play();
}
stop();
classes.Drawing.carView(car2,tCarXML,72);
trace("SHOWING CAR: " + tCarXML.firstChild.attributes.pi + ", " + tCarXML.firstChild.attributes.pn);
_global.setTimeout(this,"cont",1000);
