class mx.data.binding.ComponentMixins
{
   var __refreshing;
   var __bindings;
   var __schema;
   var __fieldCache;
   var _eventDispatcher;
   var dispatchQueue;
   var __highPrioEvents;
   var _databinding_original_dispatchEvent;
   function ComponentMixins()
   {
   }
   function refreshFromSources()
   {
      if(this.__refreshing != null)
      {
         return undefined;
      }
      this.__refreshing = true;
      _global.__dataLogger.logData(this,"Refreshing from sources");
      _global.__dataLogger.nestLevel += 1;
      mx.data.binding.Binding.refreshFromSources(this,null,this.__bindings);
      _global.__dataLogger.nestLevel--;
      this.__refreshing = null;
   }
   function refreshDestinations()
   {
      _global.__dataLogger.logData(this,"Refreshing Destinations");
      _global.__dataLogger.nestLevel += 1;
      mx.data.binding.Binding.refreshDestinations(this,this.__bindings);
      _global.__dataLogger.nestLevel--;
   }
   function validateProperty(property, initialMessages)
   {
      var _loc5_ = null;
      var _loc6_ = this.getField(property);
      if(_loc6_ != null)
      {
         _loc5_ = _loc6_.validateAndNotify(null,null,initialMessages);
      }
      else
      {
         _global.__dataLogger.logData(this,"Can\'t validate property \'<property>\' because it doesn\'t exist",{property:property});
      }
      return _loc5_;
   }
   function addBinding(binding)
   {
      if(this.__bindings == undefined)
      {
         this.__bindings = new Array();
      }
      this.__bindings.push(binding);
      var _loc3_ = false;
      if(binding.source.component == this)
      {
         this.getField(binding.source.property,binding.source.location);
         _loc3_ = true;
      }
      if(binding.dest.component == this)
      {
         this.getField(binding.dest.property,binding.dest.location);
         _loc3_ |= Object(binding).is2way;
      }
      var _loc4_ = undefined;
      if(_loc3_)
      {
         _loc4_ = binding.dest.component.findSchema(binding.dest.property,binding.dest.location);
         if(_loc4_.readonly)
         {
            binding.source.component.__setReadOnly(true);
         }
      }
   }
   static function initComponent(component)
   {
      var _loc2_ = mx.data.binding.ComponentMixins.prototype;
      if(component.refreshFromSources == undefined)
      {
         component.refreshFromSources = _loc2_.refreshFromSources;
      }
      if(component.refreshDestinations == undefined)
      {
         component.refreshDestinations = _loc2_.refreshDestinations;
      }
      if(component.validateProperty == undefined)
      {
         component.validateProperty = _loc2_.validateProperty;
      }
      if(component.createFieldAccessor == undefined)
      {
         component.createFieldAccessor = _loc2_.createFieldAccessor;
      }
      if(component.createField == undefined)
      {
         component.createField = _loc2_.createField;
      }
      if(component.addBinding == undefined)
      {
         component.addBinding = _loc2_.addBinding;
      }
      if(component.findSchema == undefined)
      {
         component.findSchema = _loc2_.findSchema;
      }
      if(component.getField == undefined)
      {
         component.getField = _loc2_.getField;
      }
      if(component.refreshAndValidate == undefined)
      {
         component.refreshAndValidate = _loc2_.refreshAndValidate;
      }
      if(component.getFieldFromCache == undefined)
      {
         component.getFieldFromCache = _loc2_.getFieldFromCache;
      }
      if(component.getBindingMetaData == undefined)
      {
         component.getBindingMetaData = _loc2_.getBindingMetaData;
      }
      if(component.__setReadOnly == undefined)
      {
         component.__setReadOnly = _loc2_.__setReadOnly;
      }
      if(component.__addHighPrioEventListener == undefined)
      {
         component.__addHighPrioEventListener = _loc2_.__addHighPrioEventListener;
      }
   }
   function createFieldAccessor(property, location, mustExist)
   {
      return mx.data.binding.FieldAccessor.createFieldAccessor(this,property,location,mx.data.binding.FieldAccessor.findElementType(this.__schema,property),mustExist);
   }
   function findSchema(property, location)
   {
      if(typeof location == "string")
      {
         if(!mx.data.binding.FieldAccessor.isActionScriptPath(String(location)))
         {
            return null;
         }
         location = location.split(".");
      }
      var _loc4_ = mx.data.binding.FieldAccessor.findElementType(this.__schema,property);
      var _loc5_ = undefined;
      var _loc6_ = undefined;
      if(location != null)
      {
         if(location.path != null)
         {
            location = location.path;
         }
         if(!(location instanceof Array))
         {
            return null;
         }
         _loc5_ = 0;
         while(_loc5_ < location.length)
         {
            _loc6_ = location[_loc5_];
            _loc4_ = mx.data.binding.FieldAccessor.findElementType(_loc4_,_loc6_);
            _loc5_ += 1;
         }
      }
      return _loc4_;
   }
   function createField(property, location)
   {
      var _loc4_ = this.findSchema(property,location);
      var _loc5_ = undefined;
      if(_loc4_.validation != null)
      {
         _loc5_ = mx.data.binding.Binding.getRuntimeObject(_loc4_.validation);
      }
      else
      {
         _loc5_ = new mx.data.binding.DataType();
      }
      _loc5_.setupDataAccessor(this,property,location);
      return _loc5_;
   }
   static function deepEqual(a, b)
   {
      if(a == b)
      {
         return true;
      }
      if(typeof a != typeof b)
      {
         return false;
      }
      if(typeof a != "object")
      {
         return false;
      }
      var _loc3_ = new Object();
      for(var _loc4_ in a)
      {
         if(!mx.data.binding.ComponentMixins.deepEqual(a[_loc4_],b[_loc4_]))
         {
            return false;
         }
         _loc3_[_loc4_] = 1;
      }
      for(_loc4_ in b)
      {
         if(_loc3_[_loc4_] != 1)
         {
            return false;
         }
      }
      return true;
   }
   function getFieldFromCache(property, location)
   {
      var _loc4_ = undefined;
      for(_loc5_ in this.__fieldCache)
      {
         _loc4_ = this.__fieldCache[_loc5_];
         if(_loc4_.property == property && mx.data.binding.ComponentMixins.deepEqual(_loc4_.location,location))
         {
            return _loc4_;
         }
      }
      return null;
   }
   function getField(property, location)
   {
      var _loc4_ = this.getFieldFromCache(property,location);
      if(_loc4_ != null)
      {
         return _loc4_;
      }
      _loc4_ = this.createField(property,location);
      if(this.__fieldCache == null)
      {
         this.__fieldCache = new Array();
      }
      this.__fieldCache.push(_loc4_);
      return _loc4_;
   }
   function refreshAndValidate(property)
   {
      _global.__dataLogger.logData(this,"Refreshing and validating " + property);
      _global.__dataLogger.nestLevel += 1;
      var _loc4_ = mx.data.binding.Binding.refreshFromSources(this,property,this.__bindings);
      _loc4_ = this.validateProperty(property,_loc4_);
      _global.__dataLogger.nestLevel--;
      return _loc4_ == null;
   }
   function getBindingMetaData(name)
   {
      return this["__" + name];
   }
   function __setReadOnly(setting)
   {
      if(Object(this).editable != undefined)
      {
         Object(this).editable = !setting;
      }
   }
   function __addHighPrioEventListener(event, handler)
   {
      var _loc5_ = this._eventDispatcher == undefined ? this : this._eventDispatcher;
      if(_loc5_.__highPrioEvents == undefined)
      {
         _loc5_.__highPrioEvents = new Object();
      }
      var _loc6_ = "__q_" + event;
      if(_loc5_.__highPrioEvents[_loc6_] == undefined)
      {
         _loc5_.__highPrioEvents[_loc6_] = new Array();
      }
      _global.ASSetPropFlags(_loc5_.__highPrioEvents,_loc6_,1);
      mx.events.EventDispatcher._removeEventListener(_loc5_.__highPrioEvents[_loc6_],event,handler);
      _loc5_.__highPrioEvents[_loc6_].push(handler);
      if(_loc5_._databinding_original_dispatchEvent == undefined)
      {
         _loc5_._databinding_original_dispatchEvent = _loc5_.dispatchEvent;
         _loc5_.dispatchEvent = function(eventObj)
         {
            if(eventObj.target == undefined)
            {
               eventObj.target = this;
            }
            this.dispatchQueue(this.__highPrioEvents,eventObj);
            this._databinding_original_dispatchEvent(eventObj);
         };
      }
   }
}
