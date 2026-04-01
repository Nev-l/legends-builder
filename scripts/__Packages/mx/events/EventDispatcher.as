class mx.events.EventDispatcher
{
   static var _fEventDispatcher = undefined;
   static var exceptions = {move:1,draw:1,load:1};
   function EventDispatcher()
   {
   }
   static function _removeEventListener(queue, event, handler)
   {
      var _loc4_ = undefined;
      var _loc5_ = undefined;
      var _loc6_ = undefined;
      if(queue != undefined)
      {
         _loc4_ = queue.length;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = queue[_loc5_];
            if(_loc6_ == handler)
            {
               queue.splice(_loc5_,1);
               return undefined;
            }
            _loc5_ += 1;
         }
      }
   }
   static function initialize(object)
   {
      if(mx.events.EventDispatcher._fEventDispatcher == undefined)
      {
         mx.events.EventDispatcher._fEventDispatcher = new mx.events.EventDispatcher();
      }
      object.addEventListener = mx.events.EventDispatcher._fEventDispatcher.addEventListener;
      object.removeEventListener = mx.events.EventDispatcher._fEventDispatcher.removeEventListener;
      object.dispatchEvent = mx.events.EventDispatcher._fEventDispatcher.dispatchEvent;
      object.dispatchQueue = mx.events.EventDispatcher._fEventDispatcher.dispatchQueue;
   }
   function dispatchQueue(queueObj, eventObj)
   {
      var _loc3_ = "__q_" + eventObj.type;
      var _loc4_ = queueObj[_loc3_];
      var _loc5_ = undefined;
      var _loc6_ = undefined;
      var _loc7_ = undefined;
      if(_loc4_ != undefined)
      {
         for(_loc5_ in _loc4_)
         {
            _loc6_ = _loc4_[_loc5_];
            _loc7_ = typeof _loc6_;
            if(_loc7_ == "object" || _loc7_ == "movieclip")
            {
               if(_loc6_.handleEvent != undefined)
               {
                  _loc6_.handleEvent(eventObj);
               }
               if(_loc6_[eventObj.type] != undefined)
               {
                  if(mx.events.EventDispatcher.exceptions[eventObj.type] == undefined)
                  {
                     _loc6_[eventObj.type](eventObj);
                  }
               }
            }
            else
            {
               _loc6_.apply(queueObj,[eventObj]);
            }
         }
      }
   }
   function dispatchEvent(eventObj)
   {
      if(eventObj.target == undefined)
      {
         eventObj.target = this;
      }
      this[eventObj.type + "Handler"](eventObj);
      this.dispatchQueue(this,eventObj);
   }
   function addEventListener(event, handler)
   {
      var _loc5_ = "__q_" + event;
      if(this[_loc5_] == undefined)
      {
         this[_loc5_] = new Array();
      }
      _global.ASSetPropFlags(this,_loc5_,1);
      mx.events.EventDispatcher._removeEventListener(this[_loc5_],event,handler);
      this[_loc5_].push(handler);
   }
   function removeEventListener(event, handler)
   {
      var _loc4_ = "__q_" + event;
      mx.events.EventDispatcher._removeEventListener(this[_loc4_],event,handler);
   }
}
