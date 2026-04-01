class mx.data.binding.Binding
{
   var is2way;
   var dest;
   var source;
   var value;
   var format;
   var value2;
   var immediate;
   var binding;
   var queued = false;
   var reverse = false;
   static var counter = 0;
   static var screenRegistry = new Object();
   static var bindingRegistry = new Array();
   function Binding(source, dest, format, is2way)
   {
      mx.events.EventDispatcher.initialize(this);
      var _loc7_ = this;
      _loc7_.source = source;
      _loc7_.dest = dest;
      _loc7_.format = format;
      _loc7_.is2way = is2way;
      mx.data.binding.Binding.registerBinding(this);
      this.calcShortLoc(source);
      this.calcShortLoc(dest);
      _global.__dataLogger.logData(null,"Creating binding " + this.summaryString() + (!is2way ? "" : ", 2-way"),{binding:this});
      _global.__dataLogger.nestLevel += 1;
      mx.data.binding.ComponentMixins.initComponent(dest.component);
      if(source.component != undefined)
      {
         mx.data.binding.ComponentMixins.initComponent(source.component);
      }
      dest.component.addBinding(this);
      if(source.component != undefined)
      {
         source.component.addBinding(this);
         this.setUpListener(source,false);
         if(this.is2way)
         {
            this.setUpListener(dest,true);
            this.setUpIndexListeners(source,false);
            this.setUpIndexListeners(dest,true);
         }
         else
         {
            this.setUpIndexListeners(source,false);
            this.setUpIndexListeners(dest,false);
         }
      }
      else
      {
         this.execute();
      }
      _global.__dataLogger.nestLevel--;
   }
   function execute(reverse)
   {
      var _loc4_ = undefined;
      var _loc5_ = undefined;
      if(reverse)
      {
         if(!this.is2way)
         {
            _global.__dataLogger.logData(null,"Warning: Can\'t execute binding " + this.summaryString(false) + " in reverse, because it\'s not a 2 way binding",{binding:this},mx.data.binding.Log.BRIEF);
            return ["error"];
         }
         _loc4_ = this.dest;
         _loc5_ = this.source;
      }
      else
      {
         _loc4_ = this.source;
         _loc5_ = this.dest;
      }
      _global.__dataLogger.logData(null,"Executing binding " + this.summaryString(reverse),{binding:this});
      _global.__dataLogger.nestLevel += 1;
      var _loc6_ = undefined;
      if(_loc4_.constant != undefined)
      {
         _loc6_ = {value:new mx.data.binding.TypedValue(_loc4_.constant,"String"),getAnyTypedValue:function()
         {
            return this.value;
         },getTypedValue:function()
         {
            return this.value;
         },getGettableTypes:function()
         {
            return ["String"];
         }};
      }
      else
      {
         _loc6_ = _loc4_.component.getField(_loc4_.property,_loc4_.location,true);
      }
      var _loc7_ = undefined;
      var _loc8_ = undefined;
      var _loc9_ = "";
      var _loc10_ = _loc5_.component.getField(_loc5_.property,_loc5_.location);
      var _loc11_ = undefined;
      if(this.format != null)
      {
         _loc11_ = mx.data.binding.Binding.getRuntimeObject(this.format);
         if(_loc11_ != null)
         {
            if(reverse)
            {
               _loc11_.setupDataAccessor(_loc5_.component,_loc5_.property,_loc5_.location);
               _loc11_.dataAccessor = _loc10_;
               _loc10_ = _loc11_;
            }
            else
            {
               _loc11_.setupDataAccessor(_loc4_.component,_loc4_.property,_loc4_.location);
               _loc11_.dataAccessor = _loc6_;
               _loc6_ = _loc11_;
            }
         }
      }
      var _loc12_ = this.format != null ? null : _loc10_.getSettableTypes();
      var _loc13_ = _loc6_.getAnyTypedValue(_loc12_);
      var _loc14_ = new Object();
      var _loc15_ = undefined;
      var _loc16_ = undefined;
      if(_loc10_.type.readonly == true)
      {
         _global.__dataLogger.logData(null,"Not executing binding because the destination is read-only",null,mx.data.binding.Log.BRIEF);
         _loc15_ = new Object();
         _loc15_.type = "invalid";
         _loc15_.property = _loc5_.property;
         _loc15_.location = _loc5_.location;
         _loc15_.messages = [{message:"Cannot assign to a read-only data field."}];
         _loc5_.component.dispatchEvent(_loc15_);
         _loc14_.event = _loc15_;
      }
      else
      {
         _global.__dataLogger.logData(null,"Assigning new value \'<value>\' (<typeName>) " + _loc9_,{value:_loc13_.value,typeName:_loc13_.typeName,unformattedValue:_loc7_,formatterFrom:_loc8_});
         _loc16_ = _loc10_.setAnyTypedValue(_loc13_);
         _loc10_.validateAndNotify(_loc14_,false,_loc16_);
         _loc5_.component.dispatchEvent({type:"bindingExecuted",binding:this});
      }
      var _loc17_ = undefined;
      if(_loc14_.event != null)
      {
         if(_loc4_.component != null)
         {
            _loc17_ = new Object();
            _loc17_.type = _loc14_.event.type;
            _loc17_.property = _loc4_.property;
            _loc17_.location = _loc4_.location;
            _loc17_.messages = _loc14_.event.messages;
            _loc17_.to = _loc5_.component;
            _loc4_.component.dispatchEvent(_loc17_);
         }
      }
      _global.__dataLogger.nestLevel--;
      return _loc14_.event.messages;
   }
   function queueForExecute(reverse)
   {
      if(!this.queued)
      {
         if(_global.__databind_executeQueue == null)
         {
            _global.__databind_executeQueue = new Array();
         }
         if(_root.__databind_dispatch == undefined)
         {
            _root.createEmptyMovieClip("__databind_dispatch",-8888);
         }
         _global.__databind_executeQueue.push(this);
         this.queued = true;
         this.reverse = reverse;
         _root.__databind_dispatch.onEnterFrame = mx.data.binding.Binding.dispatchEnterFrame;
      }
   }
   static function dispatchEnterFrame()
   {
      _root.__databind_dispatch.onEnterFrame = null;
      var _loc3_ = 0;
      var _loc4_ = undefined;
      while(_loc3_ < _global.__databind_executeQueue.length)
      {
         _loc4_ = _global.__databind_executeQueue[_loc3_];
         _loc4_.execute(_loc4_.reverse);
         _loc3_ += 1;
      }
      var _loc5_ = undefined;
      while((_loc5_ = _global.__databind_executeQueue.pop()) != null)
      {
         _loc5_.queued = false;
         _loc5_.reverse = false;
      }
   }
   function calcShortLoc(endpoint)
   {
      var _loc2_ = endpoint.location;
      if(_loc2_.path != null)
      {
         _loc2_ = _loc2_.path;
      }
      endpoint.loc = !(_loc2_ instanceof Array) ? _loc2_ : _loc2_.join(".");
   }
   function summaryString(reverse)
   {
      var _loc3_ = "<binding.dest.component>:<binding.dest.property>:<binding.dest.loc>";
      var _loc4_ = "<binding.source.component>:<binding.source.property>:<binding.source.loc>";
      if(this.source.constant == null)
      {
         if(reverse == true)
         {
            return "from " + _loc3_ + " to " + _loc4_;
         }
         return "from " + _loc4_ + " to " + _loc3_;
      }
      return "from constant \'<binding.source.constant>\' to " + _loc3_;
   }
   static function getRuntimeObject(info, constructorParameter)
   {
      if(info.cls == undefined)
      {
         info.cls = mx.utils.ClassFinder.findClass(info.className);
      }
      var _loc4_ = new info.cls(constructorParameter);
      if(_loc4_ == null)
      {
         _global.__dataLogger.logData(null,"Could not construct a formatter or validator - new <info.className>(<params>)",{info:info,params:constructorParameter},mx.data.binding.Log.BRIEF);
      }
      for(var _loc5_ in info.settings)
      {
         _loc4_[_loc5_] = info.settings[_loc5_];
      }
      return _loc4_;
   }
   static function refreshFromSources(component, property, bindings)
   {
      var _loc4_ = null;
      var _loc5_ = undefined;
      _loc5_ = 0;
      var _loc6_ = undefined;
      var _loc7_ = undefined;
      while(_loc5_ < bindings.length)
      {
         _loc6_ = bindings[_loc5_];
         _loc7_ = null;
         if(_loc6_.dest.component == component && (property == null || property == _loc6_.dest.property))
         {
            _loc7_ = _loc6_.execute();
         }
         else if(_loc6_.is2way && _loc6_.source.component == component && (property == null || property == _loc6_.source.property))
         {
            _loc7_ = _loc6_.execute(true);
         }
         if(_loc7_ != null)
         {
            _loc4_ = _loc4_ != null ? _loc4_.concat(_loc7_) : _loc7_;
         }
         _loc5_ += 1;
      }
      return _loc4_;
   }
   static function refreshDestinations(component, bindings)
   {
      var _loc3_ = undefined;
      _loc3_ = 0;
      var _loc4_ = undefined;
      while(_loc3_ < bindings.length)
      {
         _loc4_ = bindings[_loc3_];
         if(_loc4_.source.component == component)
         {
            _loc4_.execute();
         }
         else if(_loc4_.is2way && _loc4_.dest.component == component)
         {
            _loc4_.execute(true);
         }
         _loc3_ += 1;
      }
      _loc3_ = 0;
      var _loc5_ = undefined;
      while(_loc3_ < component.__indexBindings.length)
      {
         _loc5_ = component.__indexBindings[_loc3_];
         _loc5_.binding.execute(_loc5_.reverse);
         _loc3_ += 1;
      }
   }
   static function okToCallGetterFromSetter()
   {
      function setter(val)
      {
         this.value2 = this.value;
      }
      function getter()
      {
         return 5;
      }
      var _loc2_ = new Object();
      _loc2_.addProperty("value",getter,setter);
      _loc2_.value = 0;
      var _loc3_ = _loc2_.value2 == _loc2_.value;
      return _loc3_;
   }
   function setUpListener(endpoint, reverse)
   {
      var _loc4_ = new Object();
      _loc4_.binding = this;
      _loc4_.property = endpoint.property;
      _loc4_.reverse = reverse;
      _loc4_.immediate = mx.data.binding.Binding.okToCallGetterFromSetter();
      _loc4_.handleEvent = function(event)
      {
         _global.__dataLogger.logData(event.target,"Data of property \'<property>\' has changed. <immediate>.",this);
         if(this.immediate)
         {
            if(this.binding.executing != true)
            {
               this.binding.executing = true;
               this.binding.execute(this.reverse);
               this.binding.executing = false;
            }
         }
         else
         {
            this.binding.queueForExecute(this.reverse);
         }
      };
      if(endpoint.event instanceof Array)
      {
         for(var _loc5_ in endpoint.event)
         {
            endpoint.component.__addHighPrioEventListener(endpoint.event[_loc5_],_loc4_);
         }
      }
      else
      {
         endpoint.component.__addHighPrioEventListener(endpoint.event,_loc4_);
      }
      mx.data.binding.ComponentMixins.initComponent(endpoint.component);
   }
   function setUpIndexListeners(endpoint, reverse)
   {
      var _loc4_ = undefined;
      var _loc5_ = undefined;
      if(endpoint.location.indices != undefined)
      {
         _loc4_ = 0;
         while(_loc4_ < endpoint.location.indices.length)
         {
            _loc5_ = endpoint.location.indices[_loc4_];
            if(_loc5_.component != undefined)
            {
               this.setUpListener(_loc5_,reverse);
               if(_loc5_.component.__indexBindings == undefined)
               {
                  _loc5_.component.__indexBindings = new Array();
               }
               _loc5_.component.__indexBindings.push({binding:this,reverse:reverse});
            }
            _loc4_ += 1;
         }
      }
   }
   static function copyBinding(b)
   {
      var _loc2_ = new Object();
      _loc2_.source = mx.data.binding.Binding.copyEndPoint(b.source);
      _loc2_.dest = mx.data.binding.Binding.copyEndPoint(b.dest);
      _loc2_.format = b.format;
      _loc2_.is2way = b.is2way;
      return _loc2_;
   }
   static function copyEndPoint(e)
   {
      var _loc2_ = new Object();
      _loc2_.constant = e.constant;
      _loc2_.component = String(e.component);
      _loc2_.event = e.event;
      _loc2_.location = e.location;
      _loc2_.property = e.property;
      return _loc2_;
   }
   static function registerScreen(screen, id)
   {
      var symbol = mx.data.binding.Binding.screenRegistry[id];
      if(symbol == null)
      {
         mx.data.binding.Binding.screenRegistry[id] = {symbolPath:String(screen),bindings:[],id:id};
         return undefined;
      }
      if(symbol.symbolPath == String(screen))
      {
         return undefined;
      }
      var instancePath = String(screen);
      var i = 0;
      while(i < mx.data.binding.Binding.bindingRegistry.length)
      {
         var b = mx.data.binding.Binding.bindingRegistry[i];
         var src = mx.data.binding.Binding.copyEndPoint(b.source);
         var dst = mx.data.binding.Binding.copyEndPoint(b.dest);
         var prefix = symbol.symbolPath + ".";
         var symbolContainsSource = prefix == b.source.component.substr(0,prefix.length);
         var symbolContainsDest = prefix == b.dest.component.substr(0,prefix.length);
         if(symbolContainsSource)
         {
            if(symbolContainsDest)
            {
               src.component = eval(instancePath + src.component.substr(symbol.symbolPath.length));
               dst.component = eval(instancePath + dst.component.substr(symbol.symbolPath.length));
               new mx.data.binding.Binding(src,dst,b.format,b.is2way);
            }
            else
            {
               src.component = eval(instancePath + src.component.substr(symbol.symbolPath.length));
               dst.component = eval(dst.component);
               new mx.data.binding.Binding(src,dst,b.format,b.is2way);
            }
         }
         else if(symbolContainsDest)
         {
            src.component = eval(src.component);
            dst.component = eval(instancePath + dst.component.substr(symbol.symbolPath.length));
            new mx.data.binding.Binding(src,dst,b.format,b.is2way);
         }
         i++;
      }
   }
   static function registerBinding(binding)
   {
      var _loc2_ = mx.data.binding.Binding.copyBinding(binding);
      mx.data.binding.Binding.bindingRegistry.push(_loc2_);
   }
   static function getLocalRoot(clip)
   {
      var _loc2_ = undefined;
      var _loc3_ = clip._url;
      while(clip != null)
      {
         if(clip._url != _loc3_)
         {
            break;
         }
         _loc2_ = clip;
         clip = clip._parent;
      }
      return _loc2_;
   }
}
