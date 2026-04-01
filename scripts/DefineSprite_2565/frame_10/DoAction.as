stop();
var tbaListXML;
if(!tbaListXML)
{
   tbaListXML = new XML();
   tbaListXML.ignoreWhite = true;
}
tbaListXML.onLoad = function(success)
{
   trace("tbaListXML: " + success);
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
         _loc11_ = Number(_loc9_.f);
         if(!_loc3_)
         {
            _loc3_ = _loc11_;
         }
         if(periodType != "All")
         {
            _loc10_.txtCol2 = _loc11_ < 0 ? _loc11_ : "+" + classes.NumFuncs.commaFormat(_loc11_);
         }
         else
         {
            _loc10_.txtCol2 = classes.NumFuncs.commaFormat(_loc11_);
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
   }
};
periodType = newPeriodType;
periodNum = newPeriodNum;
_root.leaderboardGetContent(listType,periodType,periodNum);
