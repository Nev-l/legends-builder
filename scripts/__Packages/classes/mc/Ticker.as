class classes.mc.Ticker extends MovieClip
{
   var tf;
   var onEnterFrame;
   var count = 0;
   static var xInit = 800;
   static var yInit = 1;
   var xStep = 3;
   function Ticker()
   {
      super();
      this.tf = new TextFormat();
      this.tf.font = "Arial";
      this.tf.size = 12;
      this.tf.color = 16777215;
      this.onEnterFrame = function()
      {
         for(var _loc2_ in this)
         {
            if(_loc2_.substr(0,6) == "txtfld")
            {
               this[_loc2_]._x -= this.xStep;
               if(this[_loc2_]._x + this[_loc2_]._width < 0)
               {
                  this[_loc2_].removeTextField();
               }
            }
         }
      };
   }
   function addText(txt)
   {
      trace("addText: " + txt);
      if(!txt.length)
      {
         return undefined;
      }
      var _loc3_ = classes.mc.Ticker.xInit;
      var _loc4_ = undefined;
      for(var _loc5_ in this)
      {
         if(_loc5_.substr(0,6) == "txtfld")
         {
            _loc4_ = this[_loc5_]._x + this[_loc5_]._width + 12;
            if(_loc4_ > _loc3_)
            {
               _loc3_ = Math.round(_loc4_);
            }
         }
      }
      var _loc6_ = this.createTextField("txtfld" + this.count,this.count,_loc3_,classes.mc.Ticker.yInit,10,16);
      _loc6_.selectable = false;
      _loc6_.embedFonts = true;
      _loc6_.autoSize = true;
      _loc6_.setNewTextFormat(this.tf);
      _loc6_.text = txt;
      this.count += 1;
   }
   function get __count()
   {
      return this.count;
   }
}
