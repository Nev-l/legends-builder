class mx.transitions.BroadcasterMX
{
   var _listeners;
   static var version = "1.1.0.52";
   function BroadcasterMX()
   {
   }
   static function initialize(o, dontCreateArray)
   {
      if(o.broadcastMessage != undefined)
      {
         delete o.broadcastMessage;
      }
      o.addListener = mx.transitions.BroadcasterMX.prototype.addListener;
      o.removeListener = mx.transitions.BroadcasterMX.prototype.removeListener;
      if(!dontCreateArray)
      {
         o._listeners = new Array();
      }
   }
   function addListener(o)
   {
      this.removeListener(o);
      if(this.broadcastMessage == undefined)
      {
         this.broadcastMessage = mx.transitions.BroadcasterMX.prototype.broadcastMessage;
      }
      return this._listeners.push(o);
   }
   function removeListener(o)
   {
      var _loc3_ = this._listeners;
      var _loc4_ = _loc3_.length;
      while(true)
      {
         _loc4_;
         if(!_loc4_--)
         {
            break;
         }
         if(_loc3_[_loc4_] == o)
         {
            _loc3_.splice(_loc4_,1);
            if(!_loc3_.length)
            {
               this.broadcastMessage = undefined;
            }
            return true;
         }
      }
      return false;
   }
   function broadcastMessage()
   {
      var _loc3_ = String(arguments.shift());
      var _loc4_ = this._listeners.concat();
      var _loc5_ = _loc4_.length;
      var _loc6_ = 0;
      while(_loc6_ < _loc5_)
      {
         _loc4_[_loc6_][_loc3_].apply(_loc4_[_loc6_],arguments);
         _loc6_ += 1;
      }
   }
}
