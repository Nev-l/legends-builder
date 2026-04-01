stop();
var tscListXML;
if(!scListXML)
{
   tscListXML = new XML();
   tscListXML.ignoreWhite = true;
}
tscListXML.onLoad = function(success)
{
   trace("tscListXML: " + success);
   var _loc3_ = undefined;
   var _loc4_ = undefined;
   var _loc5_ = undefined;
   var _loc6_ = undefined;
   var _loc7_ = undefined;
   var _loc8_ = undefined;
   var _loc9_ = undefined;
   var _loc10_ = undefined;
   var _loc11_ = undefined;
   if(success)
   {
      _loc4_ = new Array();
      _loc5_ = this.firstChild.firstChild.childNodes.length;
      _loc8_ = 0;
      while(_loc8_ < _loc5_)
      {
         _loc9_ = this.firstChild.firstChild.childNodes[_loc8_].attributes;
         _loc10_ = new Object();
         _loc10_.id = _loc9_.i;
         _loc10_.txtName = _loc9_.n;
         if(periodType != "All")
         {
            _loc11_ = Number(_loc9_.sc);
            if(!_loc3_)
            {
               _loc3_ = _loc11_;
               scDial.ticks.txt = _loc3_ < 0 ? "" : "+";
               scDial.ticks.txt += _loc3_;
            }
            _loc10_.txtCol2 = _loc11_ < 0 ? _loc9_.sc : "+" + _loc9_.sc;
         }
         else
         {
            _loc11_ = Number(_loc9_.sc);
            if(!_loc3_)
            {
               _loc3_ = _loc11_;
               classes.SCDial.setSCDial(scDial,_loc3_);
            }
            _loc10_.txtCol2 = _loc9_.sc;
         }
         if(_loc11_ != _loc7_)
         {
            _loc6_ = _loc8_ + 1;
            _loc7_ = _loc11_;
         }
         _loc10_.txtRank = _loc6_ + ".";
         _loc4_.push(_loc10_);
         _loc8_ += 1;
      }
      buildLeaderboard(_loc4_);
      scDial.txtLevel = "";
   }
};
periodType = newPeriodType;
periodNum = newPeriodNum;
_root.leaderboardGetContent(listType,periodType,periodNum);
