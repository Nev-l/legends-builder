class mx.data.binding.FieldAccessor
{
   var component;
   var property;
   var parentObj;
   var fieldName;
   var m_location;
   var type;
   var index;
   var xpath;
   var data;
   static var xmlNodeFactory = new XML();
   function FieldAccessor(component, property, parentObj, fieldName, type, index, parentField)
   {
      this.component = component;
      this.property = property;
      this.parentObj = parentObj;
      this.fieldName = fieldName;
      if(component == parentObj)
      {
         this.m_location = undefined;
      }
      else if(parentField.m_location == undefined)
      {
         this.m_location = fieldName;
      }
      else
      {
         this.m_location = parentField.m_location + "." + fieldName;
      }
      this.type = type;
      this.index = index;
   }
   function getValue()
   {
      var _loc2_ = this.getFieldData();
      var _loc3_ = undefined;
      if(_loc2_ == null && this.type.value != undefined)
      {
         _loc3_ = new mx.data.binding.TypedValue(this.type.value,"String");
         _loc3_.getDefault = true;
         this.component.getField(this.fieldName).setAnyTypedValue(_loc3_);
         _loc2_ = _loc3_.value;
      }
      if(this.isXML(_loc2_) && _loc2_.childNodes.length == 1 && _loc2_.firstChild.nodeType == 3)
      {
         return _loc2_.firstChild.nodeValue;
      }
      return _loc2_;
   }
   function setValue(newValue, newTypedValue)
   {
      var _loc5_ = undefined;
      if(newTypedValue.getDefault)
      {
         newTypedValue.value = newValue;
      }
      else
      {
         if(this.xpath != null)
         {
            _loc5_ = this.getFieldData();
            if(_loc5_ != null)
            {
               mx.data.binding.FieldAccessor.setXMLData(_loc5_,newValue);
            }
            else
            {
               _global.__dataLogger.logData(this.component,"Can\'t assign to \'<property>:<xpath>\' because there is no element at the given path",this);
            }
         }
         else if(this.isXML(this.parentObj))
         {
            if(this.type.category == "attribute")
            {
               this.parentObj.attributes[this.fieldName] = newValue;
            }
            else if(this.type.category != "array")
            {
               _loc5_ = this.getOrCreateFieldData();
               mx.data.binding.FieldAccessor.setXMLData(_loc5_,newValue);
            }
         }
         else
         {
            if(this.parentObj == null)
            {
               _global.__dataLogger.logData(this.component,"Can\'t set field \'<property>/<location>\' because the field doesn\'t exist",this);
            }
            this.parentObj[this.fieldName] = newValue;
         }
         this.component.propertyModified(this.property,this.xpath == null && this.parentObj == this.component,newTypedValue.type);
      }
   }
   static function isActionScriptPath(str)
   {
      var _loc2_ = str.toLowerCase();
      var _loc3_ = "0123456789abcdefghijklmnopqrstuvwxyz_.";
      var _loc4_ = 0;
      while(_loc4_ < _loc2_.length)
      {
         if(-1 == _loc3_.indexOf(_loc2_.charAt(_loc4_)))
         {
            return false;
         }
         _loc4_ += 1;
      }
      return true;
   }
   static function createFieldAccessor(component, property, location, type, mustExist)
   {
      if(mustExist && component[property] == null)
      {
         _global.__dataLogger.logData(component,"Warning: property \'<property>\' does not exist",{property:property});
         return null;
      }
      var _loc7_ = new mx.data.binding.FieldAccessor(component,property,component,property,type,null,null);
      if(location == null)
      {
         return _loc7_;
      }
      var _loc8_ = null;
      if(location.indices != null)
      {
         _loc8_ = location.indices;
         location = location.path;
      }
      if(typeof location == "string")
      {
         if(_loc8_ != null)
         {
            _global.__dataLogger.logData(component,"Warning: ignoring index values for property \'<property>\', path \'<location>\'",{property:property,location:location});
         }
         if(!mx.data.binding.FieldAccessor.isActionScriptPath(String(location)))
         {
            _loc7_.xpath = location;
            return _loc7_;
         }
         location = location.split(".");
      }
      var _loc9_ = undefined;
      var _loc10_ = undefined;
      var _loc11_ = undefined;
      var _loc12_ = undefined;
      if(location instanceof Array)
      {
         _loc10_ = 0;
         _loc9_ = 0;
         while(_loc9_ < location.length)
         {
            _loc11_ = null;
            _loc12_ = location[_loc9_];
            if(_loc12_ == "[n]")
            {
               if(_loc8_ == null)
               {
                  _global.__dataLogger.logData(component,"Error: indices for <property>:<location> are null, but [n] appears in the location.",{property:property,location:location});
                  return null;
               }
               _loc10_;
               _loc11_ = _loc8_[_loc10_++];
               if(_loc11_ == null)
               {
                  _global.__dataLogger.logData(component,"Error: not enough index values for <property>:<location>",{property:property,location:location});
                  return null;
               }
            }
            _loc7_ = _loc7_.getChild(_loc12_,_loc11_,mustExist);
            _loc9_ += 1;
         }
         if(mustExist && _loc7_.getValue() == null)
         {
            _global.__dataLogger.logData(component,"Warning: field <property>:<m_location> does not exist, or is null",_loc7_);
         }
         return _loc7_;
      }
      trace("unrecognized location: " + mx.data.binding.ObjectDumper.toString(location));
      return null;
   }
   function getFieldAccessor()
   {
      return this;
   }
   function getChild(childName, index, mustExist)
   {
      if(childName == ".")
      {
         return this;
      }
      var _loc5_ = this.getOrCreateFieldData(mustExist);
      if(_loc5_ == null)
      {
         return null;
      }
      var _loc6_ = mx.data.binding.FieldAccessor.findElementType(this.type,childName);
      return new mx.data.binding.FieldAccessor(this.component,this.property,_loc5_,childName,_loc6_,index,this);
   }
   function getOrCreateFieldData(mustExist)
   {
      var _loc4_ = this.getFieldData();
      if(_loc4_ == null)
      {
         if(mustExist)
         {
            _global.__dataLogger.logData(this.component,"Warning: field <property>:<m_location> does not exist",this);
         }
         else
         {
            this.setupComplexField();
            _loc4_ = this.getFieldData();
         }
      }
      return _loc4_;
   }
   function evaluateSubPath(obj, type)
   {
      var path = type.path;
      if(mx.data.binding.FieldAccessor.isActionScriptPath(path))
      {
         var tokens = path.split(".");
         var i = 0;
         while(i < tokens.length)
         {
            var token = tokens[i];
            if(this.isXML(obj))
            {
               obj = obj.firstChild;
               while(obj != null)
               {
                  if(mx.data.binding.FieldAccessor.toLocalName(obj.nodeName) == token)
                  {
                     break;
                  }
                  obj = obj.nextSibling;
               }
            }
            else
            {
               obj = obj[token];
            }
            if(obj == null)
            {
               _global.__dataLogger.logData(this.component,"Warning: path \'<path>\' evaluates to null, at \'<token>\' in <t.property>:<t.m_location>",{path:path,token:token,t:this});
               break;
            }
            i++;
         }
      }
      else if(this.isXML(obj))
      {
         if(path.charAt(0) != "/")
         {
            path = "/" + path;
         }
         if(obj.nodeName == null)
         {
            obj = obj.firstChild;
         }
         else
         {
            path = mx.data.binding.FieldAccessor.toLocalName(obj.nodeName) + path;
         }
         var category = type.category == null ? (type.elements.length <= 0 ? "simple" : "complex") : type.category;
         if(category == "simple" || category == "attribute")
         {
            obj = eval("obj" + mx.xpath.XPathAPI.getEvalString(obj,path));
         }
         else if(category == "complex")
         {
            obj = mx.xpath.XPathAPI.selectSingleNode(obj,path);
         }
         else if(category == "array")
         {
            obj = mx.xpath.XPathAPI.selectNodeList(obj,path);
         }
      }
      else
      {
         _global.__dataLogger.logData(this.component,"Error: path \'<path>\' is an XPath. It cannot be applied to non-XML data <t.property>:<t.m_location>",{path:path,t:this});
      }
      return obj;
   }
   function getFieldData()
   {
      var _loc3_ = undefined;
      var _loc4_ = undefined;
      if(this.xpath != null)
      {
         _loc3_ = this.parentObj[this.fieldName].firstChild;
         while(_loc3_ != null && _loc3_.nodeType != 1)
         {
            _loc3_ = _loc3_.nextSibling;
         }
         _loc4_ = mx.xpath.XPathAPI.selectSingleNode(_loc3_,this.xpath);
         return _loc4_;
      }
      var _loc5_ = undefined;
      var _loc6_ = undefined;
      var _loc7_ = undefined;
      if(this.isXML(this.parentObj))
      {
         if(this.type.path != null)
         {
            return this.evaluateSubPath(this.parentObj,this.type);
         }
         if(this.type.category == "attribute")
         {
            _loc5_ = this.parentObj.attributes;
            for(var _loc8_ in _loc5_)
            {
               if(mx.data.binding.FieldAccessor.toLocalName(_loc8_) == this.fieldName)
               {
                  return _loc5_[_loc8_];
               }
            }
            return undefined;
         }
         _loc6_ = this.parentObj.firstChild;
         if(this.type.category == "array")
         {
            _loc7_ = new Array();
            while(_loc6_ != null)
            {
               if(mx.data.binding.FieldAccessor.toLocalName(_loc6_.nodeName) == this.fieldName)
               {
                  _loc7_.push(_loc6_);
               }
               _loc6_ = _loc6_.nextSibling;
            }
            return _loc7_;
         }
         while(_loc6_ != null)
         {
            if(mx.data.binding.FieldAccessor.toLocalName(_loc6_.nodeName) == this.fieldName)
            {
               return _loc6_;
            }
            _loc6_ = _loc6_.nextSibling;
         }
         return null;
      }
      var _loc9_ = undefined;
      var _loc10_ = undefined;
      if(this.fieldName == "[n]")
      {
         if(this.index.component != null)
         {
            _loc10_ = this.index.component.getField(this.index.property,this.index.location);
            _loc9_ = _loc10_.getAnyTypedValue(["Number"]);
            _loc9_ = _loc9_.value;
         }
         else
         {
            _loc9_ = this.index.constant;
         }
         var _loc11_ = Number(_loc9_);
         if(typeof _loc9_ == "undefined")
         {
            _global.__dataLogger.logData(this.component,"Error: index specification \'<index>\' was not supplied, or incorrect, for <t.property>:<t.m_location>",{index:_loc11_,t:this});
            return null;
         }
         if(_loc11_.toString() == "NaN")
         {
            _global.__dataLogger.logData(this.component,"Error: index value \'<index>\' for <t.property>:<t.m_location> is not a number",{index:_loc11_,t:this});
            return null;
         }
         if(!(this.parentObj instanceof Array))
         {
            _global.__dataLogger.logData(this.component,"Error: indexed field <property>:<m_location> is not an array",this);
            return null;
         }
         if(_loc11_ < 0 || _loc11_ >= this.parentObj.length)
         {
            _global.__dataLogger.logData(this.component,"Error: index \'<index>\' for <t.property>:<t.m_location> is out of bounds",{index:_loc11_,t:this});
            return null;
         }
         _global.__dataLogger.logData(this.component,"Accessing item [<index>] of <t.property>:<t.m_location>",{index:_loc11_,t:this});
         return this.parentObj[_loc11_];
      }
      if(this.type.path != null)
      {
         return this.evaluateSubPath(this.parentObj,this.type);
      }
      return this.parentObj[this.fieldName];
   }
   static function setXMLData(obj, newValue)
   {
      while(obj.hasChildNodes())
      {
         obj.firstChild.removeNode();
      }
      var _loc3_ = mx.data.binding.FieldAccessor.xmlNodeFactory.createTextNode(newValue);
      obj.appendChild(_loc3_);
   }
   function setupComplexField()
   {
      var _loc2_ = undefined;
      if(this.isXML(this.parentObj))
      {
         _loc2_ = mx.data.binding.FieldAccessor.xmlNodeFactory.createElement(this.fieldName);
         this.parentObj.appendChild(_loc2_);
      }
      else if(this.dataIsXML())
      {
         this.parentObj[this.fieldName] = new XML();
      }
      else
      {
         this.parentObj[this.fieldName] = new Object();
      }
   }
   static function findElementType(type, name)
   {
      var _loc3_ = 0;
      while(_loc3_ < type.elements.length)
      {
         if(type.elements[_loc3_].name == name)
         {
            return type.elements[_loc3_].type;
         }
         _loc3_ += 1;
      }
      return null;
   }
   function isXML(obj)
   {
      return obj instanceof XMLNode;
   }
   function dataIsXML()
   {
      return this.type.name == "XML";
   }
   static function accessField(component, fieldName, desiredTypes)
   {
      var _loc4_ = undefined;
      _loc4_ = desiredTypes[fieldName];
      if(_loc4_ == null)
      {
         _loc4_ = desiredTypes.dflt;
      }
      if(_loc4_ == null)
      {
         _loc4_ = desiredTypes;
      }
      var _loc5_ = component.createField("data",[fieldName]);
      var _loc6_ = _loc5_.getAnyTypedValue([_loc4_]);
      return _loc6_.value;
   }
   static function ExpandRecord(obj, objectType, desiredTypes)
   {
      var _loc5_ = new Object();
      mx.data.binding.ComponentMixins.initComponent(_loc5_);
      _loc5_.data = obj;
      _loc5_.__schema = {elements:[{name:"data",type:objectType}]};
      var _loc6_ = new Object();
      var _loc7_ = undefined;
      var _loc8_ = undefined;
      var _loc9_ = undefined;
      if(objectType.elements.length > 0)
      {
         _loc7_ = 0;
         while(_loc7_ < objectType.elements.length)
         {
            _loc8_ = objectType.elements[_loc7_].name;
            _loc6_[_loc8_] = mx.data.binding.FieldAccessor.accessField(_loc5_,_loc8_,desiredTypes);
            _loc7_ += 1;
         }
      }
      else if(obj instanceof XML || obj instanceof XMLNode)
      {
         if(obj.childNodes.length == 1 && obj.firstChild.nodeType == 3)
         {
            return obj.firstChild.nodeValue;
         }
         _loc9_ = obj.lastChild;
         while(_loc9_ != null)
         {
            _loc8_ = mx.data.binding.FieldAccessor.toLocalName(_loc9_.nodeName);
            if(_loc8_ != null && _loc6_[_loc8_] == null)
            {
               _loc6_[_loc8_] = mx.data.binding.FieldAccessor.accessField(_loc5_,_loc8_,desiredTypes);
            }
            _loc9_ = _loc9_.previousSibling;
         }
         for(_loc8_ in obj.attributes)
         {
            if(_loc6_[_loc8_] != null)
            {
               _global.__dataLogger.logData(null,"Warning: attribute \'<name>\' has same name as an element, in XML object <obj>",{name:_loc8_,obj:obj});
            }
            _loc6_[_loc8_] = mx.data.binding.FieldAccessor.accessField(_loc5_,_loc8_,desiredTypes);
         }
      }
      else
      {
         if(typeof obj != "object")
         {
            return obj;
         }
         for(_loc8_ in obj)
         {
            _loc6_[_loc8_] = mx.data.binding.FieldAccessor.accessField(_loc5_,_loc8_,desiredTypes);
         }
      }
      return _loc6_;
   }
   static function wrapArray(theArray, itemType, desiredTypes)
   {
      var _loc3_ = {getItemAt:function(index)
      {
         if(index < 0 || index >= this.data.length)
         {
            return undefined;
         }
         var _loc3_ = this.data[index];
         if(_loc3_ == undefined)
         {
            return undefined;
         }
         var _loc4_ = mx.data.binding.FieldAccessor.ExpandRecord(_loc3_,this.type,desiredTypes);
         return _loc4_;
      },getItemID:function(index)
      {
         return index;
      },data:theArray,type:itemType,length:theArray.length};
      return _loc3_;
   }
   static function toLocalName(nodeName)
   {
      var _loc2_ = nodeName.split(":");
      var _loc3_ = _loc2_[_loc2_.length - 1];
      return _loc3_;
   }
}
