class classes.Lookup
{
   static var callbackArr;
   static var keyboardRestrictChars = "a-z A-Z 0-9 `~!@#$%\\^&*()_\\-+=[]{}|;:\'\",.<>/?\\";
   static var alphaNumRestrictChars = "a-zA-Z0-9";
   static var emailRestrictChars = "a-zA-Z0-9.@_\\-";
   static var userNamesArr = new Array();
   function Lookup()
   {
   }
   static function getSCName(sc)
   {
      var _loc3_ = _global.scLevelsXML.firstChild;
      var _loc4_ = 0;
      while(_loc4_ < _loc3_.childNodes.length)
      {
         if(sc < Number(_loc3_.childNodes[_loc4_].attributes.sc))
         {
            return _loc3_.childNodes[_loc4_].attributes.id;
         }
         _loc4_ += 1;
      }
      return "";
   }
   static function getMemberColor(id)
   {
      var _loc3_ = _global.n2CSS.getStyle(".e" + id);
      var _loc4_ = Number("0x" + _loc3_.color.substr(1));
      _loc4_ = !_loc4_ ? 0 : _loc4_;
      return _loc4_;
   }
   static function countBuddiesOnline()
   {
      var _loc2_ = 0;
      var _loc3_ = 0;
      while(_loc3_ < _global.buddylist_xml.firstChild.childNodes.length)
      {
         if(_global.buddylist_xml.firstChild.childNodes[_loc3_].attributes.s > 0)
         {
            _loc2_ += 1;
         }
         _loc3_ += 1;
      }
      return _loc2_;
   }
   static function buddyNum(id)
   {
      var _loc3_ = 0;
      while(_loc3_ < _global.buddylist_xml.firstChild.childNodes.length)
      {
         if(_global.buddylist_xml.firstChild.childNodes[_loc3_].attributes.id == id)
         {
            return _loc3_;
         }
         _loc3_ += 1;
      }
      return -1;
   }
   static function getBuddyNode(id)
   {
      var _loc3_ = 0;
      while(_loc3_ < _global.buddylist_xml.firstChild.childNodes.length)
      {
         if(_global.buddylist_xml.firstChild.childNodes[_loc3_].attributes.id == id)
         {
            return _global.buddylist_xml.firstChild.childNodes[_loc3_];
         }
         _loc3_ += 1;
      }
      return null;
   }
   static function buddyName(id)
   {
      var _loc3_ = 0;
      while(_loc3_ < _global.buddylist_xml.firstChild.childNodes.length)
      {
         if(_global.buddylist_xml.firstChild.childNodes[_loc3_].attributes.id == id)
         {
            return _global.buddylist_xml.firstChild.childNodes[_loc3_].attributes.n;
         }
         _loc3_ += 1;
      }
      _loc3_ = 0;
      while(_loc3_ < _global.chatObj.userListXML.firstChild.childNodes.length)
      {
         if(_global.chatObj.userListXML.firstChild.childNodes[_loc3_].attributes.i == id)
         {
            return _global.chatObj.userListXML.firstChild.childNodes[_loc3_].attributes.un;
         }
         _loc3_ += 1;
      }
      _loc3_ = 0;
      while(_loc3_ < _global.usersXML.firstChild.childNodes.length)
      {
         if(_global.usersXML.firstChild.childNodes[_loc3_].attributes.i == id)
         {
            return _global.usersXML.firstChild.childNodes[_loc3_].attributes.u;
         }
         _loc3_ += 1;
      }
      _loc3_ = 0;
      while(_loc3_ < classes.Lookup.userNamesArr.length)
      {
         if(classes.Lookup.userNamesArr[_loc3_].id == id)
         {
            return classes.Lookup.userNamesArr[_loc3_].name;
         }
         _loc3_ += 1;
      }
      return "";
   }
   static function addUserName(uid, uname)
   {
      var _loc3_ = undefined;
      var _loc4_ = 0;
      while(_loc4_ < classes.Lookup.userNamesArr.length)
      {
         if(classes.Lookup.userNamesArr[_loc4_].id == uid)
         {
            _loc3_ = true;
            break;
         }
         _loc4_ += 1;
      }
      if(!_loc3_)
      {
         classes.Lookup.userNamesArr.push({id:uid,name:uname});
      }
   }
   static function addToUsersXML(tNode)
   {
      if(_global.usersXML == undefined)
      {
         _global.usersXML = new XML("<users></users>");
      }
      classes.Lookup.removeFromUsersXML(Number(tNode.attributes.i));
      _global.usersXML.firstChild.appendChild(tNode);
   }
   static function removeFromUsersXML(id)
   {
      var _loc3_ = _global.usersXML.firstChild.childNodes.length - 1;
      var _loc4_ = undefined;
      if(!isNaN(_loc3_))
      {
         _loc4_ = _loc3_;
         while(_loc4_ >= 0)
         {
            if(_global.usersXML.firstChild.childNodes[_loc4_].attributes.i == id)
            {
               _global.usersXML.firstChild.childNodes[_loc4_].removeNode();
            }
            _loc4_ -= 1;
         }
      }
   }
   static function getUserNode(id)
   {
      var _loc3_ = _global.usersXML.firstChild.childNodes.length;
      var _loc4_ = 0;
      while(_loc4_ < _loc3_)
      {
         if(id == _global.usersXML.firstChild.childNodes[_loc4_].attributes.i)
         {
            return _global.usersXML.firstChild.childNodes[_loc4_];
         }
         _loc4_ += 1;
      }
      return undefined;
   }
   static function addToTeamsXML(tNode)
   {
      if(_global.teamsXML == undefined)
      {
         _global.teamsXML = new XML("<teams></teams>");
      }
      classes.Lookup.removeFromTeamsXML(Number(tNode.attributes.i));
      _global.teamsXML.firstChild.appendChild(tNode);
   }
   static function removeFromTeamsXML(id)
   {
      var _loc3_ = _global.teamsXML.firstChild.childNodes.length - 1;
      var _loc4_ = undefined;
      if(!isNaN(_loc3_))
      {
         _loc4_ = _loc3_;
         while(_loc4_ >= 0)
         {
            if(_global.teamsXML.firstChild.childNodes[_loc4_].attributes.i == id)
            {
               _global.teamsXML.firstChild.childNodes[_loc4_].removeNode();
            }
            _loc4_ -= 1;
         }
      }
   }
   static function getTeamNode(id)
   {
      var _loc3_ = _global.teamsXML.firstChild.childNodes.length;
      var _loc4_ = 0;
      while(_loc4_ < _loc3_)
      {
         if(id == _global.teamsXML.firstChild.childNodes[_loc4_].attributes.i)
         {
            return _global.teamsXML.firstChild.childNodes[_loc4_];
         }
         _loc4_ += 1;
      }
      var _loc5_ = new XMLNode(1,"t");
      _loc5_.attributes.i = 0;
      _loc5_.attributes.n = "--";
      return _loc5_;
   }
   static function addToRaceCarsXML(tNode)
   {
      trace("addRaceCarsXML");
      if(_global.raceCarsXML == undefined)
      {
         _global.raceCarsXML = new XML("<cars></cars>");
      }
      if(tNode.toString())
      {
         classes.Lookup.removeFromRaceCarsXML(Number(tNode.attributes.i));
         _global.raceCarsXML.firstChild.appendChild(tNode);
      }
   }
   static function removeFromRaceCarsXML(id)
   {
      trace("removeFromRaceCarsXML");
      trace(id);
      var _loc3_ = _global.raceCarsXML.firstChild.childNodes.length - 1;
      var _loc4_ = undefined;
      if(!isNaN(_loc3_))
      {
         _loc4_ = _loc3_;
         while(_loc4_ >= 0)
         {
            if(_global.raceCarsXML.firstChild.childNodes[_loc4_].attributes.i == id)
            {
               _global.raceCarsXML.firstChild.childNodes[_loc4_].removeNode();
               trace("removed!");
            }
            _loc4_ -= 1;
         }
      }
   }
   static function removeFromRaceCarsXMLByUser(uid)
   {
      var _loc3_ = _global.raceCarsXML.firstChild.childNodes.length - 1;
      var _loc4_ = undefined;
      if(!isNaN(_loc3_))
      {
         _loc4_ = _loc3_;
         while(_loc4_ >= 0)
         {
            if(_global.raceCarsXML.firstChild.childNodes[_loc4_].attributes.ai == uid)
            {
               _global.raceCarsXML.firstChild.childNodes[_loc4_].removeNode();
            }
            _loc4_ -= 1;
         }
      }
   }
   static function getRaceCarNode(id)
   {
      trace("getRaceCarNode");
      trace(id);
      var _loc3_ = _global.raceCarsXML.firstChild.childNodes.length;
      var _loc4_ = 0;
      while(_loc4_ < _loc3_)
      {
         if(id == _global.raceCarsXML.firstChild.childNodes[_loc4_].attributes.i)
         {
            return _global.raceCarsXML.firstChild.childNodes[_loc4_];
         }
         _loc4_ += 1;
      }
      return undefined;
   }
   static function homeName(lid)
   {
      var _loc3_ = 0;
      while(_loc3_ < _global.locationXML.firstChild.childNodes.length)
      {
         if(_global.locationXML.firstChild.childNodes[_loc3_].attributes.lid == lid)
         {
            return _global.locationXML.firstChild.childNodes[_loc3_].attributes.ln;
         }
         _loc3_ += 1;
      }
      return "unknown";
   }
   static function locationName(num)
   {
      if(_global.constants_xml.firstChild.childNodes[1].childNodes.length > num)
      {
         return _global.constants_xml.firstChild.childNodes[1].childNodes[num].attributes.n;
      }
   }
   static function transactionName(num)
   {
      switch(num)
      {
         case 1:
            return "Disbursement by team leader";
         case 2:
            return "Withdrawal";
         case 3:
            return "Deposit";
         case 4:
            return "Team Win";
         case 5:
            return "Team Loss";
         case 6:
            return "New Leader";
         case 7:
            return "Quit team";
         case 8:
            return "Kicked off team by team leader";
         default:
            return "";
      }
   }
   static function carModelName(carid)
   {
      var _loc3_ = 0;
      while(_loc3_ < _global.carsXML.firstChild.childNodes.length)
      {
         if(_global.carsXML.firstChild.childNodes[_loc3_].attributes.id == carid)
         {
            return _global.carsXML.firstChild.childNodes[_loc3_].attributes.c;
         }
         _loc3_ += 1;
      }
      return "unknown";
   }
   static function carNode(carid)
   {
      var _loc3_ = 0;
      while(_loc3_ < _global.carsXML.firstChild.childNodes.length)
      {
         if(_global.carsXML.firstChild.childNodes[_loc3_].attributes.id == carid)
         {
            return _global.carsXML.firstChild.childNodes[_loc3_];
         }
         _loc3_ += 1;
      }
      return new XML();
   }
   static function carLocation(carid)
   {
      trace("car id: ");
      var _loc3_ = 0;
      while(_loc3_ < _global.carsXML.firstChild.childNodes.length)
      {
         if(_global.carsXML.firstChild.childNodes[_loc3_].attributes.id == carid)
         {
            trace("id: " + _global.carsXML.firstChild.childNodes[_loc3_].attributes.id);
            trace("loc: " + _global.carsXML.firstChild.childNodes[_loc3_].attributes.l);
            trace(" ");
            return _global.carsXML.firstChild.childNodes[_loc3_].attributes.l;
         }
         _loc3_ += 1;
      }
      return "unknown";
   }
   static function engineType(etid, returnLong)
   {
      if(returnLong)
      {
         switch(etid)
         {
            case 1:
               return "Natural";
            case 2:
               return "Turbocharger";
            case 3:
               return "Supercharger";
            default:
               return "Unknown";
         }
      }
      else
      {
         switch(etid)
         {
            case 1:
               return "NA";
            case 2:
               return "TC";
            case 3:
               return "SC";
            default:
               return "??";
         }
      }
   }
   static function samplePlateNumber(plateID)
   {
      switch(plateID)
      {
         case 1:
         case 2:
         case 3:
         case 4:
            return "01ABC23";
         case 5:
         case 6:
         case 7:
            return "01_AB_23";
         case 8:
            return "01_AB_C23";
         case 9:
            return "01_ABC_23";
         case 10:
            return "01A_BC_23";
         case 11:
            return "01ABC23";
         default:
            return "00";
      }
   }
   static function badgeAltText(id)
   {
      var _loc3_ = _global.badgesXML.firstChild.childNodes.length;
      var _loc4_ = 0;
      while(_loc4_ < _loc3_)
      {
         if(id == _global.badgesXML.firstChild.childNodes[_loc4_].attributes.i)
         {
            return _global.badgesXML.firstChild.childNodes[_loc4_].attributes.n;
         }
         _loc4_ += 1;
      }
      return "";
   }
   static function badgeAltDescription(id)
   {
      var _loc3_ = _global.badgesXML.firstChild.childNodes.length;
      var _loc4_ = 0;
      while(_loc4_ < _loc3_)
      {
         if(id == _global.badgesXML.firstChild.childNodes[_loc4_].attributes.i)
         {
            return _global.badgesXML.firstChild.childNodes[_loc4_].attributes.d;
         }
         _loc4_ += 1;
      }
      return "";
   }
   static function addCallback(funcName, context, cb, id)
   {
      if(!classes.Lookup.callbackArr)
      {
         classes.Lookup.callbackArr = new Array();
      }
      classes.Lookup.callbackArr.push({funcName:funcName,context:context,cb:cb,id:id});
   }
   static function runCallback(funcName, id, param)
   {
      trace("runCallback");
      var _loc4_ = classes.Lookup.callbackArr.length - 1;
      var _loc5_ = undefined;
      if(!isNaN(_loc4_))
      {
         trace("whatever");
         _loc5_ = _loc4_;
         while(_loc5_ >= 0)
         {
            trace("for loop!");
            trace(classes.Lookup.callbackArr[_loc5_].funcName);
            trace(classes.Lookup.callbackArr[_loc5_].id);
            trace(id);
            if(classes.Lookup.callbackArr[_loc5_].funcName == funcName && classes.Lookup.callbackArr[_loc5_].id == id)
            {
               trace(classes.Lookup.callbackArr[_loc5_].funcName);
               trace(classes.Lookup.callbackArr[_loc5_].cb);
               trace(classes.Lookup.callbackArr[_loc5_].context);
               classes.Lookup.callbackArr[_loc5_].cb.call(classes.Lookup.callbackArr[_loc5_].context,param,id);
               classes.Lookup.callbackArr.splice(_loc5_,1);
            }
            _loc5_ -= 1;
         }
      }
   }
   static function clearCallback(funcName, id)
   {
      var _loc3_ = 0;
      while(_loc3_ < classes.Lookup.callbackArr.length)
      {
         if(classes.Lookup.callbackArr[_loc3_].funcName == funcName && classes.Lookup.callbackArr[_loc3_].id == id)
         {
            classes.Lookup.callbackArr.splice(_loc3_,1);
            break;
         }
         _loc3_ += 1;
      }
   }
}
