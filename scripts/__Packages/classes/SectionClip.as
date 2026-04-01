class classes.SectionClip extends MovieClip
{
   var image_bitmap;
   var img_mc;
   var myClr;
   var clrOverlay;
   function SectionClip()
   {
      super();
   }
   function getGridColorPoint(clr)
   {
      var _loc3_ = undefined;
      var _loc4_ = 12;
      var _loc5_ = undefined;
      var _loc6_ = undefined;
      var _loc7_ = undefined;
      var _loc8_ = 0;
      var _loc9_ = undefined;
      while(_loc8_ < 16)
      {
         _loc9_ = 0;
         while(_loc9_ < 7)
         {
            _loc5_ = 1 + _loc8_ * _loc4_;
            _loc6_ = 1 + _loc9_ * _loc4_;
            _loc3_ = this.image_bitmap.getPixel(_loc5_,_loc6_);
            if(_loc3_ == clr)
            {
               _loc7_ = new flash.geom.Point(_loc5_ - 1,_loc6_ - 1);
               break;
            }
            _loc9_ += 1;
         }
         if(_loc3_ == clr)
         {
            break;
         }
         _loc8_ += 1;
      }
      return _loc7_;
   }
   function setGridColorHilite(pp)
   {
      if(pp != undefined)
      {
         this.img_mc.hilite._x = pp.x;
         this.img_mc.hilite._y = pp.y;
         this.img_mc.hilite._visible = true;
      }
      else
      {
         this.img_mc.hilite._visible = false;
      }
   }
   function paintOverlay(clr)
   {
      this.myClr.setRGB(Number("0x" + clr));
      this.clrOverlay._alpha = 80;
   }
}
