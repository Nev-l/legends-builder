function updateSwitcher(newLID)
{
   lid = newLID;
   _parent.locationID = lid;
   _parent.updateShopLocation();
   updateName();
   updateIcons(true);
   updateArrows();
   _parent.gotoAndPlay("refresh");
}
function updateName()
{
   var _loc3_ = 0;
   while(_loc3_ < _global.locationXML.firstChild.childNodes.length)
   {
      if(_global.locationXML.firstChild.childNodes[_loc3_].attributes.lid == lid)
      {
         txt = _global.locationXML.firstChild.childNodes[_loc3_].attributes.ln;
         break;
      }
      _loc3_ += 1;
   }
   txt += " ";
   if(_parent.storeType == 2)
   {
      txt += "Graphics";
   }
   else
   {
      txt += !_parent.shopName.length ? "" : _parent.shopName;
   }
}
function updateIcons(animate)
{
   var _loc2_ = undefined;
   var _loc3_ = 22;
   _loc2_ = lid / 100 - 1;
   iconsLineup.tx = (- _loc2_) * _loc3_;
   if(animate)
   {
      iconsLineup.onEnterFrame = function()
      {
         if(Math.abs(this.tx - this._x) > 0.1)
         {
            this._x += (this.tx - this._x) / 3;
         }
         else
         {
            this._x = this.tx;
            delete this.onEnterFrame;
         }
      };
   }
   else
   {
      iconsLineup._x = (- _loc2_) * _loc3_;
   }
   placeIcon.gotoAndStop(lid / 100);
}
function updateArrows()
{
   if(lid == 100)
   {
      arrowPrev.nextFrame();
      arrowNext.prevFrame();
   }
   else if(lid == 500)
   {
      arrowNext.nextFrame();
      arrowPrev.prevFrame();
   }
   else
   {
      arrowPrev.prevFrame();
      arrowNext.prevFrame();
   }
}
