function CB_getWinsAndLosses(d)
{
   var _loc2_ = new XML(d);
   if(Number(_loc2_.firstChild.attributes.w) > -1)
   {
      txtStats = "Wins: " + _loc2_.firstChild.attributes.w + "    " + "Losses: " + _loc2_.firstChild.attributes.l;
   }
}
function CB_getBlackCardProgress(d)
{
   trace("CB_getBlackCardProgress");
   trace(d);
   var _loc2_ = new XML(d);
   txtBlackCard = "Amount spent this week: $";
   txtBlackCard += classes.NumFuncs.commaFormat(Number(_loc2_.firstChild.attributes.s));
}
stop();
var myAttr = classes.GlobalData.attr;
this.attachMovie("userInfo","userInfo",this.getNextHighestDepth(),{_x:12,_y:83,changeAvatarEnabled:true,uID:myAttr.i,uName:myAttr.u,tID:Number(myAttr.ti),lid:myAttr.lid,mb:myAttr.mb,tName:myAttr.tn,uCred:myAttr.sc});
if(classes.GlobalData.attr.mb == 1)
{
   _root.getWinsAndLosses();
}
else
{
   txtStats = "win/loss stats available with membership";
}
_root.getBlackCardProgress();
