stop();
var xNode;
var lid = _parent.lid;
if(!lid)
{
   lid = 100;
}
i = 0;
while(i < _global.locationXML.firstChild.childNodes.length)
{
   if(_global.locationXML.firstChild.childNodes[i].attributes.lid == lid)
   {
      xNode = _global.locationXML.firstChild.childNodes[i];
      break;
   }
   i++;
}
icon.gotoAndStop(Math.round(lid / 100));
var xspaces = Number(xNode.attributes.ps) * (!Number(classes.GlobalData.attr.mb) ? 1 : 2);
txtName = xNode.attributes.ln;
txtParking = "Increased garage space to " + xspaces + " cars.";
txtParkingNum = "X " + xspaces;
txtInfo = "$" + classes.NumFuncs.commaFormat(Number(xNode.attributes.f)) + " move-in fee" + "\n";
if(Number(xNode.attributes.pf))
{
   txtInfo += "(or " + classes.NumFuncs.commaFormat(Number(xNode.attributes.pf)) + " Points)" + "\n";
}
txtInfo += "$" + classes.NumFuncs.commaFormat(Number(xNode.attributes.r)) + " weekly payment";
tog2.txt = "Options";
tog2.btn.onRelease = function()
{
   nextFrame();
};
tog1.txt = "Cancel";
tog1.btn.onRelease = function()
{
   _parent.closeMe();
};
