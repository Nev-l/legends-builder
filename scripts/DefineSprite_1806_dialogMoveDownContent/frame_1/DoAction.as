stop();
var xNode;
var myParkingSpaces;
var targetParkingSpaces;
var parkingSpaceDiff;
var parkingSpaceLossText;
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
   }
   if(_global.locationXML.firstChild.childNodes[i].attributes.lid == classes.GlobalData.attr.lid)
   {
      myParkingSpaces = Number(_global.locationXML.firstChild.childNodes[i].attributes.ps) * (!Number(classes.GlobalData.attr.mb) ? 1 : 2);
   }
   i++;
}
trace("loc ps: " + xNode.attributes.ps);
trace("mb check: " + (!Number(classes.GlobalData.attr.mb) ? 1 : 2));
targetParkingSpaces = Number(xNode.attributes.ps) * (!Number(classes.GlobalData.attr.mb) ? 1 : 2);
trace("targetParkingSpaces: " + targetParkingSpaces);
trace("myParkingSpaces: " + myParkingSpaces);
parkingSpaceDiff = myParkingSpaces - targetParkingSpaces;
trace("parkingSpaceDiff: " + parkingSpaceDiff);
if(parkingSpaceDiff > 20)
{
   parkingSpaceLossText = String(parkingSpaceDiff);
}
else
{
   parkingSpaceLossText = classes.NumFuncs.toText(parkingSpaceDiff);
}
txtWarning = "Moving down will cause you to lose " + parkingSpaceLossText + " parking space" + (parkingSpaceDiff <= 1 ? "" : "s") + ". Some of your cars may be impounded until you move back up to get the necessary room in your garage.";
parkingSpotGroup.parkingSpot.X._visible = false;
if(myParkingSpaces <= 30)
{
   parkingSpotGroup._visible = true;
   i = 2;
   while(i <= myParkingSpaces)
   {
      duplicateMovieClip(parkingSpotGroup.parkingSpot,"parkingSpot" + i,16384 + i);
      trace(parkingSpotGroup["parkingSpot" + i]);
      parkingSpotGroup["parkingSpot" + i]._x += (i - 1) % 10 * 53;
      parkingSpotGroup["parkingSpot" + i]._y += Math.floor((i - 1) / 10) * 23;
      parkingSpotGroup["parkingSpot" + i].X._visible = i > targetParkingSpaces;
      i++;
   }
}
else
{
   parkingSpotGroup._visible = false;
}
if(parkingSpotGroup._width > 407)
{
   parkingSpotGroup._xscale = 100 * (407 / parkingSpotGroup._width);
   parkingSpotGroup._yscale = parkingSpotGroup._xscale;
}
icon.gotoAndStop(Math.round(lid / 100));
txtName = xNode.attributes.ln;
if(Number(xNode.attributes.f))
{
   txtInfo = "$" + classes.NumFuncs.commaFormat(Number(xNode.attributes.f)) + " move-in fee" + "\n";
   if(Number(xNode.attributes.pf))
   {
      txtInfo += "(or " + classes.NumFuncs.commaFormat(Number(xNode.attributes.pf)) + " Points)" + "\n";
   }
}
else
{
   txtInfo = "No move-in fee\r";
}
if(Number(xNode.attributes.r))
{
   txtInfo += "$" + classes.NumFuncs.commaFormat(Number(xNode.attributes.r)) + " weekly payment";
}
else
{
   txtInfo += "No weekly payment";
}
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
