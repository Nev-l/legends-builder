class classes.SCDial
{
   function SCDial()
   {
   }
   static function setSCDial(target, uCred)
   {
      uCred = Number(uCred);
      if(uCred || uCred === 0)
      {
         target.ticks.txt = String(uCred);
      }
      else
      {
         target.ticks.txt = "";
      }
      var _loc4_ = _global.scLevelsXML.firstChild;
      var _loc5_ = 0;
      var _loc6_ = undefined;
      var _loc7_ = undefined;
      var _loc8_ = undefined;
      while(_loc5_ < _loc4_.childNodes.length)
      {
         if(uCred < Number(_loc4_.childNodes[_loc5_].attributes.sc))
         {
            _loc6_ = new flash.filters.GlowFilter(Number("0x" + _loc4_.childNodes[_loc5_].attributes.c),75,3,3,3,3);
            _loc7_ = new Array();
            _loc7_.push(_loc6_);
            target.ticks.filters = _loc7_;
            target.txtLevel = _loc4_.childNodes[_loc5_].attributes.id;
            if(_loc5_ == 0)
            {
               break;
            }
            if(_loc5_ == _loc4_.childNodes.length - 1)
            {
               break;
            }
            _loc8_ = 0;
            while(_loc8_ < _loc4_.childNodes[_loc5_].childNodes.length)
            {
               if(uCred < Number(_loc4_.childNodes[_loc5_].childNodes[_loc8_].attributes.sc))
               {
                  target.ticks.gotoAndStop(_loc8_ + 2);
                  break;
               }
               _loc8_ += 1;
            }
            break;
         }
         _loc5_ += 1;
      }
   }
}
