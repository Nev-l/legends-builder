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
      if(_loc4_ == r1Obj.id)
      {
         classes.Badges.drawBadges(badges1,_loc5_,206,true);
      }
      else if(_loc4_ == r2Obj.id)
      {
         classes.Badges.drawBadges(badges2,_loc5_,206,false);
      }
   }
   false;
   false;
}
classes.Lookup.addCallback("getUsers",this,CB_getBadges,String(r1Obj.id));
classes.Lookup.addCallback("getUsers",this,CB_getBadges,String(r2Obj.id));
var cbArr = new Array(r1Obj.id,r2Obj.id);
_root.getUsers(cbArr);
