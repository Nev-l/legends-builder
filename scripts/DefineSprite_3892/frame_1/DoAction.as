function saveBoostTimeout()
{
   clearTimeout(saveInterval);
   saveInterval = setTimeout(this,"saveBoost",2000);
}
function saveBoost()
{
   _root.garageSetBoost(classes.GlobalData.attr.dc,_parent.boostSetting);
}
var saveInterval;
