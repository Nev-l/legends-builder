var selCar;
var selCarXML;
var dialTime = 0;
var payType;
selCarXML = classes.GlobalData.getSelectedCarXML();
selCar = Number(selCarXML.attributes.i);
nav1.btnLabel.text = "Cancel";
nav1.onRelease = function()
{
   _parent.closeMe();
};
nav2.btnLabel.text = "Continue";
nav2.onRelease = function()
{
   gotoAndStop("code");
   play();
};
