var i = 1;
while(i <= 7)
{
   classes.Effects.roBump(this["bldg" + i]);
   i++;
}
bldg1.onRelease = function()
{
   _parent.gotoAndStop("paint");
};
bldg2.onRelease = function()
{
   _parent.storeType = "0";
   _parent.gotoAndStop("parts");
};
bldg3.onRelease = function()
{
   _parent.gotoAndStop("repair");
};
bldg4.onRelease = function()
{
   _parent.gotoAndStop("licenses");
};
bldg5.onRelease = function()
{
   _parent.gotoAndStop("dyno");
};
bldg6.onRelease = function()
{
   _parent.gotoAndStop("wheels");
};
bldg7.onRelease = function()
{
   _parent.storeType = "2";
   _parent.gotoAndStop("parts");
};
switch(_parent.locationID)
{
   case 100:
      txtBldg6 = "Toreno Tires";
      cpr._visible = false;
      break;
   case 200:
      txtBldg6 = "Newburge Tires";
      cpr._visible = false;
      break;
   case 300:
   case 400:
   case 500:
      txtBldg6 = "";
      cpr._visible = true;
      break;
   default:
      txtBldg6 = "";
      cpr._visible = false;
}
btnHelp.onRelease = function()
{
   tutorialObj = new classes.util.Tutorial(_parent,classes.data.TutorialData.arrShop,true);
};
