function CB_getBadges(d)
{
   var _loc2_ = new XML(d);
   var _loc3_ = new XML(_loc2_.firstChild.firstChild.toString());
   var _loc4_ = _loc3_.firstChild.attributes.i;
   var _loc5_ = new Array();
   var _loc6_ = 0;
   while(_loc6_ < _loc3_.firstChild.childNodes.length)
   {
      _loc5_.push(_loc3_.firstChild.childNodes[_loc6_].attributes);
      _loc6_ += 1;
   }
   if(_loc5_.length)
   {
      classes.Badges.drawBadges(badges2,_loc5_,206,false);
   }
   false;
   false;
}
classes.Lookup.addCallback("getUsers",this,CB_getBadges,String(rObj.id));
var cbArr = new Array(rObj.id);
_root.getUsers(cbArr);
