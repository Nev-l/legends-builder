function saveAFRatioTimeout()
{
   clearTimeout(saveInterval);
   saveInterval = setTimeout(this,"saveAFRatio",2000);
}
function saveAFRatio()
{
   _root.garageSetAFRatio(classes.GlobalData.attr.dc,_parent.chipSetting);
}
var AFframe = _parent.chipSetting + 7;
var saveInterval;
