stop();
var ksListXML;
if(!ksListXML)
{
   ksListXML = new XML();
   ksListXML.ignoreWhite = true;
}
ksListXML.onLoad = function(success)
{
   trace("ksListXML: " + success);
   var _loc3_ = undefined;
   var _loc4_ = undefined;
   var _loc5_ = undefined;
   var _loc6_ = undefined;
   var _loc7_ = undefined;
   var _loc8_ = undefined;
   var _loc9_ = undefined;
   var _loc10_ = undefined;
   var _loc11_ = undefined;
   var _loc12_ = undefined;
   var _loc13_ = undefined;
   var _loc14_ = undefined;
   if(success)
   {
      _loc4_ = new Array();
      trace("raceType: " + raceType);
      if(raceType == "a")
      {
         _loc6_ = 0;
         while(_loc6_ < this.firstChild.childNodes.length)
         {
            _loc7_ = 0;
            while(_loc7_ < this.firstChild.childNodes[_loc6_].childNodes.length)
            {
               _loc8_ = this.firstChild.childNodes[_loc6_].childNodes[_loc7_].attributes;
               _loc9_ = {i:_loc8_.i,n:_loc8_.n,tf:_loc8_.tf,s:Number(_loc8_.s),t:this.firstChild.childNodes[_loc6_].attributes.t};
               _loc4_.push(_loc9_);
               _loc7_ += 1;
            }
            _loc6_ += 1;
         }
         _loc4_.sortOn("s",Array.NUMERIC);
         _loc4_.reverse();
      }
      else
      {
         switch(raceType)
         {
            case "b":
               _loc5_ = 0;
               break;
            case "h":
               _loc5_ = 1;
         }
         _loc7_ = 0;
         while(_loc7_ < this.firstChild.childNodes[_loc5_].childNodes.length)
         {
            _loc8_ = this.firstChild.childNodes[_loc5_].childNodes[_loc7_].attributes;
            _loc9_ = {i:_loc8_.i,n:_loc8_.n,tf:_loc8_.tf,s:Number(_loc8_.s),t:this.firstChild.childNodes[_loc5_].attributes.t};
            _loc4_.push(_loc9_);
            _loc7_ += 1;
         }
      }
      trace("raceTypeIdx: " + _loc5_);
      _loc10_ = new Array();
      _loc11_ = _loc4_.length;
      _loc6_ = 0;
      while(_loc6_ < _loc11_)
      {
         _loc9_ = new Object();
         _loc9_.id = _loc4_[_loc6_].i;
         _loc9_.txtName = _loc4_[_loc6_].n;
         _loc9_.tf = _loc4_[_loc6_].tf;
         _loc14_ = Number(_loc4_[_loc6_].s);
         if(!_loc3_)
         {
            _loc3_ = _loc14_;
         }
         _loc9_.txtCol1 = _loc4_[_loc6_].s;
         _loc9_.txtCol2 = _loc4_[_loc6_].t != "b" ? "H2H" : "Bracket";
         if(_loc14_ != _loc13_)
         {
            _loc12_ = _loc6_ + 1;
            _loc13_ = _loc14_;
         }
         _loc9_.txtRank = _loc12_ + ".";
         _loc10_.push(_loc9_);
         _loc6_ += 1;
      }
      buildLeaderboard(_loc10_);
   }
};
if(periodType != newPeriodType || periodNum != newPeriodNum || isNewSection)
{
   periodType = newPeriodType;
   periodNum = newPeriodNum;
   _root.leaderboardGetContent(listType,periodType,periodNum);
   isNewSection = false;
}
else
{
   ksListXML.onLoad(true);
}
