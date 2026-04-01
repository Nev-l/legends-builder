class classes.RaceOpponent
{
   var arr;
   var iLast;
   var vv;
   function RaceOpponent()
   {
      this.arr = new Array();
      this.iLast = 0;
      this.vv = 0;
   }
   function addInt(tObj)
   {
      this.arr.push(tObj);
   }
   function getPos(t, lastTS)
   {
      var _loc4_ = 0.7;
      var _loc5_ = Math.max(0,t - _loc4_ * 1000);
      var _loc6_ = 0;
      var _loc7_ = this.arr.length;
      var _loc8_ = this.iLast;
      while(_loc8_ < _loc7_)
      {
         if(this.arr[_loc8_].t > _loc5_)
         {
            break;
         }
         _loc6_ = _loc8_;
         _loc8_ += 1;
      }
      var _loc9_ = undefined;
      var _loc10_ = undefined;
      var _loc11_ = undefined;
      var _loc12_ = undefined;
      var _loc13_ = undefined;
      var _loc14_ = undefined;
      if(isNaN(this.arr[_loc6_ + 1].t))
      {
         _loc10_ = (t - this.arr[_loc6_].t) / 1000;
         if(!_loc10_)
         {
            _loc10_ = (new Date() - lastTS) / 1000;
            _loc9_ = this.arr[_loc6_].d + this.arr[_loc6_].v * _loc10_ + 0.5 * this.arr[_loc6_].a * _loc10_ * _loc10_;
         }
         else
         {
            _loc9_ = this.arr[_loc6_].d + this.arr[_loc6_].v * _loc10_ + 0.5 * this.arr[_loc6_].a * _loc10_ * _loc10_;
         }
      }
      else
      {
         _loc11_ = this.arr[_loc6_ + 1].t - this.arr[_loc6_].t;
         _loc10_ = _loc11_ / 1000;
         _loc12_ = (_loc5_ - this.arr[_loc6_].t) / _loc11_;
         _loc13_ = this.arr[_loc6_].d + (this.arr[_loc6_ + 1].d - this.arr[_loc6_].d) * _loc12_;
         _loc14_ = Math.max(0,this.arr[_loc6_].v + (this.arr[_loc6_ + 1].v - this.arr[_loc6_].v) * _loc12_ + 0.5 * this.arr[_loc6_ + 1].a * _loc10_ * _loc10_);
         _loc9_ = _loc13_ + _loc14_ * _loc4_;
      }
      if(isNaN(_loc9_))
      {
         return -13;
      }
      return _loc9_;
   }
}
