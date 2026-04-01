class mx.xpath.XPathAPI
{
   function XPathAPI()
   {
   }
   static function getEvalString(node, path)
   {
      var _loc3_ = "";
      var _loc4_ = null;
      var _loc5_ = mx.xpath.XPathAPI.getPathSet(path);
      var _loc6_ = _loc5_[0].nodeName;
      var _loc7_ = undefined;
      var _loc8_ = node;
      var _loc9_ = false;
      var _loc10_ = undefined;
      var _loc11_ = undefined;
      if(_loc6_ != undefined && (_loc6_ == "*" || node.nodeName == _loc6_))
      {
         _loc10_ = 1;
         while(_loc10_ < _loc5_.length)
         {
            _loc6_ = _loc5_[_loc10_].nodeName;
            _loc7_ = _loc6_.indexOf("@");
            if(_loc7_ >= 0)
            {
               _loc6_ = _loc6_.substring(_loc7_ + 1);
               _loc9_ = _loc8_.attributes[_loc6_] != undefined;
               _loc3_ += ".attributes." + _loc6_;
            }
            else
            {
               _loc9_ = false;
               _loc11_ = 0;
               while(_loc11_ < _loc8_.childNodes.length)
               {
                  _loc4_ = _loc8_.childNodes[_loc11_];
                  if(_loc4_.nodeName == _loc6_)
                  {
                     _loc3_ += ".childNodes." + _loc11_;
                     _loc11_ = _loc8_.childNodes.length;
                     _loc8_ = _loc4_;
                     _loc9_ = true;
                  }
                  _loc11_ += 1;
               }
            }
            if(!_loc9_)
            {
               return "";
            }
            _loc10_ += 1;
         }
         if(!_loc9_)
         {
            _loc3_ = "";
         }
         else if(_loc7_ == -1)
         {
            _loc3_ += ".firstChild.nodeValue";
         }
      }
      else
      {
         _loc3_ = "";
      }
      return _loc3_;
   }
   static function selectNodeList(node, path)
   {
      var _loc3_ = new Array(node);
      var _loc4_ = mx.xpath.XPathAPI.getPathSet(path);
      var _loc5_ = _loc4_[0];
      var _loc6_ = _loc5_.nodeName;
      var _loc7_ = null;
      var _loc8_ = undefined;
      if(_loc6_ != undefined && (_loc6_ == "*" || node.nodeName == _loc6_))
      {
         if(_loc5_.filter.length > 0)
         {
            _loc7_ = new mx.xpath.FilterStack(_loc5_.filter);
            _loc3_ = mx.xpath.XPathAPI.filterNodes(_loc3_,_loc7_);
         }
         if(_loc3_.length > 0)
         {
            _loc8_ = 1;
            while(_loc8_ < _loc4_.length)
            {
               _loc5_ = _loc4_[_loc8_];
               _loc3_ = mx.xpath.XPathAPI.getAllChildNodesByName(_loc3_,_loc5_.nodeName);
               if(_loc5_.filter.length > 0)
               {
                  _loc7_ = new mx.xpath.FilterStack(_loc5_.filter);
               }
               else
               {
                  _loc7_ = null;
               }
               if(_loc7_ != null && _loc7_.exprs.length > 0)
               {
                  _loc3_ = mx.xpath.XPathAPI.filterNodes(_loc3_,_loc7_);
               }
               _loc8_ += 1;
            }
         }
      }
      else
      {
         _loc3_ = new Array();
      }
      return _loc3_;
   }
   static function selectSingleNode(node, path)
   {
      var _loc3_ = mx.xpath.XPathAPI.selectNodeList(node,path);
      if(_loc3_.length > 0)
      {
         return _loc3_[0];
      }
      return null;
   }
   static function setNodeValue(node, path, newValue)
   {
      var _loc4_ = new Array(node);
      var _loc5_ = mx.xpath.XPathAPI.getPathSet(path);
      var _loc6_ = _loc5_[_loc5_.length - 1].nodeName;
      if(_loc6_.charAt(0) == "@")
      {
         _loc6_ = _loc6_.substring(1,_loc6_.length);
         _loc5_.pop();
      }
      else
      {
         _loc6_ = null;
      }
      var _loc7_ = _loc5_[0];
      var _loc8_ = _loc7_.nodeName;
      var _loc9_ = null;
      var _loc10_ = undefined;
      if(_loc8_ != undefined && (_loc8_ == "*" || node.nodeName == _loc8_))
      {
         if(_loc7_.filter.length > 0)
         {
            _loc9_ = new mx.xpath.FilterStack(_loc7_.filter);
            _loc4_ = mx.xpath.XPathAPI.filterNodes(_loc4_,_loc9_);
         }
         if(_loc4_.length > 0)
         {
            _loc10_ = 1;
            while(_loc10_ < _loc5_.length)
            {
               _loc7_ = _loc5_[_loc10_];
               _loc4_ = mx.xpath.XPathAPI.getAllChildNodesByName(_loc4_,_loc7_.nodeName);
               if(_loc7_.filter.length > 0)
               {
                  _loc9_ = new mx.xpath.FilterStack(_loc7_.filter);
               }
               else
               {
                  _loc9_ = null;
               }
               if(_loc9_ != null && _loc9_.exprs.length > 0)
               {
                  _loc4_ = mx.xpath.XPathAPI.filterNodes(_loc4_,_loc9_);
               }
               _loc10_ += 1;
            }
         }
      }
      else
      {
         _loc4_ = new Array();
      }
      var _loc11_ = null;
      var _loc12_ = null;
      var _loc13_ = new XML();
      _loc10_ = 0;
      while(_loc10_ < _loc4_.length)
      {
         if(_loc6_ != null)
         {
            _loc4_[_loc10_].attributes[_loc6_] = newValue;
         }
         else
         {
            _loc11_ = _loc4_[_loc10_];
            if(_loc11_.firstChild == null || _loc11_.firstChild.nodeType != 3)
            {
               _loc12_ = _loc13_.createTextNode(newValue);
               _loc11_.appendChild(_loc12_);
            }
            else
            {
               _loc12_ = _loc11_.firstChild;
               _loc12_.nodeValue = newValue;
            }
         }
         _loc10_ += 1;
      }
      return _loc4_.length;
   }
   static function copyStack(toStk, fromStk)
   {
      var _loc3_ = 0;
      while(_loc3_ < fromStk.length)
      {
         toStk.splice(_loc3_,0,fromStk[_loc3_]);
         _loc3_ += 1;
      }
   }
   static function evalExpr(expr, node)
   {
      var _loc3_ = true;
      var _loc4_ = undefined;
      if(expr.attr)
      {
         _loc3_ = expr.value == null ? node.attributes[expr.name] != null : node.attributes[expr.name] == expr.value;
      }
      else
      {
         _loc4_ = mx.xpath.XPathAPI.getChildNodeByName(node,expr.name);
         if(_loc4_ != null)
         {
            _loc3_ = expr.value == null ? true : _loc4_.firstChild.nodeValue == expr.value;
         }
         else
         {
            _loc3_ = false;
         }
      }
      return _loc3_;
   }
   static function filterNodes(nodeList, stack)
   {
      var _loc3_ = new Array();
      var _loc4_ = undefined;
      var _loc5_ = undefined;
      var _loc6_ = undefined;
      var _loc7_ = undefined;
      var _loc8_ = undefined;
      var _loc9_ = true;
      var _loc10_ = undefined;
      var _loc11_ = undefined;
      var _loc12_ = 0;
      var _loc13_ = undefined;
      while(_loc12_ < nodeList.length)
      {
         _loc11_ = true;
         _loc4_ = new Array();
         _loc5_ = new Array();
         mx.xpath.XPathAPI.copyStack(_loc4_,stack.exprs);
         mx.xpath.XPathAPI.copyStack(_loc5_,stack.ops);
         _loc10_ = nodeList[_loc12_];
         while(_loc4_.length > 0 && _loc11_)
         {
            if(typeof _loc4_[_loc4_.length - 1] == "object")
            {
               _loc6_ = mx.xpath.FilterExpr(_loc4_.pop());
               _loc9_ = mx.xpath.XPathAPI.evalExpr(_loc6_,_loc10_);
            }
            else
            {
               _loc8_ = Boolean(_loc4_.pop());
               _loc9_ = _loc8_;
            }
            if(_loc5_.length > 0)
            {
               _loc13_ = _loc4_.pop();
               _loc7_ = _loc13_;
               switch(_loc5_[_loc5_.length - 1])
               {
                  case "and":
                     _loc9_ = _loc9_ && mx.xpath.XPathAPI.evalExpr(_loc7_,_loc10_);
                     _loc11_ = _loc9_;
                     break;
                  case "or":
                     _loc9_ = _loc9_ || mx.xpath.XPathAPI.evalExpr(_loc7_,_loc10_);
                     _loc11_ = !_loc9_;
               }
               _loc5_.pop();
               _loc4_.push(_loc9_);
            }
         }
         if(_loc9_)
         {
            _loc3_.push(_loc10_);
         }
         _loc12_ += 1;
      }
      return _loc3_;
   }
   static function getAllChildNodesByName(nodeList, name)
   {
      var _loc3_ = new Array();
      var _loc4_ = undefined;
      var _loc5_ = 0;
      var _loc6_ = undefined;
      while(_loc5_ < nodeList.length)
      {
         _loc4_ = nodeList[_loc5_].childNodes;
         if(_loc4_ != null)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc4_.length)
            {
               if(name == "*" || _loc4_[_loc6_].nodeName == name)
               {
                  _loc3_.push(_loc4_[_loc6_]);
               }
               _loc6_ += 1;
            }
         }
         _loc5_ += 1;
      }
      return _loc3_;
   }
   static function getChildNodeByName(node, nodeName)
   {
      var _loc3_ = undefined;
      var _loc4_ = node.childNodes;
      var _loc5_ = 0;
      while(_loc5_ < _loc4_.length)
      {
         _loc3_ = _loc4_[_loc5_];
         if(_loc3_.nodeName == nodeName)
         {
            return _loc3_;
         }
         _loc5_ += 1;
      }
      return null;
   }
   static function getKeyValues(node, keySpec)
   {
      var _loc3_ = "";
      var _loc4_ = new mx.utils.StringTokenParser(keySpec);
      var _loc5_ = _loc4_.nextToken();
      var _loc6_ = undefined;
      var _loc7_ = undefined;
      while(_loc5_ != mx.utils.StringTokenParser.tkEOF)
      {
         _loc6_ = _loc4_.token;
         _loc3_ += " " + _loc6_;
         if(_loc5_ == mx.utils.StringTokenParser.tkSymbol)
         {
            if(_loc6_ == "@")
            {
               _loc5_ = _loc4_.nextToken();
               _loc6_ = _loc4_.token;
               if(_loc5_ == mx.utils.StringTokenParser.tkSymbol)
               {
                  _loc3_ += _loc6_ + "=\'" + node.attributes[_loc6_] + "\'";
               }
            }
            else if(_loc6_ == "/")
            {
               _loc5_ = _loc4_.nextToken();
               if(_loc5_ == mx.utils.StringTokenParser.tkSymbol)
               {
                  _loc6_ = _loc4_.token;
                  node = mx.xpath.XPathAPI.getChildNodeByName(node,_loc6_);
                  if(node != null)
                  {
                     _loc3_ += _loc6_;
                  }
               }
            }
            else if(_loc6_ != "and" && _loc6_ != "or" && _loc6_ != "[" && _loc6_ != "]")
            {
               _loc7_ = mx.xpath.XPathAPI.getChildNodeByName(node,_loc6_);
               if(_loc7_ != null)
               {
                  _loc3_ += "=\'" + _loc7_.firstChild.nodeValue + "\'";
               }
            }
         }
         if(node == null)
         {
            trace("Invalid keySpec specified. \'" + keySpec + "\' Error.");
            return "ERR";
         }
         _loc5_ = _loc4_.nextToken();
      }
      return _loc3_.slice(1);
   }
   static function getPath(node, keySpecs)
   {
      var _loc3_ = "";
      var _loc4_ = keySpecs[node.nodeName];
      var _loc5_ = undefined;
      var _loc6_ = undefined;
      var _loc7_ = undefined;
      var _loc8_ = undefined;
      var _loc9_ = undefined;
      var _loc10_ = undefined;
      if(_loc4_ == undefined)
      {
         _loc5_ = "";
         for(_loc6_ in node.attributes)
         {
            _loc5_ += "@" + _loc6_ + "=\'" + node.attributes[_loc6_] + "\' and ";
         }
         _loc7_ = "";
         _loc10_ = 0;
         while(_loc10_ < node.childNodes.length)
         {
            _loc8_ = node.childNodes[_loc10_];
            _loc9_ = _loc8_.firstChild.nodeValue;
            if(_loc9_ != undefined)
            {
               _loc7_ += _loc8_.nodeName + "=\'" + _loc9_ + "\' and ";
            }
            _loc10_ += 1;
         }
         if(_loc5_.length > 0)
         {
            if(_loc7_.length > 0)
            {
               _loc3_ = "/" + node.nodeName + "[" + _loc5_ + _loc7_.substring(0,_loc7_.length - 4) + "]";
            }
            else
            {
               _loc3_ = "/" + node.nodeName + "[" + _loc5_.substring(0,_loc5_.length - 4) + "]";
            }
         }
         else
         {
            _loc3_ = "/" + node.nodeName + "[" + _loc7_.substring(0,_loc7_.length - 4) + "]";
         }
      }
      else
      {
         _loc3_ += "/" + node.nodeName + mx.xpath.XPathAPI.getKeyValues(node,_loc4_);
      }
      _loc8_ = node.parentNode;
      while(_loc8_.parentNode != null)
      {
         _loc4_ = keySpecs[_loc8_.nodeName];
         if(_loc4_ != undefined)
         {
            _loc3_ = "/" + _loc8_.nodeName + mx.xpath.XPathAPI.getKeyValues(_loc8_,_loc4_) + _loc3_;
         }
         else
         {
            _loc3_ = "/" + _loc8_.nodeName + _loc3_;
         }
         _loc8_ = _loc8_.parentNode;
      }
      return _loc3_;
   }
   static function getPathSet(path)
   {
      var _loc2_ = new Array();
      var _loc3_ = undefined;
      var _loc4_ = undefined;
      var _loc5_ = undefined;
      var _loc6_ = undefined;
      while(path.length > 0)
      {
         _loc3_ = path.lastIndexOf("/");
         _loc4_ = path.substring(_loc3_ + 1);
         _loc5_ = _loc4_.indexOf("[",0);
         _loc6_ = _loc5_ < 0 ? "" : _loc4_.substring(_loc5_ + 1,_loc4_.length - 1);
         _loc4_ = _loc5_ < 0 ? _loc4_ : _loc4_.substring(0,_loc5_);
         _loc2_.splice(0,0,new mx.xpath.NodePathInfo(_loc4_,_loc6_));
         path = path.substring(0,_loc3_);
      }
      return _loc2_;
   }
}
