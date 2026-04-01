function legacyTrim(s)
{
   while(s.length && (s.charCodeAt(0) == 10 || s.charCodeAt(0) == 13 || s.charCodeAt(0) == 9 || s.charCodeAt(0) == 32))
   {
      s = s.substr(1);
   }
   while(s.length && (s.charCodeAt(s.length - 1) == 10 || s.charCodeAt(s.length - 1) == 13 || s.charCodeAt(s.length - 1) == 9 || s.charCodeAt(s.length - 1) == 32))
   {
      s = s.substr(0,s.length - 1);
   }
   return s;
}
function legacyDecodeText(n)
{
   if(n == undefined)
   {
      return "";
   }
   if(n.firstChild != undefined && n.firstChild.nodeValue != undefined)
   {
      return String(n.firstChild.nodeValue);
   }
   if(n.nodeValue != undefined)
   {
      return String(n.nodeValue);
   }
   return "";
}
function legacyInvokeCallback(cbScope, cbName, argArray)
{
   if(cbScope == undefined)
   {
      cbScope = _root;
   }
   var _loc5_ = cbScope[cbName];
   if(_loc5_ == undefined)
   {
      trace("Missing callback: " + cbName);
      return undefined;
   }
   switch(argArray.length)
   {
      case 0:
         _loc5_();
         break;
      case 1:
         _loc5_(argArray[0]);
         break;
      case 2:
         _loc5_(argArray[0],argArray[1]);
         break;
      case 3:
         _loc5_(argArray[0],argArray[1],argArray[2]);
         break;
      case 4:
         _loc5_(argArray[0],argArray[1],argArray[2],argArray[3]);
         break;
      case 5:
         _loc5_(argArray[0],argArray[1],argArray[2],argArray[3],argArray[4]);
         break;
      case 6:
         _loc5_(argArray[0],argArray[1],argArray[2],argArray[3],argArray[4],argArray[5]);
         break;
      case 7:
         _loc5_(argArray[0],argArray[1],argArray[2],argArray[3],argArray[4],argArray[5],argArray[6]);
         break;
      case 8:
         _loc5_(argArray[0],argArray[1],argArray[2],argArray[3],argArray[4],argArray[5],argArray[6],argArray[7]);
         break;
      default:
         _loc5_(argArray[0],argArray[1],argArray[2],argArray[3],argArray[4],argArray[5],argArray[6],argArray[7],argArray[8]);
   }
}
function legacyDispatchCallNode(callNode, defaultCb, cbScope)
{
   var _loc4_ = callNode.attributes.cb;
   var _loc5_ = new Array();
   if(_loc4_ == undefined || _loc4_ == "")
   {
      _loc4_ = defaultCb;
   }
   var _loc6_ = 0;
   while(_loc6_ < callNode.childNodes.length)
   {
      _loc5_.push(legacyDecodeText(callNode.childNodes[_loc6_]));
      _loc6_ += 1;
   }
   if(_loc4_ != undefined && _loc4_ != "")
   {
      legacyInvokeCallback(cbScope,_loc4_,_loc5_);
   }
}
function legacyDispatchResponse(src, defaultCb, cbScope)
{
   src = legacyTrim(String(src));
   if(src == "")
   {
      return undefined;
   }
   if(src.substr(0,1) != "<")
   {
      if(defaultCb != undefined && defaultCb != "")
      {
         legacyInvokeCallback(cbScope,defaultCb,[src]);
      }
      return undefined;
   }
   var _loc4_ = new XML();
   _loc4_.ignoreWhite = true;
   _loc4_.parseXML(src);
   if(_loc4_.firstChild == undefined)
   {
      if(defaultCb != undefined && defaultCb != "")
      {
         legacyInvokeCallback(cbScope,defaultCb,[src]);
      }
      return undefined;
   }
   if(_loc4_.firstChild.nodeName == "legacybatch")
   {
      var _loc5_ = 0;
      while(_loc5_ < _loc4_.firstChild.childNodes.length)
      {
         legacyDispatchCallNode(_loc4_.firstChild.childNodes[_loc5_],defaultCb,cbScope);
         _loc5_ += 1;
      }
      return undefined;
   }
   if(_loc4_.firstChild.nodeName == "legacy")
   {
      legacyDispatchCallNode(_loc4_.firstChild,defaultCb,cbScope);
      return undefined;
   }
   if(defaultCb != undefined && defaultCb != "")
   {
      legacyInvokeCallback(cbScope,defaultCb,[src]);
   }
}
function legacyHttpError(cbName, req)
{
   classes.Frame.serverLights(false);
   if(_root.showConnectionErrorCB != undefined)
   {
      _root.showConnectionErrorCB("Connection Problem","The game could not reach the HTTP bridge.");
   }
   else
   {
      trace("HTTP bridge error for " + cbName + ": status=" + req.httpStatus);
   }
}
function legacyCall(rawCmd, cbName, httpMethod, cbScope)
{
   var _loc6_ = new LoadVars();
   _loc6_.cbName = cbName;
   _loc6_.cbScope = cbScope;
   _loc6_.onHTTPStatus = function(code)
   {
      this.httpStatus = code;
   };
   _loc6_.onData = function(src)
   {
      classes.Frame.serverLights(false);
      if(src == undefined)
      {
         _root.legacyHttpError(this.cbName,this);
         return undefined;
      }
      _root.legacyDispatchResponse(src,this.cbName,this.cbScope);
   };
   var _loc7_ = new LoadVars();
   _loc7_.cmd = rawCmd;
   _loc7_.cb = cbName;
   _loc7_.sendAndLoad(_global.apiBridgeURL,_loc6_,httpMethod == "GET" ? "POST" : httpMethod);
}
function getLocalStore()
{
   if(_global.nittoLocalStore == undefined)
   {
      _global.nittoLocalStore = SharedObject.getLocal("nitto1320_http");
   }
   return _global.nittoLocalStore;
}
function getLocalAccountStoragePrefix()
{
   var _loc2_ = undefined;
   if(_global.loginXML != undefined && _global.loginXML.firstChild != undefined && _global.loginXML.firstChild.firstChild != undefined && _global.loginXML.firstChild.firstChild.attributes.i != undefined && _global.loginXML.firstChild.firstChild.attributes.i != "")
   {
      _loc2_ = _global.loginXML.firstChild.firstChild.attributes.i;
   }
   else if(_global.loginAttrCache != undefined && _global.loginAttrCache.i != undefined && _global.loginAttrCache.i != "")
   {
      _loc2_ = _global.loginAttrCache.i;
   }
   else if(classes.GlobalData != undefined && classes.GlobalData.attr != undefined && classes.GlobalData.attr.i != undefined && classes.GlobalData.attr.i != "")
   {
      _loc2_ = classes.GlobalData.attr.i;
   }
   if(_loc2_ == undefined || _loc2_ == "")
   {
      return "global";
   }
   return "account_" + _loc2_;
}
function setHttpHudAttrCache(src)
{
   if(src == undefined)
   {
      return undefined;
   }
   _global.httpHudAttrCache = new Object();
   for(var _loc3_ in src)
   {
      _global.httpHudAttrCache[_loc3_] = src[_loc3_];
   }
   return _global.httpHudAttrCache;
}
function ensureHttpLoginXmlFromCache()
{
   var _loc2_ = _global.httpHudAttrCache != undefined ? _global.httpHudAttrCache : _global.loginAttrCache;
   if(_loc2_ == undefined)
   {
      return undefined;
   }
   if(_global.loginXML == undefined || _global.loginXML.firstChild == undefined || _global.loginXML.firstChild.firstChild == undefined)
   {
      _global.loginXML = new XML("<n2><u/></n2>");
   }
   for(var _loc3_ in _loc2_)
   {
      _global.loginXML.firstChild.firstChild.attributes[_loc3_] = _loc2_[_loc3_];
   }
   return _global.loginXML;
}
function getHttpLiveLoginAttrs()
{
   if(_root.ensureHttpLoginXmlFromCache != undefined)
   {
      _root.ensureHttpLoginXmlFromCache();
   }
   if(_global.loginXML != undefined && _global.loginXML.firstChild != undefined && _global.loginXML.firstChild.firstChild != undefined)
   {
      return _global.loginXML.firstChild.firstChild.attributes;
   }
   return undefined;
}
function syncHttpLoginAttr(prop, val)
{
   if(prop == undefined || val == undefined)
   {
      return undefined;
   }
   var _loc4_ = getHttpLiveLoginAttrs();
   if(_loc4_ != undefined)
   {
      _loc4_[prop] = val;
   }
   if(_global.loginAttrCache != undefined)
   {
      _global.loginAttrCache[prop] = val;
   }
   if(_global.httpHudAttrCache != undefined)
   {
      _global.httpHudAttrCache[prop] = val;
   }
   if(classes.GlobalData != undefined && classes.GlobalData.attr != undefined)
   {
      classes.GlobalData.attr[prop] = val;
   }
   return val;
}
function getHttpLoginAttrs()
{
   if(_global.httpHudAttrCache != undefined)
   {
      return _global.httpHudAttrCache;
   }
   if(_global.loginAttrCache != undefined)
   {
      return _global.loginAttrCache;
   }
   if(_global.loginXML != undefined && _global.loginXML.firstChild != undefined && _global.loginXML.firstChild.firstChild != undefined)
   {
      return _global.loginXML.firstChild.firstChild.attributes;
   }
   if(classes.GlobalData != undefined && classes.GlobalData.attr != undefined)
   {
      return classes.GlobalData.attr;
   }
   return undefined;
}
function refreshHttpHud()
{
   var _loc3_ = getHttpLoginAttrs();
   if(_loc3_ == undefined)
   {
      trace("refreshHttpHud: no attrs");
      return undefined;
   }
   setHttpHudAttrCache(_loc3_);
   ensureHttpLoginXmlFromCache();
   var _loc4_ = getHttpLiveLoginAttrs();
   classes.GlobalData.attr = _loc4_ != undefined ? _loc4_ : (_global.httpHudAttrCache != undefined ? _global.httpHudAttrCache : _loc3_);
   classes.GlobalData.role = !classes.GlobalData.attr.r ? 0 : Number(classes.GlobalData.attr.r);
   if(_root.main != undefined && _root.main.overlay != undefined)
   {
      _root.main.overlay.txtMoney = "$: " + classes.NumFuncs.commaFormat(Number(classes.GlobalData.attr.m));
      _root.main.overlay.txtPoints = "P: " + classes.NumFuncs.commaFormat(Number(classes.GlobalData.attr.p));
      _root.main.overlay.txtCred = "SC: " + classes.GlobalData.attr.sc;
      _root.main.overlay.txtEmail = classes.GlobalData.attr.im;
      if(classes.Frame != undefined && classes.Frame._MC != undefined && classes.Frame._MC.overlay != undefined && classes.Frame._MC.overlay.fldEmail != undefined && classes.Frame._MC.overlay.emailIcon != undefined)
      {
         classes.Frame._MC.overlay.emailIcon._x = classes.Frame._MC.overlay.fldEmail._x - classes.Frame._MC.overlay.emailIcon._width - 2;
      }
   }
   trace("refreshHttpHud m=" + classes.GlobalData.attr.m + " p=" + classes.GlobalData.attr.p + " sc=" + classes.GlobalData.attr.sc + " im=" + classes.GlobalData.attr.im);
}
function loadFile(fileName)
{
   var _loc3_ = getLocalStore();
   var _loc4_ = getLocalAccountStoragePrefix();
   var _loc5_ = _loc4_ + "::" + fileName;
   var _loc6_ = "global::" + fileName;
   _global.activePrefsAccountKey = _loc4_;
   if(_loc3_.data[_loc5_] != undefined)
   {
      return String(_loc3_.data[_loc5_]);
   }
   if(_loc4_ != "global" && _loc3_.data[_loc6_] != undefined)
   {
      return String(_loc3_.data[_loc6_]);
   }
   if(_loc3_.data[fileName] != undefined)
   {
      return String(_loc3_.data[fileName]);
   }
   return undefined;
}
function saveFile(fileName, fileData)
{
   var _loc4_ = getLocalStore();
   var _loc5_ = getLocalAccountStoragePrefix();
   _global.activePrefsAccountKey = _loc5_;
   _loc4_.data[_loc5_ + "::" + fileName] = String(fileData);
   _loc4_.flush();
}
function legacyReplaceAll(src, findStr, replaceStr)
{
   return String(src).split(findStr).join(replaceStr);
}
function legacyEnsureTrailingSlash(url)
{
   url = legacyTrim(String(url));
   if(url == "")
   {
      return "";
   }
   if(url.charAt(url.length - 1) != "/")
   {
      url += "/";
   }
   return url;
}
function legacyExtractHost(url)
{
   url = legacyTrim(String(url));
   var _loc2_ = url.indexOf("://");
   if(_loc2_ >= 0)
   {
      url = url.substr(_loc2_ + 3);
   }
   _loc2_ = url.indexOf("/");
   if(_loc2_ >= 0)
   {
      url = url.substr(0,_loc2_);
   }
   _loc2_ = url.indexOf(":");
   if(_loc2_ >= 0)
   {
      url = url.substr(0,_loc2_);
   }
   return url;
}
function normalizeLegacyUrl(url)
{
   var _loc3_ = legacyTrim(String(url));
   if(_loc3_ == "")
   {
      return "";
   }
   var _loc4_ = _global.mainURL;
   if(_loc4_ == undefined || _loc4_ == "")
   {
      _loc4_ = "http://127.0.0.1:5358/";
   }
   _loc4_ = legacyEnsureTrailingSlash(_loc4_);
   var _loc5_ = _global.devURL == undefined || _global.devURL == "" ? _loc4_ : legacyEnsureTrailingSlash(_global.devURL);
   var _loc6_ = _global.uggURL == undefined || _global.uggURL == "" ? _loc4_ : legacyEnsureTrailingSlash(_global.uggURL);
   var _loc7_ = _global.adminURL == undefined || _global.adminURL == "" ? _loc4_ : legacyEnsureTrailingSlash(_global.adminURL);
   var _loc8_ = _global.adminDevURL == undefined || _global.adminDevURL == "" ? _loc5_ : legacyEnsureTrailingSlash(_global.adminDevURL);
   var _loc9_ = _global.cacheURL == undefined || _global.cacheURL == "" ? _loc4_ + "cache/" : legacyEnsureTrailingSlash(_global.cacheURL);
   var _loc10_ = _global.wwwDevURL == undefined || _global.wwwDevURL == "" ? _loc5_ : legacyEnsureTrailingSlash(_global.wwwDevURL);
   _loc3_ = legacyReplaceAll(_loc3_,"http://game.nittolegends.com/",_loc4_);
   _loc3_ = legacyReplaceAll(_loc3_,"https://game.nittolegends.com/",_loc4_);
   _loc3_ = legacyReplaceAll(_loc3_,"http://download.nittolegends.com/",_loc9_);
   _loc3_ = legacyReplaceAll(_loc3_,"https://download.nittolegends.com/",_loc9_);
   _loc3_ = legacyReplaceAll(_loc3_,"http://ugg.nittolegends.com/",_loc6_);
   _loc3_ = legacyReplaceAll(_loc3_,"https://ugg.nittolegends.com/",_loc6_);
   _loc3_ = legacyReplaceAll(_loc3_,"http://gamestaging.nittolegends.com/",_loc5_);
   _loc3_ = legacyReplaceAll(_loc3_,"https://gamestaging.nittolegends.com/",_loc5_);
   _loc3_ = legacyReplaceAll(_loc3_,"http://admin.nittolegends.com/",_loc7_);
   _loc3_ = legacyReplaceAll(_loc3_,"https://admin.nittolegends.com/",_loc7_);
   _loc3_ = legacyReplaceAll(_loc3_,"http://adminstaging.nittolegends.com/",_loc8_);
   _loc3_ = legacyReplaceAll(_loc3_,"https://adminstaging.nittolegends.com/",_loc8_);
   _loc3_ = legacyReplaceAll(_loc3_,"http://www.nittolegends.com/",_loc4_);
   _loc3_ = legacyReplaceAll(_loc3_,"https://www.nittolegends.com/",_loc4_);
   _loc3_ = legacyReplaceAll(_loc3_,"http://wwwstaging.nittolegends.com/",_loc10_);
   _loc3_ = legacyReplaceAll(_loc3_,"https://wwwstaging.nittolegends.com/",_loc10_);
   _loc3_ = legacyReplaceAll(_loc3_,"game.nittolegends.com",legacyExtractHost(_loc4_));
   _loc3_ = legacyReplaceAll(_loc3_,"download.nittolegends.com",legacyExtractHost(_loc9_));
   _loc3_ = legacyReplaceAll(_loc3_,"ugg.nittolegends.com",legacyExtractHost(_loc6_));
   _loc3_ = legacyReplaceAll(_loc3_,"gamestaging.nittolegends.com",legacyExtractHost(_loc5_));
   _loc3_ = legacyReplaceAll(_loc3_,"admin.nittolegends.com",legacyExtractHost(_loc7_));
   _loc3_ = legacyReplaceAll(_loc3_,"adminstaging.nittolegends.com",legacyExtractHost(_loc8_));
   _loc3_ = legacyReplaceAll(_loc3_,"www.nittolegends.com",legacyExtractHost(_loc4_));
   _loc3_ = legacyReplaceAll(_loc3_,"wwwstaging.nittolegends.com",legacyExtractHost(_loc10_));
   _loc3_ = legacyReplaceAll(_loc3_,"live.nittolegends.com",_global.socketHost == undefined || _global.socketHost == "" ? legacyExtractHost(_loc4_) : legacyExtractHost(_global.socketHost));
   if(_loc3_.charAt(0) == "/")
   {
      return _loc4_ + _loc3_.substr(1);
   }
   return _loc3_;
}
function legacyGetBaseUrlFromSwf()
{
   var _loc2_ = undefined;
   if(_root != undefined && _root._url != undefined && _root._url != "")
   {
      _loc2_ = String(_root._url);
   }
   else if(_level0 != undefined && _level0._url != undefined && _level0._url != "")
   {
      _loc2_ = String(_level0._url);
   }
   if(_loc2_ == undefined || _loc2_ == "")
   {
      return "http://127.0.0.1:5358/";
   }
   _loc2_ = normalizeLegacyUrl(_loc2_);
   var _loc3_ = _loc2_.lastIndexOf("/");
   if(_loc3_ >= 0)
   {
      _loc2_ = _loc2_.substr(0,_loc3_ + 1);
   }
   return legacyEnsureTrailingSlash(_loc2_);
}
function legacyResolveAssetUrl(url)
{
   var _loc3_ = legacyTrim(String(url));
   if(_loc3_ == "")
   {
      return "";
   }
   if(_loc3_.indexOf("://") >= 0)
   {
      return normalizeLegacyUrl(_loc3_);
   }
   var _loc4_ = _global.assetBaseURL;
   if(_loc4_ == undefined || _loc4_ == "")
   {
      _loc4_ = _global.mainURL;
   }
   _loc4_ = legacyEnsureTrailingSlash(_loc4_);
   if(_loc3_.charAt(0) == "/")
   {
      _loc3_ = _loc3_.substr(1);
   }
   return normalizeLegacyUrl(_loc4_ + _loc3_);
}
function configureLegacyGlobals()
{
   if(_global.mainURL == undefined || _global.mainURL == "")
   {
      _global.mainURL = "http://127.0.0.1:5358/";
   }
   _global.mainURL = legacyEnsureTrailingSlash(normalizeLegacyUrl(_global.mainURL));
   if(_global.apiBaseURL == undefined || _global.apiBaseURL == "")
   {
      _global.apiBaseURL = _global.mainURL;
   }
   _global.apiBaseURL = legacyEnsureTrailingSlash(normalizeLegacyUrl(_global.apiBaseURL));
   if(_global.assetBaseURL == undefined || _global.assetBaseURL == "")
   {
      _global.assetBaseURL = _global.mainURL;
   }
   _global.assetBaseURL = legacyEnsureTrailingSlash(normalizeLegacyUrl(_global.assetBaseURL));
   if(_global.apiBridgeURL == undefined || _global.apiBridgeURL == "")
   {
      _global.apiBridgeURL = _global.apiBaseURL + "api/legacy/bridge";
   }
   _global.apiBridgeURL = normalizeLegacyUrl(_global.apiBridgeURL);
   if(_global.cacheURL == undefined || _global.cacheURL == "")
   {
      _global.cacheURL = _global.assetBaseURL + "cache/";
   }
   _global.cacheURL = legacyEnsureTrailingSlash(normalizeLegacyUrl(_global.cacheURL));
   if(_global.devURL == undefined || _global.devURL == "")
   {
      _global.devURL = _global.mainURL;
   }
   _global.devURL = legacyEnsureTrailingSlash(normalizeLegacyUrl(_global.devURL));
   if(_global.uggURL == undefined || _global.uggURL == "")
   {
      _global.uggURL = _global.mainURL;
   }
   _global.uggURL = legacyEnsureTrailingSlash(normalizeLegacyUrl(_global.uggURL));
   if(_global.adminURL == undefined || _global.adminURL == "")
   {
      _global.adminURL = _global.mainURL;
   }
   _global.adminURL = legacyEnsureTrailingSlash(normalizeLegacyUrl(_global.adminURL));
   if(_global.adminDevURL == undefined || _global.adminDevURL == "")
   {
      _global.adminDevURL = _global.devURL;
   }
   _global.adminDevURL = legacyEnsureTrailingSlash(normalizeLegacyUrl(_global.adminDevURL));
   if(_global.wwwDevURL == undefined || _global.wwwDevURL == "")
   {
      _global.wwwDevURL = _global.devURL;
   }
   _global.wwwDevURL = legacyEnsureTrailingSlash(normalizeLegacyUrl(_global.wwwDevURL));
   _global.mainDomain = legacyExtractHost(_global.mainURL);
   if(_global.devDomain == undefined || _global.devDomain == "")
   {
      _global.devDomain = legacyExtractHost(_global.devURL);
   }
   if(_global.socketHost == undefined || _global.socketHost == "" || _global.socketHost == "*")
   {
      if(_global.socketURL != undefined && _global.socketURL != "")
      {
         _global.socketHost = legacyExtractHost(_global.socketURL);
      }
      else
      {
         _global.socketHost = _global.mainDomain;
      }
   }
   _global.socketHost = legacyExtractHost(_global.socketHost);
   if(_global.socketURL == undefined || _global.socketURL == "")
   {
      _global.socketURL = _global.socketHost;
   }
   if(isNaN(_global.socketPort) || Number(_global.socketPort) <= 0 || Number(_global.socketPort) == 5357)
   {
      if(!isNaN(_global.multiuserPort) && Number(_global.multiuserPort) > 0)
      {
         _global.socketPort = Number(_global.multiuserPort);
      }
      else
      {
         _global.socketPort = 1626;
      }
   }
   if(_global.storeLinkURL == undefined || _global.storeLinkURL == "")
   {
      _global.storeLinkURL = _global.mainURL + "1320Shop_points.aspx";
   }
   if(_global.fundsBettingURL == undefined || _global.fundsBettingURL == "")
   {
      _global.fundsBettingURL = _global.mainURL + "funds_betting.aspx";
   }
   if(_global.teamCreationURL == undefined || _global.teamCreationURL == "")
   {
      _global.teamCreationURL = _global.mainURL + "teams_creatingTeams.aspx";
   }
   if(_global.pointsURL == undefined || _global.pointsURL == "")
   {
      _global.pointsURL = _global.storeLinkURL;
   }
   if(_global.membershipURL == undefined || _global.membershipURL == "")
   {
      _global.membershipURL = _global.mainURL + "1320Shop_default.aspx";
   }
   if(_global.connectionFAQURL == undefined || _global.connectionFAQURL == "")
   {
      _global.connectionFAQURL = _global.mainURL + "support_connection.aspx";
   }
   if(_global.testDriveFAQURL == undefined || _global.testDriveFAQURL == "")
   {
      _global.testDriveFAQURL = _global.mainURL + "support_testdrive.aspx";
   }
   if(_global.uggFAQURL == undefined || _global.uggFAQURL == "")
   {
      _global.uggFAQURL = _global.mainURL + "support_ugg.aspx";
   }
   if(_global.fbInviteDevURL == undefined || _global.fbInviteDevURL == "")
   {
      _global.fbInviteDevURL = _global.devURL + "invite.aspx";
   }
   if(_global.fbInviteURL == undefined || _global.fbInviteURL == "")
   {
      _global.fbInviteURL = _global.mainURL + "invite.aspx";
   }
   if(_global.specialeventsURL == undefined || _global.specialeventsURL == "")
   {
      _global.specialeventsURL = _global.mainURL + "specialevents.aspx";
   }
   if(_global.streetCredURL == undefined || _global.streetCredURL == "")
   {
      _global.streetCredURL = _global.mainURL + "streetCred.aspx";
   }
   _global.storeLinkURL = normalizeLegacyUrl(_global.storeLinkURL);
   _global.fundsBettingURL = normalizeLegacyUrl(_global.fundsBettingURL);
   _global.teamCreationURL = normalizeLegacyUrl(_global.teamCreationURL);
   _global.pointsURL = normalizeLegacyUrl(_global.pointsURL);
   _global.membershipURL = normalizeLegacyUrl(_global.membershipURL);
   _global.connectionFAQURL = normalizeLegacyUrl(_global.connectionFAQURL);
   _global.testDriveFAQURL = normalizeLegacyUrl(_global.testDriveFAQURL);
   _global.uggFAQURL = normalizeLegacyUrl(_global.uggFAQURL);
   _global.fbInviteDevURL = normalizeLegacyUrl(_global.fbInviteDevURL);
   _global.fbInviteURL = normalizeLegacyUrl(_global.fbInviteURL);
   _global.specialeventsURL = normalizeLegacyUrl(_global.specialeventsURL);
   _global.streetCredURL = normalizeLegacyUrl(_global.streetCredURL);
   _root.mainURL = _global.mainURL;
}
function legacyAllowConfiguredDomains()
{
   configureLegacyGlobals();
   var _loc2_ = new Array(_global.mainDomain,_global.devDomain,legacyExtractHost(_global.uggURL),legacyExtractHost(_global.adminURL),legacyExtractHost(_global.adminDevURL),legacyExtractHost(_global.wwwDevURL));
   var _loc3_ = 0;
   while(_loc3_ < _loc2_.length)
   {
      var _loc4_ = _loc2_[_loc3_];
      if(_loc4_ != undefined && _loc4_ != "")
      {
         System.security.allowDomain(_loc4_);
      }
      _loc3_ += 1;
   }
}
function completeHttpSocketStage()
{
   if(_global.httpSocketStageComplete)
   {
      return undefined;
   }
   _global.httpSocketStageComplete = true;
   classes.Control.loginFinished("socket");
}
function loadPrefsFile()
{
   classes.GlobalData.prefsXML = new XML();
   classes.GlobalData.prefsXML.ignoreWhite = true;
   var _loc2_ = loadFile("prefs.txt");
   if(_loc2_ != undefined && _loc2_ != "")
   {
      classes.GlobalData.prefsXML.parseXML(_loc2_);
   }
   classes.GlobalData.setPrefsObj();
}
function applyServerConfigText(src)
{
   if(src == undefined)
   {
      return undefined;
   }
   var _loc3_ = String(src).split("\n");
   var _loc4_ = 0;
   for(; _loc4_ < _loc3_.length; _loc4_ += 1)
   {
      var _loc5_ = legacyTrim(_loc3_[_loc4_]);
      if(!(_loc5_.length && _loc5_.substr(0,1) != "#"))
      {
         continue;
      }
      var _loc6_ = _loc5_.indexOf("=");
      if(_loc6_ <= 0)
      {
         continue;
      }
      var _loc7_ = legacyTrim(_loc5_.substr(0,_loc6_));
      var _loc8_ = legacyTrim(_loc5_.substr(_loc6_ + 1));
      switch(_loc7_)
      {
         case "mainURL":
            _global.mainURL = _loc8_;
            break;
         case "apiBaseURL":
            _global.apiBaseURL = _loc8_;
            break;
         case "apiBridgeURL":
            _global.apiBridgeURL = _loc8_;
            break;
         case "assetBaseURL":
            _global.assetBaseURL = _loc8_;
            break;
         case "cacheURL":
            _global.cacheURL = _loc8_;
            break;
         case "socketHost":
            if(_loc8_ != "*")
            {
               _global.socketHost = _loc8_;
            }
            break;
         case "socketPort":
            if(Number(_loc8_) != 5357)
            {
               _global.socketPort = Number(_loc8_);
            }
            break;
         case "socketURL":
         case "clientSocketHost":
            _global.socketURL = _loc8_;
            _global.socketHost = _loc8_;
            break;
         case "clientSocketPort":
         case "multiuserPort":
            _global.multiuserPort = Number(_loc8_);
            _global.socketPort = Number(_loc8_);
            break;
         case "uggURL":
            _global.uggURL = _loc8_;
            break;
         case "devURL":
            _global.devURL = _loc8_;
            break;
         case "mainDomain":
            _global.mainDomain = _loc8_;
            break;
         case "devDomain":
            _global.devDomain = _loc8_;
            break;
         case "adminURL":
            _global.adminURL = _loc8_;
            break;
         case "adminDevURL":
            _global.adminDevURL = _loc8_;
            break;
         case "storeLinkURL":
            _global.storeLinkURL = _loc8_;
            break;
         case "fundsBettingURL":
            _global.fundsBettingURL = _loc8_;
            break;
         case "teamCreationURL":
            _global.teamCreationURL = _loc8_;
            break;
         case "pointsURL":
            _global.pointsURL = _loc8_;
            break;
         case "membershipURL":
            _global.membershipURL = _loc8_;
            break;
         case "connectionFAQURL":
            _global.connectionFAQURL = _loc8_;
            break;
         case "testDriveFAQURL":
            _global.testDriveFAQURL = _loc8_;
            break;
         case "uggFAQURL":
            _global.uggFAQURL = _loc8_;
            break;
         case "fbInviteDevURL":
            _global.fbInviteDevURL = _loc8_;
            break;
         case "fbInviteURL":
            _global.fbInviteURL = _loc8_;
            break;
         case "specialeventsURL":
            _global.specialeventsURL = _loc8_;
            break;
         case "wwwDevURL":
            _global.wwwDevURL = _loc8_;
            break;
         case "streetCredURL":
            _global.streetCredURL = _loc8_;
            break;
      }
   }
   configureLegacyGlobals();
}
function loadServerConfig()
{
   configureLegacyGlobals();
   var _loc2_ = new LoadVars();
   _loc2_.onData = function(src)
   {
      if(src != undefined)
      {
         _root.applyServerConfigText(src);
      }
      _global.scLevelsXML = new XML();
      _global.scLevelsXML.ignoreWhite = true;
      _global.scLevelsXML.load(_root.legacyResolveAssetUrl("scLevels.xml"));
      _global.n2CSS = new TextField.StyleSheet();
      _global.n2CSS.load(_root.legacyResolveAssetUrl("gameStyles.css"));
   };
   _loc2_.load(normalizeLegacyUrl(_global.mainURL + "server.txt?ts=" + new Date().getTime()));
}
function loginCBS()
{
   if(consoleMan == undefined && classes.Console != undefined)
   {
      consoleMan = new classes.Console(this);
   }
   completeHttpSocketStage();
}
function sendNimCB(s, rid)
{
   if(s)
   {
      var _loc3_ = new Date();
      var _loc4_ = _loc3_.getHours() + ":" + classes.NumFuncs.get2Mins(_loc3_.getMinutes());
      classes.Console.updateConverse(rid,"<br/><font color=\"#FF0000\">****This user is unavailable****</font>");
   }
}
function addNimUser(xmlStr)
{
   var _loc2_ = undefined;
   var _loc3_ = new XML();
   _loc3_.ignoreWhite = true;
   _loc3_.parseXML(xmlStr);
   if(_loc3_.firstChild.attributes.s.length)
   {
      _loc2_ = _loc3_.firstChild.childNodes.length;
      var _loc4_ = 0;
      while(_loc4_ < _loc2_)
      {
         var _loc5_ = _loc3_.firstChild.childNodes[_loc4_];
         classes.Console.addToBuddyList(_loc5_.attributes.i,_loc5_.attributes.n,_loc5_.attributes.s,_loc5_.attributes.b);
         _loc4_ += 1;
      }
      if(_loc2_)
      {
         panel.refreshMe(1);
      }
   }
}
function addSingleNimUser(i, n, s, b)
{
   classes.Console.addToBuddyList(i,n,s,b);
   panel.refreshMe(1);
}
function updateNimUser(id, userStatus)
{
   var _loc4_ = undefined;
   _loc4_ = classes.Lookup.buddyNum(id);
   if(_loc4_ >= 0)
   {
      _global.buddylist_xml.firstChild.childNodes[_loc4_].attributes.s = userStatus;
      panel.refreshMe(1);
   }
}
function getNimMessage(id, fromName, msg)
{
   if(classes.Lookup.buddyNum(id) >= 0)
   {
      if(classes.Console.findConverse(id) == undefined)
      {
         classes.Console.newConverse(id);
      }
      var _loc4_ = new Date();
      var _loc5_ = _loc4_.getHours() + ":" + classes.NumFuncs.get2Mins(_loc4_.getMinutes());
      classes.Console.updateConverse(id,"[" + _loc5_ + "] " + fromName + ": " + msg);
      classes.Console.updateIndicator(id,3);
   }
}
function deleteNimUser(id)
{
   legacyCall("DELETENIMUSER " + id,"deleteNimUserCB","POST");
}
function deleteNimUserCB(stat, id)
{
   switch(stat)
   {
      case 1:
         classes.Console.removeFromBuddyList(id);
         break;
      case 0:
      case -1:
      case -2:
   }
}
function removeNimUserCB(id)
{
   classes.Console.removeFromBuddyList(id);
}
function blockNimUser(id)
{
   legacyCall("BLOCKNIMUSER " + id,"blockNimUserCB","POST");
}
function blockNimUserCB(stat)
{
   switch(stat)
   {
      case 1:
      case 0:
      case -1:
   }
}
function unblockNimUser(id)
{
   _global.unblockUserID = id;
   legacyCall("UNBLOCKNIMUSER " + id,"unblockNimUserCB","POST");
}
function unblockNimUserCB(stat)
{
   switch(stat)
   {
      case 0:
         classes.Control.dialogAlert("Failed to Block User","Sorry, there was an error when trying to block this user.  Please try again.");
         break;
      case -1:
      case 1:
         var _loc3_ = 0;
         while(_loc3_ < _global.buddylist_xml.firstChild.childNodes.length)
         {
            if(_global.buddylist_xml.firstChild.childNodes[_loc3_].attributes.id == _global.unblockUserID)
            {
               _global.buddylist_xml.firstChild.childNodes[_loc3_].attributes.b = 0;
               delete _global.unblockUserID;
               break;
            }
            _loc3_ += 1;
         }
         classes.Console._BASE.panel.refreshMe();
   }
}
function inquiryNimUser(uname, uid)
{
   var _loc4_ = _global.outgoingRequestsXML.createElement("u");
   _loc4_.attributes.s = 2;
   _loc4_.attributes.n = uname;
   _loc4_.attributes.i = uid;
   _global.outgoingRequestsXML.firstChild.appendChild(_loc4_);
   legacyCall("INQUIRYNIMUSER \"" + uname + "\"","inquiryNimUserCB","POST");
}
function inquiryNimUserCB(stat)
{
   switch(stat)
   {
      case 1:
         classes.Control.focusBuddyList(true);
         break;
      case 0:
         _root.displayAlert("warning","Buddy Request Failed","Sorry, this username could not be found in our system.");
         break;
      case -1:
         classes.Control.focusBuddyList(true);
         break;
      case -2:
         break;
      case -3:
         classes.Control.focusBuddyList(true);
         break;
      case -4:
         classes.Control.focusBuddyList();
         break;
      case -5:
         _root.displayAlert("warning","Buddy Request Failed","Sorry, this user is not accepting requests.");
         break;
      case -6:
         _root.displayAlert("warning","Buddy Request Failed","Sorry, you must wait a while before you try to add this user as a buddy again.");
         break;
      case -7:
         _root.displayAlert("warning","Buddy List Full","Sorry, you already have the maximum number of buddies.");
         break;
      case -8:
         _root.displayAlert("warning","Buddy Request Failed","Sorry, you can\'t have yourself as your buddy.");
         break;
      case -9:
         _root.displayAlert("warning","Buddy Request Failed","Sorry, this user already has the maximum number of buddies.");
   }
}
function receiveNimInquiryCB(reqID, reqName)
{
   var _loc4_ = _global.incomingRequestsXML.createElement("u");
   _loc4_.attributes.n = reqName;
   _loc4_.attributes.i = reqID;
   _global.incomingRequestsXML.firstChild.appendChild(_loc4_);
   if(classes.Console._BASE.panel.tbB.scrollerReq._visible)
   {
      classes.Console._BASE.panel.refreshMe();
   }
}
function allowNimUser(reqID, answer)
{
   legacyCall("ALLOWNIMUSER " + reqID + ", " + answer,"allowNimUserCB","POST");
}
function allowNimUserCB(s)
{
   switch(s)
   {
      case 1:
         break;
      case -1:
         _root.displayAlert("warning","Buddy Request Failed","Sorry, you already have the maximum number of buddies.");
         break;
      case -2:
         _root.displayAlert("warning","Buddy Request Failed","Sorry, this user already has the maximum number of buddies.");
   }
}
function inquiryNimAnswerCB(recID, recName, answer)
{
   if(answer == 1)
   {
      inquiryNimOK(recID);
   }
}
function inquiryNimOK(recID)
{
   legacyCall("NIMOKRESPONSE " + recID,"","POST");
}
function deleteNimInquiredUser(aid)
{
   legacyCall("DELETENIMINQUIREDUSER " + aid,"deleteNimInquiredUserCB","POST");
}
function deleteNimInquiredUserCB(s)
{
   if(s)
   {
   }
}
function deleteNimInquireeUserCB(aid)
{
   var _loc3_ = 0;
   while(_loc3_ < _global.incomingRequestsXML.firstChild.childNodes.length)
   {
      if(_global.incomingRequestsXML.firstChild.childNodes[_loc3_].attributes.i == aid)
      {
         _global.incomingRequestsXML.firstChild.childNodes[_loc3_].removeNode();
         if(classes.Console._BASE.panel.tbB.scrollerReq._visible)
         {
            classes.Console._BASE.panel.refreshMe();
         }
         break;
      }
      _loc3_ += 1;
   }
}
function getNimIncomingRequests()
{
   legacyCall("GETNIMINREQUESTS","getNimIncomingRequestsCB","GET");
}
function getNimIncomingRequestsCB(xmlStr)
{
   _global.incomingRequestsXML = new XML();
   _global.incomingRequestsXML.ignoreWhite = true;
   _global.incomingRequestsXML.parseXML(xmlStr);
   getNimOutgoingRequests();
}
function getNimOutgoingRequests()
{
   legacyCall("GETNIMOUTREQUESTS","getNimOutgoingRequestsCB","GET");
}
function getNimOutgoingRequestsCB(xmlStr)
{
   _global.outgoingRequestsXML = new XML();
   _global.outgoingRequestsXML.ignoreWhite = true;
   _global.outgoingRequestsXML.parseXML(xmlStr);
   classes.Console._BASE.panel.tbB.showRequests = true;
   if(classes.Console.panelNum == 2)
   {
      classes.Console._BASE.panel.refreshMe();
   }
   else
   {
      classes.Console.changePanel(2);
   }
}
function chatListRoom(raceTrackID)
{
   legacyCall("LISTRACECHATROOMS " + raceTrackID,"chatListRoomCB","POST");
}
function chatListRoomCB(d)
{
   var _loc2_ = new XML();
   _loc2_.ignoreWhite = true;
   _loc2_.parseXML(d);
}
function chatListRoom2(raceTrackID, typeID)
{
   legacyCall("LISTRACECHATROOMS2 " + raceTrackID + ", " + typeID,"chatListRoom2CB","POST");
}
function chatListRoom2CB(d)
{
   _global.chatRoomListXML = new XML();
   _global.chatRoomListXML.ignoreWhite = true;
   _global.chatRoomListXML.parseXML(d);
   _global.chatRoomListMC.gotoAndPlay("showList");
}
function chatCreateRoom(raceTrackID, typeID, roomName, isPrivate, pw)
{
   legacyCall("CREATECHATROOM " + raceTrackID + ", " + typeID + ", \"" + escape(roomName) + "\", " + isPrivate + ", \"" + escape(pw) + "\"","chatCreateRoomCB","POST");
}
function chatCreateRoomCB(s, d)
{
   switch(s)
   {
      case 1:
         var _loc3_ = new XML();
         _loc3_.ignoreWhite = true;
         _loc3_.parseXML(d);
         break;
      case 0:
      case -1:
   }
}
function chatJoin(raceTrackID, chatRoomID, pw)
{
   legacyCall("JOINRACECHAT " + raceTrackID + ", " + chatRoomID + ", \"" + escape(pw) + "\"","chatJoinCB","POST");
}
function chatJoinCB(s)
{
   switch(s)
   {
      case 1:
         isInAChat = true;
         _global.sectionTrackMC.showRaceRoom();
         break;
      case 0:
         classes.Control.dialogAlert("Room Does Not Exist","Sorry, the room you are trying to enter no longer exists. Everyone in the room must have left before you entered.");
         _global.sectionTrackMC.clearWait();
         break;
      case -1:
         classes.Control.dialogAlert("Room Is Full","Sorry, this room is full. You can try again later, or find another room to join.");
         _global.sectionTrackMC.clearWait();
         break;
      case -2:
         classes.Control.dialogAlert("Banned User","Sorry, you can not enter because you have been banned from this room.");
         _global.sectionTrackMC.clearWait();
         break;
      case -3:
         classes.Control.dialogAlert("Wrong Password","You did not provide the correct password.");
         _global.sectionTrackMC.clearWait();
   }
}
function chatLeave()
{
   if(isInAChat)
   {
      legacyCall("LEAVERACECHAT","","GET");
      isInAChat = false;
   }
}
function chatListUsers()
{
   legacyCall("LISTRACECHATUSERS","chatListUsersCB","GET");
}
function chatListUsersCB(d)
{
   _global.chatObj.userListXML = new XML();
   _global.chatObj.userListXML.ignoreWhite = true;
   _global.chatObj.userListXML.parseXML(d);
   if(_global.chatObj != undefined && _global.chatObj.raceRoomMC != undefined)
   {
      _global.chatObj.raceRoomMC.CB_listUsers();
   }
}
function chatUpdateUserCB(d)
{
   var _loc3_ = new XML();
   _loc3_.ignoreWhite = true;
   _loc3_.parseXML(d);
   var _loc4_ = false;
   var _loc5_ = undefined;
   var _loc6_ = 0;
   while(_loc6_ < _loc3_.firstChild.childNodes.length)
   {
      _loc5_ = _loc3_.firstChild.childNodes[_loc6_];
      if(_loc5_.attributes.ul == "0")
      {
         _global.chatObj.userListXML.firstChild.appendChild(_loc5_);
         _loc4_ = true;
      }
      else if(_loc5_.attributes.ul == "1")
      {
         _global.chatObj.raceRoomMC.userLeaves(_loc5_.attributes.i);
      }
      _loc6_ += 1;
   }
   if(_loc4_)
   {
      delete _global.CB_getTwoRacersCars;
      _global.chatObj.raceRoomMC.CB_listUsers();
   }
   else
   {
      _global.chatObj.raceRoomMC.drawUserList();
      _global.chatObj.raceRoomMC.drawQueue();
   }
}
function chatSend(msg)
{
   legacyCall("SENDRACECHAT \"" + escape(msg) + "\"","","POST");
}
function chatGetCB(msg)
{
   classes.Chat.addToHistory(msg);
}
function raceEngineInit(raceControlMC, raceTreeMC)
{
   raceMovie = raceControlMC;
   raceTreeMovie = raceTreeMC;
   raceSound = new classes.RaceSound();
   legacyCall("runEngineGaugeInit","","GET");
}
function runEngineGaugeInitCB(redLine, nosSize, nosRemain, boostType)
{
   raceMovie.RpmRedLine = redLine;
   raceMovie.initNos(nosSize,nosRemain);
   raceMovie.initBoost(boostType);
   raceSound.RpmRedLine = redLine;
}
function runEngine(throttlePercent)
{
   legacyCall("runEngine " + throttlePercent,"runEngineCB","POST");
}
function runEngineCB(rpm, mph, d, boostPSI)
{
   raceSound.playEngineSound(rpm,boostPSI);
   if(d > -2 && d < 1)
   {
      _global.chatObj.raceRoomMC.container.isStaged = true;
   }
   else if(_global.chatObj.raceRoomMC.container.raceStarted)
   {
      _global.chatObj.raceRoomMC.container.isStaged = false;
   }
   raceMovie.s.text = d;
   if(raceMovie.updateMPH != undefined)
   {
      raceMovie.updateMPH(Math.floor(mph));
   }
   else if(raceMovie.gaugeCluster.mphMovie != undefined && raceMovie.gaugeCluster.mphMovie.mph != undefined)
   {
      raceMovie.gaugeCluster.mphMovie.mph.text = Math.floor(mph);
   }
   else
   {
      raceMovie.gaugeCluster.mph.text = Math.floor(mph);
   }
   raceMovie.rpm.text = rpm;
   raceMovie.updateRPM(rpm);
   raceMovie.updateBoost(boostPSI);
   _global.chatObj.raceRoomMC.container.updateDistance(_global.chatObj.raceRoomMC.container.myLane,d,_global.chatObj.raceRoomMC.container.raceStarted,mph * 1.466667,0);
}
function runEngineGearUp()
{
   legacyCall("runEngineGearUp","","GET");
}
function runEngineGearDown()
{
   legacyCall("runEngineGearDown","","GET");
}
function runEngineGearUpdateCB(gearNum)
{
   raceSound.playGearSound();
   if(gearNum == -1)
   {
      raceMovie.gearCluster.gear.text = "R";
   }
   else if(gearNum == 0)
   {
      raceMovie.gearCluster.gear.text = "N";
   }
   else
   {
      raceMovie.gearCluster.gear.text = gearNum;
      classes.RacePlay._MC.playEffect("gear" + gearNum);
   }
}
function runEngineSetBrake(brake)
{
   legacyCall("runEngineSetBrake " + brake,"","POST");
}
function runEngineSetClutch(clutchFeather)
{
   legacyCall("runEngineSetClutch " + clutchFeather,"","POST");
}
function runEngineSetNOS(nosState)
{
   legacyCall("runEngineSetNOS " + nosState,"","POST");
   if(nosState == 0)
   {
      raceSound.stopNitrousSound();
   }
}
function runEngineNOSCB(nosPercent)
{
   if(nosPercent <= 0)
   {
      raceSound.stopNitrousSound();
   }
   else
   {
      raceSound.playNitrousSound();
   }
   raceMovie.updateNos(nosPercent);
}
function runEngineTractionLightCB(isOn)
{
   if(isOn)
   {
      raceMovie.tractionIcon.gotoAndStop("on");
   }
   else
   {
      raceMovie.tractionIcon.gotoAndStop("off");
   }
   raceSound.updateScreech(isOn);
}
function runEngineStageLightCB(isMyCar, staged, preStaged)
{
   raceTreeMovie.setLight(!!isMyCar ? _global.chatObj.raceRoomMC.container.oppLane : _global.chatObj.raceRoomMC.container.myLane,"staged",staged);
   raceTreeMovie.setLight(!!isMyCar ? _global.chatObj.raceRoomMC.container.oppLane : _global.chatObj.raceRoomMC.container.myLane,"pre",preStaged);
}
function runEngineSetLightOnCB(position, lightName)
{
   var _loc4_ = undefined;
   switch(position)
   {
      case "p":
         _loc4_ = _global.chatObj.raceRoomMC.container.myLane;
         break;
      case "o":
         _loc4_ = _global.chatObj.raceRoomMC.container.oppLane;
         break;
      case "1":
         _loc4_ = 1;
         break;
      case "2":
         _loc4_ = 2;
         break;
      case "b":
         _loc4_ = 0;
   }
   if(lightName == "red")
   {
      raceTreeMovie.setLight(_loc4_,"green",false);
      raceTreeMovie.setLight(_loc4_,lightName,true);
   }
   else
   {
      if((_loc4_ == 0 || _loc4_ == 1) && !raceTreeMovie.red1._visible)
      {
         raceTreeMovie.setLight(1,lightName,true);
      }
      if((_loc4_ == 0 || _loc4_ == 2) && !raceTreeMovie.red2._visible)
      {
         raceTreeMovie.setLight(2,lightName,true);
      }
   }
}
function runEngineSetMyRTCB(rt)
{
   classes.RacePlay._MC.tripWire(classes.GlobalData.id,rt);
   if(rt < 0)
   {
      classes.Control.ctourneyMC.finishCompRace(-1,-1);
   }
}
function raceStartTimeCB()
{
   classes.RacePlay._MC.onRaceStartTime();
}
function raceEngineRaceInProgressCB(d)
{
   function CB_getTwoRacersCars(txml)
   {
      _global.chatObj.twoRacersCarsXML = txml;
      _global.chatObj.raceRoomMC.showContainer("raceAnnounce","inProgress");
   }
   var _loc5_ = new XML(d);
   _global.chatObj.raceObj = new Object();
   _global.chatObj.raceObj.r1Obj = new Object();
   _global.chatObj.raceObj.r2Obj = new Object();
   _global.chatObj.raceObj.r1Obj.id = _loc5_.firstChild.attributes.r1id;
   _global.chatObj.raceObj.r1Obj.cid = _loc5_.firstChild.attributes.r1acid;
   _global.chatObj.raceObj.r2Obj.id = _loc5_.firstChild.attributes.r2id;
   _global.chatObj.raceObj.r2Obj.cid = _loc5_.firstChild.attributes.r2acid;
   _global.chatObj.raceObj.r1Obj.un = _global.chatObj.raceRoomMC.lookupUserName(_global.chatObj.raceObj.r1Obj.id);
   _global.chatObj.raceObj.r2Obj.un = _global.chatObj.raceRoomMC.lookupUserName(_global.chatObj.raceObj.r2Obj.id);
   _global.chatObj.raceObj.r1Obj.ti = _loc5_.firstChild.attributes.r1tid;
   _global.chatObj.raceObj.r2Obj.ti = _loc5_.firstChild.attributes.r2tid;
   _global.chatObj.raceObj.r1Obj.tn = _global.chatObj.raceRoomMC.lookupTeamName(_global.chatObj.raceObj.r1Obj.ti);
   _global.chatObj.raceObj.r2Obj.tn = _global.chatObj.raceRoomMC.lookupTeamName(_global.chatObj.raceObj.r2Obj.ti);
   _global.chatObj.raceObj.r1Obj.sc = _loc5_.firstChild.attributes.sc1;
   _global.chatObj.raceObj.r2Obj.sc = _loc5_.firstChild.attributes.sc2;
   classes.Lookup.addCallback("raceGetTwoRacersCars",this,CB_getTwoRacersCars,_global.chatObj.raceObj.r1Obj.cid + "," + _global.chatObj.raceObj.r2Obj.cid);
   _root.raceGetTwoRacersCars(_global.chatObj.raceObj.r1Obj.cid,_global.chatObj.raceObj.r2Obj.cid);
}
function runEngineDamageLightCB()
{
   raceMovie.damageLight.gotoAndStop(2);
}
function chatKOTHGet()
{
   legacyCall("GETKOTH","","GET");
}
function chatKOTHJoin(acid, bt)
{
   classes.GlobalData.setMyRaceCarNode(acid);
   if(bt)
   {
      bt = -1;
   }
   legacyCall("JOINKOTH " + acid + ", " + bt,"chatKOTHJoinCB","POST");
}
function chatKOTHJoinCB(s)
{
   _global.chatObj.raceRoomMC.joinPanel.panel.togLineUp.gotoAndStop(1);
   _global.chatObj.raceRoomMC.joinPanel.panel.togLineUp._visible = true;
   switch(s)
   {
      case -1:
         break;
      case -2:
         _root.displayAlert("warning","Car not Available","I\'m sorry, but the car you selected is impounded.");
         break;
      case -3:
         _root.displayAlert("warning","Car not Available","I\'m sorry, but the car you selected doesn\'t belong to you.");
         break;
      case -4:
         _root.displayAlert("warning","Invalid Dial In Time","I\'m sorry, but the dial-in time you entered is not valid.");
   }
}
function chatKOTHNewRacerCB(aid, acid)
{
   var _loc4_ = new XMLNode(1,"k");
   _loc4_.attributes.i = aid;
   _loc4_.attributes.ci = acid;
   _global.chatObj.queueXML.firstChild.appendChild(_loc4_);
   if(classes.GlobalData.id == aid)
   {
      _global.chatObj.raceRoomMC.joinPanel.panel.togLineUp.gotoAndStop("inLine");
      _global.chatObj.raceRoomMC.joinPanel.panel.togLineUp._visible = true;
   }
   _global.chatObj.raceRoomMC.drawQueue();
}
function chatKOTHUsersCB(d)
{
   _global.chatObj.queueXML = new XML();
   _global.chatObj.queueXML.ignoreWhite = true;
   _global.chatObj.queueXML.parseXML(d);
   _global.chatObj.raceRoomMC.checkForData();
}
function chatKOTHNRaceCB(d)
{
   function CB_getTwoRacersCars(txml)
   {
      _global.chatObj.twoRacersCarsXML = txml;
      if(classes.GlobalData.id == _global.chatObj.raceObj.r1Obj.id)
      {
         _global.chatObj.raceRoomMC.joinPanel.panel.togLineUp._visible = false;
         if(Number(_global.chatObj.queueXML.firstChild.firstChild.attributes.ks) <= 0)
         {
            _global.chatObj.raceRoomMC.showChallengerNew2();
         }
         else
         {
            _global.chatObj.raceRoomMC.showKingChallenge();
         }
      }
      else if(classes.GlobalData.id == _global.chatObj.raceObj.r2Obj.id)
      {
         _global.chatObj.raceRoomMC.joinPanel.panel.togLineUp._visible = false;
         _global.chatObj.raceRoomMC.showChallengerNew2();
      }
      else
      {
         _global.chatObj.raceRoomMC.joinPanel.panel.togLineUp.gotoAndStop(1);
         _global.chatObj.raceRoomMC.joinPanel.panel.togLineUp._visible = true;
         _global.chatObj.raceRoomMC.showContainer("racePrep");
      }
   }
   var _loc5_ = new XML(d);
   _global.chatObj.queueXML.firstChild.childNodes[0].attributes.sc = _loc5_.firstChild.attributes.sc1;
   _global.chatObj.queueXML.firstChild.childNodes[1].attributes.sc = _loc5_.firstChild.attributes.sc2;
   _global.chatObj.raceObj = new Object();
   _global.chatObj.raceObj.r1Obj = new Object();
   _global.chatObj.raceObj.r2Obj = new Object();
   _global.chatObj.raceObj.r1Obj.id = _loc5_.firstChild.attributes.r1id;
   _global.chatObj.raceObj.r1Obj.cid = _loc5_.firstChild.attributes.r1cid;
   _global.chatObj.raceObj.r2Obj.id = _loc5_.firstChild.attributes.r2id;
   _global.chatObj.raceObj.r2Obj.cid = _loc5_.firstChild.attributes.r2cid;
   _global.chatObj.raceObj.r1Obj.bt = _loc5_.firstChild.attributes.b1;
   _global.chatObj.raceObj.r2Obj.bt = _loc5_.firstChild.attributes.b2;
   _global.chatObj.raceObj.r1Obj.un = _global.chatObj.raceRoomMC.lookupUserName(_global.chatObj.raceObj.r1Obj.id);
   _global.chatObj.raceObj.r2Obj.un = _global.chatObj.raceRoomMC.lookupUserName(_global.chatObj.raceObj.r2Obj.id);
   _global.chatObj.raceObj.r1Obj.ti = _global.chatObj.raceRoomMC.lookupTeamID(_global.chatObj.raceObj.r1Obj.id);
   _global.chatObj.raceObj.r2Obj.ti = _global.chatObj.raceRoomMC.lookupTeamID(_global.chatObj.raceObj.r2Obj.id);
   _global.chatObj.raceObj.r1Obj.tn = _global.chatObj.raceRoomMC.lookupTeamName(_global.chatObj.raceObj.r1Obj.ti);
   _global.chatObj.raceObj.r2Obj.tn = _global.chatObj.raceRoomMC.lookupTeamName(_global.chatObj.raceObj.r2Obj.ti);
   _global.chatObj.raceObj.r1Obj.sc = _loc5_.firstChild.attributes.sc1;
   _global.chatObj.raceObj.r2Obj.sc = _loc5_.firstChild.attributes.sc2;
   _global.chatObj.raceObj.t = _loc5_.firstChild.attributes.t;
   _global.chatObj.raceObj.mb = _loc5_.firstChild.attributes.mb;
   classes.Lookup.addCallback("raceGetTwoRacersCars",this,CB_getTwoRacersCars,_global.chatObj.raceObj.r1Obj.cid + "," + _global.chatObj.raceObj.r2Obj.cid);
   _root.raceGetTwoRacersCars(_global.chatObj.raceObj.r1Obj.cid,_global.chatObj.raceObj.r2Obj.cid);
   false;
}
function chatKOTHLeave()
{
   legacyCall("LEAVEKOTH","chatKOTHLeaveCB","GET");
}
function chatKOTHLeaveCB(aid, isKing)
{
   if(aid == classes.GlobalData.id)
   {
      _global.chatObj.raceRoomMC.joinPanel.panel.togLineUp.gotoAndStop(1);
      _global.chatObj.raceRoomMC.joinPanel.panel.togLineUp._visible = true;
   }
   if(isKing)
   {
      _root.abc.closeMe();
      _global.chatObj.raceRoomMC.showContainer("raceKingStepsDown");
   }
   else
   {
      _global.chatObj.raceRoomMC.updateQueue(aid,"",true);
   }
}
function chatCheerVote(isBoo, aid)
{
   if(aid)
   {
      aid = 0;
   }
   legacyCall("SENDVOTE " + isBoo + ", " + aid,"chatCheerVoteCB","POST");
}
function chatCheerVoteCB(s)
{
   switch(s)
   {
      case 1:
      case 0:
      case -1:
   }
}
function chatCheerGetVoteCB(aid, isBoo, iid)
{
   if(_global.chatObj.raceRoomMC.container.linkName == "racePlay")
   {
      _global.chatObj.raceRoomMC.container.addVote(aid,isBoo,iid);
   }
}
function chatKOTHKingContinue(bet, bt)
{
   if(bet)
   {
      bet = 0;
   }
   if(bt)
   {
      bt = -1;
   }
   legacyCall("KCNT " + bet + ", " + bt,"","POST");
}
function raceKOTHFinishCB(d)
{
   var _loc3_ = new XML(d);
   _global.chatObj.raceRoomMC.container.crossWire(_loc3_.firstChild.attributes.i,_loc3_.firstChild.attributes.et,_loc3_.firstChild.attributes.ts);
   classes.Chat.enableWindow();
}
function raceKOTHRTOpponentCB(rt)
{
   var _loc4_ = _global.chatObj.raceRoomMC.container;
   var _loc5_ = undefined;
   if(_loc4_.racer1Obj.id == classes.GlobalData.id)
   {
      _loc5_ = _loc4_.racer2Obj.id;
   }
   else
   {
      _loc5_ = _loc4_.racer1Obj.id;
   }
   if(rt == -1)
   {
      _root.raceTreeMovie.setLight(_global.chatObj.raceRoomMC.container.oppLane,"green",false);
      _root.raceTreeMovie.setLight(_global.chatObj.raceRoomMC.container.oppLane,"red",true);
   }
   _loc4_.tripWire(_loc5_,rt);
}
function raceKOTHRTCB(r, rt)
{
   _global.chatObj.raceRoomMC.container.tripWire(_global.chatObj.raceRoomMC.container["racer" + r + "Obj"].id,rt);
   if(rt == -1)
   {
      _root.raceTreeMovie.setLight(r,"green",false);
      _root.raceTreeMovie.setLight(r,"red",true);
   }
}
function raceKOTHIntOpponentCB(d, v, a, rpm, g)
{
   if(_global.chatObj.raceRoomMC.container.raceStarted)
   {
      _root.raceTreeMovie.setLight(_global.chatObj.raceRoomMC.container.oppLane,"pre",d > -3 && d < 0);
      _root.raceTreeMovie.setLight(_global.chatObj.raceRoomMC.container.oppLane,"staged",d > -2 && d < 1);
   }
   _global.chatObj.raceRoomMC.container.updateDistance(_global.chatObj.raceRoomMC.container.oppLane,d,_global.chatObj.raceRoomMC.container.raceStarted,v,a);
}
function raceKOTHIntCB(r, d, v, a, rpm, g)
{
   if(_global.chatObj.raceRoomMC.container.raceStarted)
   {
      _root.raceTreeMovie.setLight(r,"pre",d > -3 && d < 0);
      _root.raceTreeMovie.setLight(r,"staged",d > -2 && d < 1);
   }
   _global.chatObj.raceRoomMC.container.spectatorRender(r,d,_global.chatObj.raceRoomMC.container.raceStarted,v,a);
}
function raceKOTHFoulOpponentCB()
{
   _root.raceTreeMovie.setLight(_global.chatObj.raceRoomMC.container.oppLane,"green",false);
   _root.raceTreeMovie.setLight(_global.chatObj.raceRoomMC.container.oppLane,"red",true);
}
function raceKOTHFoulCB(r)
{
   _root.raceTreeMovie.setLight(r,"green",false);
   _root.raceTreeMovie.setLight(r,"red",true);
}
function raceKOTHOK(bet)
{
   if(bet)
   {
      bet = 0;
   }
   legacyCall("runEngineStart " + bet,"raceKOTHOKCB","POST");
}
function raceKOTHOKCB(bet, t)
{
   if(_global.chatObj.raceObj.r1Obj != undefined && classes.GlobalData.id == _global.chatObj.raceObj.r1Obj.id || _global.chatObj.raceObj.r2Obj != undefined && classes.GlobalData.id == _global.chatObj.raceObj.r2Obj.id)
   {
      classes.Control.setMapButton("racing");
      _global.chatObj.raceObj.imRacer = true;
   }
   _global.chatObj.raceObj.bt = Number(bet);
   _global.chatObj.raceObj.stageTS = new Date();
   _global.chatObj.raceObj.timeToStage = Number(t);
   if(_global.chatObj.roomType != "PT")
   {
      _global.chatObj.raceRoomMC.showContainer();
   }
}
function raceKOTHReady(s)
{
   legacyCall("KREADY " + s,"raceKOTHReadyCB","POST");
}
function raceKOTHReadyOpponentCB()
{
}
function raceKOTHReadyCB(s, t, t2)
{
   if(s == 1)
   {
      classes.RacePlay._MC.onRaceStart();
   }
}
function raceKOTHNotReadyOpponentCB()
{
}
function raceKOTHNotReadyCB(r)
{
}
function raceKOTHResultCB(d)
{
   _global.chatObj.raceRoomMC.onRaceResults(d);
}
function raceKOTHTimeoutCB(s)
{
   switch(s)
   {
      case 1:
      case 2:
      case 3:
      case 4:
   }
}
function chatQMHJoin(acid)
{
   legacyCall("JOINQMH " + acid,"chatQMHJoinCB","POST");
}
function chatQMHJoinCB(s)
{
   switch(s)
   {
      case 0:
         break;
      case -1:
         _root.displayAlert("warning","Car not Available","I\'m sorry, but the car you selected is impounded.");
         break;
      case -2:
         _root.displayAlert("warning","Car not Available","I\'m sorry, but the car you selected doesn\'t belong to you.");
   }
}
function chatQMHRaceCB(d)
{
   classes.Control.quickmatchMC.matchFound(d);
}
function chatQMHLeave()
{
   legacyCall("LEAVEQMH","chatQMHLeaveCB","GET");
}
function chatQMHLeaveCB(s)
{
   switch(s)
   {
      case 1:
      case 0:
   }
}
function chatPRChallengeRequest(aid, eacid, racid, bt, bet)
{
   legacyCall("CHALLENGEREQUEST " + aid + ", " + eacid + ", " + racid + ", " + bt + ", " + bet,"chatPRChallengeRequestCB","POST");
}
function chatPRChallengeRequestCB(s, rid)
{
   switch(s)
   {
      case 1:
      case 0:
      case -1:
      case -2:
   }
}
function chatPRCancelRequest(raceID)
{
   legacyCall("CANCELREQUEST " + raceID,"chatPRCancelRequestCB","POST");
}
function chatPRCancelRequestCB(s, raceID)
{
   switch(s)
   {
      case 1:
      case 0:
   }
}
function chatPRChallengeResponse(a)
{
   legacyCall("CHALLENGERESPONSE " + a,"chatPRChallengeResponseCB","POST");
}
function chatPRChallengeResponseCB()
{
}
function raceQMHFinishCB(d)
{
   var _loc2_ = new XML(d);
   classes.RacePlay._MC.crossWire(_loc2_.firstChild.attributes.i,_loc2_.firstChild.attributes.et,_loc2_.firstChild.attributes.ts);
   classes.Chat.enableWindow();
}
function raceQMHRTOpponentCB(rt)
{
   var _loc4_ = _global.chatObj.raceRoomMC.container;
   var _loc5_ = undefined;
   if(_loc4_.racer1Obj.id == classes.GlobalData.id)
   {
      _loc5_ = _loc4_.racer2Obj.id;
   }
   else
   {
      _loc5_ = _loc4_.racer1Obj.id;
   }
   if(rt == -1)
   {
      _root.raceTreeMovie.setLight(_global.chatObj.raceRoomMC.container.oppLane,"green",false);
      _root.raceTreeMovie.setLight(_global.chatObj.raceRoomMC.container.oppLane,"red",true);
   }
   _loc4_.tripWire(_loc5_,rt);
}
function raceQMHIntOpponentCB(d, v, a, rpm, g)
{
   if(_global.chatObj.raceRoomMC.container.raceStarted)
   {
      _root.raceTreeMovie.setLight(_global.chatObj.raceRoomMC.container.oppLane,"pre",d > -3 && d < 0);
      _root.raceTreeMovie.setLight(_global.chatObj.raceRoomMC.container.oppLane,"staged",d > -2 && d < 1);
   }
   _global.chatObj.raceRoomMC.container.updateDistance(_global.chatObj.raceRoomMC.container.oppLane,d,_global.chatObj.raceRoomMC.container.raceStarted,v,a);
}
function raceQMHReadyCB(s, t, t2)
{
   if(s == 1)
   {
      classes.RacePlay._MC.onRaceStart();
   }
}
function raceQMHResultCB(d)
{
   classes.Control.quickmatchMC.onRaceResults(d);
}
function raceQMHTimeoutCB(s)
{
   switch(s)
   {
      case 1:
      case 2:
      case 3:
      case 4:
   }
}
function chatQMBJoin(acid, bt)
{
   legacyCall("JOINQMB " + acid + ", " + bt,"chatQMBJoinCB","POST");
}
function chatQMBJoinCB(s)
{
   switch(s)
   {
      case 0:
      case -1:
   }
}
function chatQMBRaceCB(d)
{
   classes.Control.quickmatchMC.matchFound(d);
}
function chatQMBLeave()
{
   legacyCall("LEAVEQMB","chatQMBLeaveCB","GET");
}
function chatQMBLeaveCB(s)
{
   switch(s)
   {
      case 1:
      case 0:
   }
}
function chatQMSend(m)
{
   legacyCall("QMSM \"" + escape(m) + "\"","chatQMSendCB","POST");
}
function chatQMSendCB(s)
{
   switch(s)
   {
      case 0:
      case -1:
   }
}
function chatQMReceiveCB(i, u, m)
{
   var _loc4_ = "<span class=\'e5\'>" + u + ":<br />   " + m + "</span>";
   classes.Chat.addToHistory(_loc4_);
}
function chatQMLeave()
{
   legacyCall("QMLR","chatQMLeaveCB","GET");
}
function chatQMLeaveCB(s)
{
   if(s == 1)
   {
   }
}
function chatQMLeaveOpponentCB(s, i, u)
{
   if(s == 0)
   {
   }
}
function chatRIVGet()
{
   legacyCall("GETRIVALS","","GET");
}
function chatRIVListCB(d)
{
   _global.chatObj.queueXML = new XML(d);
   classes.Debug.writeLn("RIVList: " + d);
   if(_global.chatObj != undefined && _global.chatObj.raceRoomMC != undefined)
   {
      _global.chatObj.raceRoomMC.checkForData();
   }
}
function chatRIVRequest(acid, baid, bacid, bt, brt)
{
   legacyCall("RREQ " + acid + ", " + baid + ", " + bacid + ", " + bt + ", " + brt,"chatRIVRequestCB","POST");
}
function chatRIVRequestCB(s)
{
   switch(s)
   {
      case 1:
         break;
      case -1:
         _root.displayAlert("warning","Opponent Not Available","Sorry, the person you are trying to challenge is already in line to race.  You can try again later.");
         break;
      case -2:
         _root.displayAlert("warning","Cannot Create New Race","Sorry, you cannot create a challenger when you are already in line to race.");
         break;
      case -3:
         _root.displayAlert("warning","Opponent Not In Room","Sorry, the person you are trying to challenge is not currently in the room.");
         break;
      case -4:
         _root.displayAlert("warning","Opponent Does Not Qualify","Sorry, the person you are trying to challenge cannot race their only car for pink slips.");
         break;
      case -5:
         _root.displayAlert("warning","Opponent Does Not Qualify","Sorry, either you or the person you are challenging cannot race for pink slips because of insufficient garage space.");
         break;
      case -6:
         _root.displayAlert("warning","Not Enough Funds","Sorry, either you or the person you are trying to challenge does not have enough funds for the bet.");
         break;
      case -7:
         _root.displayAlert("warning","Opponent Not In Room","Sorry, the person you are trying to challenge is not currently in the room.");
         break;
      case -8:
         _root.displayAlert("warning","Car not Available","I\'m sorry, but the challengee\'s car is impounded.");
         break;
      case -9:
         _root.displayAlert("warning","Car not Available","I\'m sorry, but the challenger\'s car is impounded.");
         break;
      case -10:
         _root.displayAlert("warning","Car not Available","I\'m sorry, but the car you selected doesn\'t belong to you.");
         break;
      case -11:
         _root.displayAlert("warning","Invalid Dial In Time","I\'m sorry, but the dial-in time you entered is not valid.");
   }
}
function chatRIVChallengeCB(d)
{
   classes.RivalsChallengePanel.addChallenge(d);
}
function chatRIVResponse(bacid, aaid, aacid, bt, rt, brt1, brt2, id)
{
   if(brt1)
   {
      brt1 = -1;
   }
   if(brt2)
   {
      brt2 = -1;
   }
   legacyCall("RRSP " + bacid + ", " + aaid + ", " + aacid + ", " + bt + ", " + rt + ", " + brt1 + ", " + brt2 + ", \"" + id + "\"","chatRIVResponseCB","POST");
}
function chatRIVResponseCB(s, id)
{
   switch(s)
   {
      case 1:
         classes.RivalsChallengePanel.removeChallenge(id);
         break;
      case -1:
         _root.displayAlert("warning","Cannot Accept New Race","Sorry, you cannot accept a new challenge when you are already in line to race.");
         break;
      case -2:
         _root.displayAlert("warning","Opponent Not Available","Sorry, the challenger is already in line to race.  You can try again later.");
         break;
      case -3:
         _root.displayAlert("warning","Opponent Not In Room","Sorry, the challenger is no longer in the room.");
         classes.RivalsChallengePanel.removeChallenge(id);
         break;
      case -4:
         _root.displayAlert("warning","Does Not Qualify","Sorry, either you or the challenger only has one car so cannot race for pink slips.");
         break;
      case -5:
         _root.displayAlert("warning","Does Not Qualify","Sorry, either you or the challenger cannot race for pink slips because of insufficient garage space.  When racing for pinks, both racers need at least one open garage space so that there is rooom for a won car.");
         break;
      case -6:
         _root.displayAlert("warning","Not Enough Funds","Sorry, either you or the challenger does not have enough funds for this bet.");
         break;
      case -7:
         _root.displayAlert("warning","Opponent Not In Room","Sorry, the person you are trying to challenge is not currently in the room.");
         break;
      case -8:
         _root.displayAlert("warning","Car not Available","I\'m sorry, but the challengee\'s car is impounded.");
         break;
      case -9:
         _root.displayAlert("warning","Car not Available","I\'m sorry, but the challenger\'s car is impounded.");
         break;
      case -10:
         _root.displayAlert("warning","Car not Available","I\'m sorry, but the car you selected doesn\'t belong to you.");
         break;
      case -11:
         _root.displayAlert("warning","Invalid Dial In Time","I\'m sorry, but the dial-in time you entered is not valid.");
         break;
      default:
         _root.displayAlert("warning","Error","Sorry, some error occured which made this challenge impossible.");
   }
}
function chatRIVDeniedCB(aid)
{
}
function chatRIVChallengerDrop()
{
   legacyCall("RCNL","chatRIVChallengerDropCB","GET");
}
function chatRIVChallengerDropCB(s)
{
   switch(s)
   {
      case 1:
      case 0:
      case -1:
   }
}
function chatRIVChallengeeDropCB(aid)
{
   classes.RivalsChallengePanel.clearChallengesFrom(aid);
}
function chatRIVJoinCB(d)
{
   var _loc3_ = new XML(d);
   classes.Debug.writeLn("RIVadd: " + _loc3_.firstChild.firstChild.attributes.icid + "_" + _loc3_.firstChild.firstChild.attributes.cicid);
   var _loc4_ = false;
   var _loc5_ = 0;
   while(_loc5_ < _global.chatObj.queueXML.firstChild.childNodes.length)
   {
      if(_global.chatObj.queueXML.firstChild.childNodes[_loc5_].attributes.icid == _loc3_.firstChild.firstChild.attributes.icid && _global.chatObj.queueXML.firstChild.childNodes[_loc5_].attributes.cicid == _loc3_.firstChild.firstChild.attributes.cicid)
      {
         _loc4_ = true;
      }
      _loc5_ += 1;
   }
   if(_loc4_)
   {
      _global.chatObj.queueXML.firstChild.appendChild(_loc3_.firstChild.firstChild);
      _global.chatObj.raceRoomMC.drawQueue();
   }
   false;
}
function chatRIVNRaceCB(d)
{
   function CB_getTwoRacersCars(pxml)
   {
      _global.chatObj.twoRacersCarsXML = pxml;
      if(classes.GlobalData.id == _global.chatObj.raceObj.r1Obj.id)
      {
         classes.GlobalData.setMyRaceCarNode(_global.chatObj.raceObj.r1Obj.cid);
         _global.chatObj.raceRoomMC.showChallengerNew2();
      }
      else if(classes.GlobalData.id == _global.chatObj.raceObj.r2Obj.id)
      {
         classes.GlobalData.setMyRaceCarNode(_global.chatObj.raceObj.r2Obj.cid);
         _global.chatObj.raceRoomMC.showChallengerNew2();
      }
   }
   var _loc5_ = new XML(d);
   var _loc6_ = _loc5_.firstChild.attributes;
   var _loc7_ = 0;
   if(classes.GlobalData.id == _loc6_.r1id)
   {
      _loc7_ = _loc6_.r1cid;
   }
   else if(classes.GlobalData.id == _loc6_.r2id)
   {
      _loc7_ = _loc6_.r2cid;
   }
   classes.RivalsChallengePanel.removeChallenge(_loc6_.r1cid + "_" + _loc6_.r2cid);
   if(_loc7_)
   {
      legacyCall("executeCall \"getonecarengine\", \"acid=" + _loc7_ + "\"","","POST");
   }
   _global.chatObj.raceObj = new Object();
   _global.chatObj.raceObj.r1Obj = new Object();
   _global.chatObj.raceObj.r2Obj = new Object();
   _global.chatObj.raceObj.r1Obj.id = _loc5_.firstChild.attributes.r1id;
   _global.chatObj.raceObj.r1Obj.cid = _loc5_.firstChild.attributes.r1cid;
   _global.chatObj.raceObj.r2Obj.id = _loc5_.firstChild.attributes.r2id;
   _global.chatObj.raceObj.r2Obj.cid = _loc5_.firstChild.attributes.r2cid;
   _global.chatObj.raceObj.r1Obj.bt = _loc5_.firstChild.attributes.b1;
   _global.chatObj.raceObj.r2Obj.bt = _loc5_.firstChild.attributes.b2;
   _global.chatObj.raceObj.r1Obj.un = _global.chatObj.raceRoomMC.lookupUserName(_global.chatObj.raceObj.r1Obj.id);
   _global.chatObj.raceObj.r2Obj.un = _global.chatObj.raceRoomMC.lookupUserName(_global.chatObj.raceObj.r2Obj.id);
   _global.chatObj.raceObj.r1Obj.ti = _global.chatObj.raceRoomMC.lookupTeamID(_global.chatObj.raceObj.r1Obj.id);
   _global.chatObj.raceObj.r2Obj.ti = _global.chatObj.raceRoomMC.lookupTeamID(_global.chatObj.raceObj.r2Obj.id);
   _global.chatObj.raceObj.r1Obj.tn = _global.chatObj.raceRoomMC.lookupTeamName(_global.chatObj.raceObj.r1Obj.ti);
   _global.chatObj.raceObj.r2Obj.tn = _global.chatObj.raceRoomMC.lookupTeamName(_global.chatObj.raceObj.r2Obj.ti);
   _global.chatObj.raceObj.r1Obj.sc = _loc5_.firstChild.attributes.sc1;
   _global.chatObj.raceObj.r2Obj.sc = _loc5_.firstChild.attributes.sc2;
   _global.chatObj.raceObj.bt = _loc5_.firstChild.attributes.bt;
   _global.chatObj.raceObj.t = _loc5_.firstChild.attributes.t;
   classes.Lookup.addCallback("raceGetTwoRacersCars",this,CB_getTwoRacersCars,_global.chatObj.raceObj.r1Obj.cid + "," + _global.chatObj.raceObj.r2Obj.cid);
   _root.raceGetTwoRacersCars(_global.chatObj.raceObj.r1Obj.cid,_global.chatObj.raceObj.r2Obj.cid);
   false;
}
function chatRIVLeave()
{
   legacyCall("RLVE","chatRIVLeaveCB","GET");
}
function chatRIVLeaveCB(s)
{
}
function chatRIVLeftCB(d)
{
   _global.chatObj.raceRoomMC.updateQueue(d,true);
}
function raceRIVFinishCB(d)
{
   var _loc3_ = new XML(d);
   _global.chatObj.raceRoomMC.container.crossWire(_loc3_.firstChild.attributes.i,_loc3_.firstChild.attributes.et,_loc3_.firstChild.attributes.ts);
   classes.Chat.enableWindow();
}
function raceRIVRTOpponentCB(rt)
{
   var _loc4_ = _global.chatObj.raceRoomMC.container;
   var _loc5_ = undefined;
   if(_loc4_.racer1Obj.id == classes.GlobalData.id)
   {
      _loc5_ = _loc4_.racer2Obj.id;
   }
   else
   {
      _loc5_ = _loc4_.racer1Obj.id;
   }
   if(rt == -1)
   {
      _root.raceTreeMovie.setLight(_global.chatObj.raceRoomMC.container.oppLane,"green",false);
      _root.raceTreeMovie.setLight(_global.chatObj.raceRoomMC.container.oppLane,"red",true);
   }
   _loc4_.tripWire(_loc5_,rt);
}
function raceRIVRTCB(r, rt)
{
   _global.chatObj.raceRoomMC.container.tripWire(_global.chatObj.raceRoomMC.container["racer" + r + "Obj"].id,rt);
   if(rt == -1)
   {
      _root.raceTreeMovie.setLight(r,"green",false);
      _root.raceTreeMovie.setLight(r,"red",true);
   }
}
function raceRIVIntOpponentCB(d, v, a, rpm, g)
{
   if(_global.chatObj.raceRoomMC.container.raceStarted)
   {
      _root.raceTreeMovie.setLight(_global.chatObj.raceRoomMC.container.oppLane,"pre",d > -3 && d < 0);
      _root.raceTreeMovie.setLight(_global.chatObj.raceRoomMC.container.oppLane,"staged",d > -2 && d < 1);
   }
   _global.chatObj.raceRoomMC.container.updateDistance(_global.chatObj.raceRoomMC.container.oppLane,d,_global.chatObj.raceRoomMC.container.raceStarted,v,a);
}
function raceRIVIntCB(r, d, v, a, rpm, g)
{
   if(_global.chatObj.raceRoomMC.container.raceStarted)
   {
      _root.raceTreeMovie.setLight(r,"pre",d > -3 && d < 0);
      _root.raceTreeMovie.setLight(r,"staged",d > -2 && d < 1);
   }
   _global.chatObj.raceRoomMC.container.spectatorRender(r,d,_global.chatObj.raceRoomMC.container.raceStarted,v,a);
}
function raceRIVOK()
{
   legacyCall("RIVOK","raceRIVOKCB","GET");
}
function raceRIVOKCB(t)
{
   _global.chatObj.raceRoomMC.showContainer();
}
function raceRIVReadyOpponentCB()
{
}
function raceRIVReadyCB(s, t, t2)
{
   if(s == 1)
   {
      classes.RacePlay._MC.onRaceStart();
   }
}
function raceRIVResultCB(d)
{
   _global.chatObj.raceRoomMC.onRaceResults(d);
}
function raceRIVTimeoutCB(s)
{
   switch(s)
   {
      case 1:
      case 2:
      case 3:
   }
}
function teamRoleCB(d)
{
   switch(d)
   {
      case 4:
      case 3:
      case 2:
      case 1:
         break;
      case 0:
         delete _global.teamXML;
         _global.loginXML.firstChild.firstChild.attributes.tr = "";
         _global.loginXML.firstChild.firstChild.attributes.ti = "";
         if(classes.Frame.__MC.sectionHolder.sectionClip.objectName == "sectionTeamHQ")
         {
            classes.Frame.__MC.createMap();
            classes.Control.setMapButton();
         }
         _root.displayAlert("success","You Have Quit the Team","You have successfully quit the team.  You will no longer be able to view this team\'s details in the Team HQ.");
   }
}
function teamKick(aidtk)
{
   _global.teamKickID = aidtk;
   legacyCall("TEAMKICK " + aidtk,"teamKickCB","POST");
}
function teamKickCB(s)
{
   switch(s)
   {
      case 1:
         break;
      case 0:
         _root.displayAlert("warning","You can\'t Kick Yourself Out","You can\'t kick yourself out of the team. You can leave the team by clicking on Quit Team.");
         break;
      case -1:
         _root.displayAlert("warning","Not a Leader","I\'m sorry, only team leader can kick someone out the team.");
         break;
      case -2:
         _root.displayAlert("warning","Member Not Found","The member you tried to kick out is no longer on your team.");
   }
   classes.Lookup.runCallback("teamKick","",s);
}
function teamDemote(aidtd)
{
   _global.teamDemoteID = aidtd;
   legacyCall("TEAMDEMOTE " + aidtd,"teamDemoteCB","POST");
}
function teamDemoteCB(s)
{
   switch(s)
   {
      case 1:
         classes.Lookup.runCallback("teamDemote","",s);
         break;
      case 0:
         _root.displayAlert("warning","Not the Leader","Only the team leader can modify someone\'s role on the team.");
         classes.Lookup.clearCallback("teamDemote","");
         break;
      case -1:
         _root.displayAlert("warning","Member Not Found","The member you tried to modify is no longer on your team.");
         classes.Lookup.clearCallback("teamDemote","");
         break;
      case -2:
         _root.displayAlert("warning","Access Denied","You can\'t demote the Leader or the Majority Owner of the team.");
         classes.Lookup.clearCallback("teamDemote","");
   }
}
function teamAppointDealer(aidta)
{
   _global.teamAppointID = aidta;
   legacyCall("TEAMSETDEALER " + aidta,"teamAppointDealerCB","POST");
}
function teamAppointDealerCB(s)
{
   switch(s)
   {
      case 1:
         break;
      case 0:
         _root.displayAlert("warning","Access Denied","You can\'t appoint a dealer if you\'re not a leader or an owner of the team.");
         break;
      case -1:
         _root.displayAlert("warning","Member Not Found","The member you tried to appoint is no longer on your team.");
         break;
      case -2:
         _root.displayAlert("warning","Access Denied","You can\'t appoint a leader or an owner of the team.");
         break;
      case -3:
         _root.displayAlert("warning","Too Many Dealers","You have too many dealers on your team, please demote someone before assigning a new one.");
   }
   classes.Lookup.runCallback("teamAppointDealer","",s);
}
function teamDeposit(amount)
{
   classes.SectionTeamHQ.depositObj.amount = amount;
   legacyCall("TEAMDEPOSIT " + amount,"teamDepositCB","POST");
}
function teamDepositCB(s)
{
   switch(s)
   {
      case 1:
         classes.Lookup.runCallback("teamDeposit","",1);
         break;
      case 0:
         _root.displayAlert("warning","Not on the Team","You are no longer on the team you tried to deposit the money to.");
         classes.Lookup.clearCallback("teamDeposit","");
         break;
      case -1:
         _root.displayAlert("warning","Insufficient Funds","I\'m sorry, you can\'t deposit more than what you have.");
         classes.Lookup.clearCallback("teamDeposit","");
   }
}
function teamWithdrawal(amount)
{
   classes.SectionTeamHQ.withdrawalObj.amount = amount;
   legacyCall("TEAMWITHDRAW " + amount,"teamWithdrawalCB","POST");
}
function teamWithdrawalCB(s)
{
   switch(s)
   {
      case 1:
         classes.Lookup.runCallback("teamWithdrawal","",1);
         break;
      case 0:
         _root.displayAlert("warning","Not in the Team","You are no longer on the team you tried to withdraw the money from.");
         break;
      case -1:
         _root.displayAlert("warning","Excessive Amount","I\'m sorry, but you tried to take more than you can withdraw.");
   }
}
function teamQuit()
{
   legacyCall("TEAMQUIT","teamQuitCB","GET");
}
function teamQuitCB(s)
{
}
function teamAccept(tid)
{
   _global.teamToJoin = tid;
   legacyCall("TEAMACCEPT " + tid,"teamAcceptCB","POST");
}
function teamAcceptCB(s)
{
   switch(s)
   {
      case 1:
         _global.loginXML.firstChild.firstChild.attributes.ti = _global.teamToJoin;
         _global.loginXML.firstChild.firstChild.attributes.tr = 3;
         delete _global.teamToJoin;
         classes.Control.goSection("teamhq");
         break;
      case 0:
         _root.displayAlert("warning","Invalid Applicant","I\'m sorry, but the applicant is no longer available.");
         break;
      case -1:
         _root.displayAlert("warning","Invalid Command","I\'m sorry, but you can\'t accept a denied / pending application.");
         break;
      case -2:
         _root.displayAlert("warning","Problem with Application","I\'m sorry, there\'s a problem with the application. Please try again later.");
   }
}
function teamDisperse(amount, aidTo)
{
   classes.SectionTeamHQ.disburseObj.amount = amount;
   classes.SectionTeamHQ.disburseObj.toid = aidTo;
   legacyCall("TEAMDISPERSE " + amount + ", " + aidTo,"teamDisperseCB","POST");
}
function teamDisperseCB(s)
{
   switch(s)
   {
      case 1:
         classes.Lookup.runCallback("teamDisperse","",1);
         break;
      case 0:
         _root.displayAlert("warning","Access Denied","I\'m sorry, but only a team leader can disperse funds.");
         break;
      case -1:
         _root.displayAlert("warning","Insufficient Fund","I\'m sorry, but the team doesn\'t have that much money.");
   }
}
function teamCreate(n)
{
   legacyCall("TEAMCREATE \"" + escape(n) + "\"","teamCreateCB","POST");
}
function teamCreateCB(s, tid)
{
   switch(s)
   {
      case 1:
         classes.GlobalData.updateInfo("ti",tid);
         classes.GlobalData.updateInfo("tr",1);
         break;
      case 0:
         _root.displayAlert("warning","Invalid Name","I\'m sorry, but the team name you tried to create contained invalid words.");
         break;
      case -1:
         _root.displayAlert("warning","Already on the Team","You\'re already on the team you wanted to create.");
         break;
      case -2:
         _root.displayAlert("warning","Team Name Taken","I\'m sorry, but the team name already exists.");
   }
   classes.Lookup.runCallback("teamCreate","",s);
}
function teamStepDown()
{
   legacyCall("TEAMSTEPDOWN","teamStepDownCB","GET");
}
function teamStepDownCB(s)
{
   switch(s)
   {
      case 1:
         break;
      case 0:
         _root.displayAlert("warning","Access Denied","I\'m sorry, but only a team leader can step down.");
         break;
      case -1:
         _root.displayAlert("warning","Access Denied","I\'m sorry, but there\'s no one who can replace you if you step down.");
   }
   classes.Lookup.runCallback("teamStepDown","",s);
}
function addMoneyCB(c)
{
   classes.GlobalData.updateInfo("m",c + Number(_global.loginXML.firstChild.firstChild.attributes.m));
}
function login(u, p)
{
   var _loc4_ = new LoadVars();
   _loc4_.onHTTPStatus = function(httpStatus)
   {
      this.httpStatus = httpStatus;
      trace("login HTTP status = " + httpStatus);
   };
   _loc4_.onData = function(src)
   {
      trace("login onData status=" + this.httpStatus + " srcLen=" + (src == undefined ? -1 : src.length));
      if(src != undefined && src.length > 0)
      {
         var _loc3_ = 1;
         var _loc4_ = new XML();
         _loc4_.ignoreWhite = true;
         _loc4_.parseXML(src);
         if(_loc4_.firstChild != undefined && _loc4_.firstChild.firstChild != undefined && _loc4_.firstChild.firstChild.nodeName == "e")
         {
            _loc3_ = Number(_loc4_.firstChild.firstChild.attributes.s);
         }
         loginCB(_loc3_,src);
         if(_loc3_ == 1)
         {
            loginCBS();
         }
      }
      else
      {
         classes.Frame.serverLights(false);
         classes.Control.dialogAlert("Login Error","No response body. HTTP=" + this.httpStatus);
      }
   };
   var _loc5_ = new LoadVars();
   _loc5_.username = u;
   _loc5_.password = p;
   var _loc6_ = _global.apiBaseURL;
   if(_loc6_ == undefined || _loc6_ == "")
   {
      _loc6_ = _global.mainURL;
   }
   if(_loc6_.charAt(_loc6_.length - 1) != "/")
   {
      _loc6_ += "/";
   }
   var _loc7_ = _loc6_ + "api/auth/login";
   trace("LOGIN URL: " + _loc7_);
   trace("LOGIN BODY: " + _loc5_.toString());
   _loc5_.sendAndLoad(_loc7_,_loc4_,"POST");
   classes.Frame.serverLights(true);
}
function loginCB(stat, d)
{
   classes.Frame.serverLights(false);
   if(stat == 1)
   {
      _global.loginXML = new XML(d);
      var _loc4_ = _global.loginXML.firstChild.firstChild.attributes;
      _global.loginAttrCache = new Object();
      _global.loginAttrCache.u = _loc4_.u;
      _global.loginAttrCache.i = _loc4_.i;
      _global.loginAttrCache.m = _loc4_.m;
      _global.loginAttrCache.p = _loc4_.p;
      _global.loginAttrCache.dc = _loc4_.dc;
      _global.loginAttrCache.ti = _loc4_.ti;
      _global.loginAttrCache.tr = _loc4_.tr;
      _global.loginAttrCache.lid = _loc4_.lid;
      _global.loginAttrCache.sc = _loc4_.sc;
      _global.loginAttrCache.mb = _loc4_.mb;
      _global.loginAttrCache.act = _loc4_.act;
      _global.loginAttrCache.bg = _loc4_.bg;
      _global.loginAttrCache.im = _loc4_.im;
      _global.loginAttrCache.r = _loc4_.r;
      setHttpHudAttrCache(_global.loginAttrCache);
      _global.username = _global.loginAttrCache.u;
      classes.GlobalData.uname = _global.loginAttrCache.u;
      classes.GlobalData.id = _global.loginAttrCache.i;
      classes.GlobalData.attr = _global.loginAttrCache;
      classes.GlobalData.role = !_global.loginAttrCache.r ? 0 : Number(_global.loginAttrCache.r);
      getPaintCategories();
      getLicensePlates();
      getInfo();
      getCars();
   }
   else
   {
      classes.Frame._MC.loginGroup.gotoAndPlay(1);
      switch(stat)
      {
         case 0:
            displayAlert("warning","Incorrect Login","Sorry, your login was incorrect. Please try again.");
            break;
         case -1:
            displayAlert("warning","Duplicate Login","You are already logged in. Please close any instances of the game that you have previously opened.");
            break;
         case -2:
            displayAlert("warning","Account Banned","Sorry, your account has been banned. If you think this is in error, please contact Customer Service for help.");
            break;
         case -3:
            displayAlert("warning","Server Maintenance","Sorry, the server is under maintenance. Please check back soon.");
      }
   }
}
function getPartCategories()
{
   var _loc2_ = "";
   if(_global.shopPartsMC != undefined && _global.shopPartsMC.storeType != undefined)
   {
      _loc2_ = String(_global.shopPartsMC.storeType);
   }
   if(_global.partCatXML == undefined || _global.partCatXML.firstChild == undefined || _global.partCatStoreType != _loc2_)
   {
      classes.Frame.serverLights(true);
      _global.partCatStoreType = _loc2_;
      legacyCall("executeCall \"getallcats\", \"st=" + _loc2_ + "\"","getPartCategoriesCB","GET");
   }
   else
   {
      _global.shopPartsMC.gotoAndPlay("retrieve");
   }
}
function getPartCategoriesCB(d)
{
   classes.Frame.serverLights(false);
   _global.partCatXML = new XML();
   _global.partCatXML.ignoreWhite = true;
   _global.partCatXML.parseXML(d);
   _global.shopPartsMC.gotoAndPlay("retrieve");
}
function getParts(acid)
{
   classes.Frame.serverLights(true);
   var _loc3_ = "";
   if(_global.shopPartsMC != undefined && _global.shopPartsMC.storeType != undefined)
   {
      _loc3_ = String(_global.shopPartsMC.storeType);
   }
   legacyCall("executeCall \"getallparts\", \"acid=" + acid + "&st=" + _loc3_ + "\"","getPartsCB","POST");
}
function getPartsCB(d)
{
   classes.Frame.serverLights(false);
   _global.partXML = new XML();
   _global.partXML.ignoreWhite = true;
   _global.partXML.parseXML(d);
   _global.shopPartsMC.gotoAndPlay("showroom");
}
function buyPart(acid, pid, pt, t)
{
   classes.Frame.serverLights(true);
   switch(t)
   {
      case "c":
         legacyCall("executeCall \"buypart\", \"acid=" + acid + "&pid=" + pid + "&pt=" + pt + "\"","buyPartCB","POST");
         break;
      case "e":
         legacyCall("executeCall \"buyenginepart\", \"acid=" + acid + "&epid=" + pid + "&pt=" + pt + "\"","buyPartCB","POST");
         break;
      case "m":
         legacyCall("executeCall \"buyengine\", \"acid=" + acid + "&eid=" + pid + "&pt=" + pt + "\"","buyPartCB","POST");
   }
}
function buyPartCB(t, d1, d2)
{
   classes.Frame.serverLights(false);
   var _loc5_ = new XML();
   _loc5_.ignoreWhite = true;
   _loc5_.parseXML(d1);
   switch(Number(_loc5_.firstChild.attributes.s))
   {
      case 2:
      case 1:
         if(Number(_loc5_.firstChild.attributes.s) == 2)
         {
            classes.GlobalData.updateInfo("m",Number(_loc5_.firstChild.attributes.b));
         }
         else
         {
            classes.GlobalData.updateInfo("p",Number(_loc5_.firstChild.attributes.b));
         }
         installPartCB(t,d2,true,Number(_loc5_.firstChild.attributes.ai));
         break;
      case 0:
         _root.displayAlert("warning","Purchase Error","Sorry, the purchase attempt failed.  Please try again later.");
         break;
      case -1:
         _root.displayAlert("warning","Purchase Error","Sorry, this part is only available to users with paid memberships.  Please see www.nitto1320.com for more information.");
         break;
      case -2:
         _root.displayAlert("warning","Purchase Error","This attempt failed because the part is not available for purchase with the chosen payment method.  Please use another form of payment.");
         break;
      case -3:
         _root.displayAlert("warning","Insufficient Funds","Sorry, you do not have enough in your balance to pay for this.  Try winning some races, or you could try buying a cheaper part.");
         break;
      case -4:
         _root.displayAlert("warning","Purchase Error","This part will not fit on the selected car.");
         break;
      case -5:
         _root.displayAlert("warning","Purchase Error","Sorry, but you can\'t shop in a city higher than the one you live in.");
         break;
      case -6:
         _root.displayAlert("warning","Car not Available","I\'m sorry, but the car you selected to buy the part for is impounded.");
   }
}
function getCarPartsBin(acid)
{
   if(classes.Control.serverAvail())
   {
      classes.Frame.serverLights(true);
      legacyCall("executeCall \"getcarpartsbin\", \"acid=" + acid + "\"","getCarPartsBinCB","POST");
   }
}
function getCarPartsBinCB(d)
{
   classes.Frame.serverLights(false);
   classes.Control.serverUnlock();
   _global.partsBinXML = new XML();
   _global.partsBinXML.ignoreWhite = true;
   _global.partsBinXML.parseXML(d);
   _global.shopPartsMC.gotoAndPlay("showroom");
}
function getPartsBin()
{
   if(classes.Control.serverAvail())
   {
      classes.Frame.serverLights(true);
      legacyCall("executeCall \"getpartsbin\"","getPartsBinCB","GET");
   }
}
function getPartsBinCB(d)
{
   classes.Frame.serverLights(false);
   classes.Control.serverUnlock();
   _global.partsBinXML = new XML();
   _global.partsBinXML.ignoreWhite = true;
   _global.partsBinXML.parseXML(d);
   _global.shopPartsMC.gotoAndPlay("showroom");
}
function sellPart(acpid, t)
{
   classes.Frame.serverLights(true);
   if(t == "c")
   {
      legacyCall("executeCall \"sellcarpart\", \"acpid=" + acpid + "\"","sellPartCB","POST");
   }
   else if(t == "e")
   {
      legacyCall("executeCall \"sellenginepart\", \"aepid=" + acpid + "\"","sellPartCB","POST");
   }
   else if(t == "m")
   {
      legacyCall("executeCall \"sellengine\", \"aeid=" + acpid + "\"","sellPartCB","POST");
   }
   else
   {
      classes.Frame.serverLights(false);
   }
}
function sellPartCB(t, s, b)
{
   classes.Frame.serverLights(false);
   switch(s)
   {
      case 1:
         classes.GlobalData.updateInfo("m",Number(b));
         _root.abc.contentMC.gotoAndStop("response");
         _root.abc.contentMC.alertIconMC.gotoAndStop("shopplus");
         if(t == "m")
         {
            _root.abc.contentMC.txtTitle = "Engine is Traded In";
            _root.abc.contentMC.txtMsg = "The engine is successfully traded in.";
         }
         else
         {
            _root.abc.contentMC.txtTitle = "Part is Traded In";
            _root.abc.contentMC.txtMsg = "The part is successfully traded in.";
         }
         _root.abc.removeButtons();
         _root.abc.addButton("OK");
         _global.shopPartsMC.tradeInCartPart();
         break;
      case 0:
         _root.abc.contentMC.gotoAndStop("response");
         _root.abc.contentMC.alertIconMC.gotoAndStop("warning");
         if(t == "m")
         {
            _root.abc.contentMC.txtTitle = "Engine is Installed in a Car";
            _root.abc.contentMC.txtMsg = "I\'m sorry, but you must uninstall this engine from your car by swapping before you can trade it in.";
         }
         else
         {
            _root.abc.contentMC.txtTitle = "Part is Installed in a Car";
            _root.abc.contentMC.txtMsg = "I\'m sorry, but you must uninstall this part before you can trade it in.";
         }
         _root.abc.removeButtons();
         _root.abc.addButton("Cancel");
         _global.shopPartsMC.clearCart();
         break;
      case -1:
         _root.abc.contentMC.gotoAndStop("response");
         _root.abc.contentMC.alertIconMC.gotoAndStop("warning");
         if(t == "m")
         {
            _root.abc.contentMC.txtTitle = "Engine Not Found";
            _root.abc.contentMC.txtMsg = "I\'m sorry, but this engine cannot be found in your account.";
         }
         else
         {
            _root.abc.contentMC.txtTitle = "Part Not Found";
            _root.abc.contentMC.txtMsg = "I\'m sorry, but this part cannot be found in your account.";
         }
         _root.abc.removeButtons();
         _root.abc.addButton("Cancel");
         _global.shopPartsMC.clearCart();
         break;
      case -2:
         _root.abc.contentMC.gotoAndStop("response");
         _root.abc.contentMC.alertIconMC.gotoAndStop("warning");
         _root.abc.contentMC.txtTitle = "Part is Stock";
         _root.abc.contentMC.txtMsg = "I\'m sorry, but you cannot sell stock parts.";
         _root.abc.removeButtons();
         _root.abc.addButton("Cancel");
         _global.shopPartsMC.clearCart();
   }
}
function installPart(acpid, pid, acid, aeid, t)
{
   classes.Frame.serverLights(true);
   if(t == "c")
   {
      legacyCall("executeCall \"installpart\", \"acpid=" + acpid + "&pid=" + pid + "&acid=" + acid + "\"","installPartCB","POST");
   }
   else if(t == "e")
   {
      legacyCall("executeCall \"installenginepart\", \"aepid=" + acpid + "&epid=" + pid + "&acid=" + acid + "&aeid=" + aeid + "\"","installPartCB","POST");
   }
   else if(t == "m")
   {
      legacyCall("executeCall \"swapengine\", \"aeid=" + acpid + "&acid=" + acid + "&pt=m\"","installPartCB","POST");
   }
   else
   {
      classes.Frame.serverLights(false);
   }
}
function installPartCB(t, c, callFromBuyPart, aiFromBuyPart)
{
   classes.Frame.serverLights(false);
   var _loc7_ = new XML();
   _loc7_.ignoreWhite = true;
   _loc7_.parseXML(c);
   var _loc8_ = _loc7_.firstChild;
   switch(Number(_loc8_.attributes.s))
   {
      case 2:
      case 1:
         if(Number(_loc8_.attributes.b) > 0)
         {
            if(Number(_loc8_.attributes.s) == 2)
            {
               classes.GlobalData.updateInfo("m",Number(_loc8_.attributes.b));
            }
            else
            {
               classes.GlobalData.updateInfo("p",Number(_loc8_.attributes.b));
            }
         }
         _root.abc.contentMC.gotoAndStop("response");
         if(callFromBuyPart)
         {
            _root.abc.contentMC.alertIconMC.gotoAndStop("shopplus");
            if(t == "m")
            {
               _root.abc.contentMC.txtTitle = "Engine is Purchased and Installed";
               _root.abc.contentMC.txtMsg = "Congratulations, the engine is successfully purchased and automatically installed in your car.";
            }
            else
            {
               _root.abc.contentMC.txtTitle = "Part is Purchased and Installed";
               _root.abc.contentMC.txtMsg = "Congratulations, the part is successfully purchased and automatically installed in your car.";
            }
            _root.abc.removeButtons();
            _root.abc.addButton("OK");
            _global.shopPartsMC.installCartPart(aiFromBuyPart);
         }
         else
         {
            _root.abc.contentMC.alertIconMC.gotoAndStop("installplus");
            if(t == "m")
            {
               _root.abc.contentMC.txtTitle = "Engine is Swapped";
               _root.abc.contentMC.txtMsg = "The engine is successfully swapped in your car.";
            }
            else
            {
               _root.abc.contentMC.txtTitle = "Part is Installed";
               _root.abc.contentMC.txtMsg = "The part is successfully installed in your car.";
            }
            _root.abc.removeButtons();
            _root.abc.addButton("OK");
            _global.shopPartsMC.installCartPart();
         }
         break;
      case 0:
         _root.abc.contentMC.gotoAndStop("response");
         _root.abc.contentMC.alertIconMC.gotoAndStop("install");
         _root.abc.removeButtons();
         if(t == "m")
         {
            _root.abc.contentMC.txtTitle = "Engine is not for the Car";
            if(callFromBuyPart)
            {
               _root.abc.contentMC.txtMsg = "Congratulations, the part is successfully purchased. However, this engine doesn\'t fit in your car.";
               _root.abc.addButton("OK");
            }
            else
            {
               _root.abc.contentMC.txtMsg = "I\'m sorry, but this engine does not fit in your car.";
               _root.abc.addButton("Cancel");
            }
         }
         else
         {
            _root.abc.contentMC.txtTitle = "Part is already Installed";
            if(callFromBuyPart)
            {
               _root.abc.contentMC.txtMsg = "Congratulations, the part is successfully purchased. However, you already have this part installed in your car.";
               _root.abc.addButton("OK");
            }
            else
            {
               _root.abc.contentMC.txtMsg = "I\'m sorry, but this part is already installed in your car.";
               _root.abc.addButton("Cancel");
            }
         }
         _global.shopPartsMC.clearCart();
         break;
      case -1:
         var _loc9_ = "";
         var _loc10_ = 0;
         while(_loc10_ < _loc8_.childNodes.length)
         {
            _loc9_ += "\n" + _loc8_.childNodes[_loc10_].firstChild.nodeValue;
            _loc10_ += 1;
         }
         _root.abc.contentMC.gotoAndStop("response");
         _root.abc.contentMC.alertIconMC.gotoAndStop("install");
         _root.abc.removeButtons();
         if(t == "m")
         {
            _root.abc.contentMC.txtTitle = "Engine not Found";
            if(callFromBuyPart)
            {
               _root.abc.contentMC.txtMsg = "The engine is successfully purchased, but this engine cannot be found in the system.";
               _root.abc.addButton("OK");
            }
            else
            {
               _root.abc.contentMC.txtMsg = "I\'m sorry, but this engine cannot be found in the system.";
               _root.abc.addButton("Cancel");
            }
         }
         else
         {
            _root.abc.contentMC.txtTitle = "Part has Conflicts";
            if(callFromBuyPart)
            {
               _root.abc.contentMC.txtMsg = "The part is successfully purchased, but there are conflicting parts:" + _loc9_;
               _root.abc.addButton("OK");
            }
            else
            {
               _root.abc.contentMC.txtMsg = "I\'m sorry, but this part is conflicting with these parts:" + _loc9_;
               _root.abc.addButton("Cancel");
            }
         }
         _global.shopPartsMC.clearCart();
         break;
      case -2:
         _loc9_ = "";
         _loc10_ = 0;
         while(_loc10_ < _loc8_.childNodes.length)
         {
            _loc9_ += "\n" + _loc8_.childNodes[_loc10_].firstChild.nodeValue;
            _loc10_ += 1;
         }
         _root.abc.contentMC.gotoAndStop("response");
         _root.abc.contentMC.alertIconMC.gotoAndStop("install");
         _root.abc.contentMC.txtTitle = "Part has Requirements";
         _root.abc.removeButtons();
         if(callFromBuyPart)
         {
            _root.abc.contentMC.txtMsg = "The part you have purchased is part of a SYSTEM that must be installed from your GARAGE once you own all the required parts.";
            _root.abc.addButton("OK");
         }
         else
         {
            _root.abc.contentMC.txtMsg = "I\'m sorry, but this part requires these parts:" + _loc9_;
            _root.abc.addButton("Cancel");
         }
         _global.shopPartsMC.clearCart();
         break;
      case -3:
         _root.abc.contentMC.gotoAndStop("response");
         _root.abc.contentMC.alertIconMC.gotoAndStop("install");
         _root.abc.contentMC.txtTitle = "Kit Conflict";
         _root.abc.removeButtons();
         if(callFromBuyPart)
         {
            _root.abc.contentMC.txtMsg = "The kit is successfully purchased, but it\'s conflicting with your setup. Please go to your garage to install it manually.";
            _root.abc.addButton("OK");
         }
         else
         {
            _root.abc.contentMC.txtMsg = "I\'m sorry, but this kit can\'t be installed.";
            _root.abc.addButton("Cancel");
         }
         _global.shopPartsMC.clearCart();
         break;
      case -4:
         _root.abc.contentMC.gotoAndStop("response");
         _root.abc.contentMC.alertIconMC.gotoAndStop("install");
         _root.abc.contentMC.txtTitle = "Car Impounded";
         _root.abc.removeButtons();
         if(callFromBuyPart)
         {
            _root.abc.contentMC.txtMsg = "The part is successfully purchased, but it cannot be installed because your car is impounded.";
            _root.abc.addButton("OK");
         }
         else
         {
            _root.abc.contentMC.txtMsg = "I\'m sorry, but this part can\'t be installed because your car is impounded.";
            _root.abc.addButton("Cancel");
         }
         _global.shopPartsMC.clearCart();
   }
}
function uninstallPart(acpids, pids, acid, t)
{
   classes.Frame.serverLights(true);
   if(t == "c")
   {
      legacyCall("executeCall \"uninstallpart\", \"acpids=" + acpids + "&pids=" + pids + "&acid=" + acid + "\"","uninstallPartCB","POST");
   }
   else if(t == "e")
   {
      legacyCall("executeCall \"uninstallenginepart\", \"aepids=" + acpids + "&epids=" + pids + "&aeid=" + acid + "\"","uninstallPartCB","POST");
   }
   else
   {
      classes.Frame.serverLights(false);
   }
}
function uninstallPartCB(t, c)
{
   classes.Frame.serverLights(false);
   var _loc5_ = new XML();
   _loc5_.ignoreWhite = true;
   _loc5_.parseXML(c);
   var _loc6_ = _loc5_.firstChild;
   switch(Number(_loc6_.attributes.s))
   {
      case 1:
         _root.abc.contentMC.gotoAndStop("response");
         _root.abc.contentMC.alertIconMC.gotoAndStop("installplus");
         _root.abc.contentMC.txtTitle = "Part is Uninstalled";
         _root.abc.contentMC.txtMsg = "The part is successfully uninstalled from your car.";
         _root.abc.removeButtons();
         _root.abc.addButton("OK");
         _global.shopPartsMC.uninstallCartPart();
         break;
      case 0:
         _root.abc.contentMC.gotoAndStop("response");
         _root.abc.contentMC.alertIconMC.gotoAndStop("install");
         _root.abc.contentMC.txtTitle = "Part is Already Uninstalled";
         _root.abc.contentMC.txtMsg = "I\'m sorry, but this part is already uninstalled from your car.";
         _root.abc.removeButtons();
         _root.abc.addButton("Cancel");
         _global.shopPartsMC.clearCart();
         break;
      case -1:
         var _loc7_ = "Error, dependent parts:";
         var _loc8_ = 0;
         while(_loc8_ < _loc6_.childNodes.length)
         {
            _loc7_ += "\n" + _loc6_.childNodes[_loc8_].firstChild.nodeValue;
            _loc8_ += 1;
         }
         _root.abc.contentMC.gotoAndStop("response");
         _root.abc.contentMC.alertIconMC.gotoAndStop("install");
         _root.abc.contentMC.txtTitle = "Part is Required";
         _root.abc.contentMC.txtMsg = "I\'m sorry, but this part was required by these parts:" + _loc7_;
         _root.abc.removeButtons();
         _root.abc.addButton("Cancel");
         _global.shopPartsMC.clearCart();
         break;
      case -2:
         _root.displayAlert("warning","Car not Available","I\'m sorry, but the car you selected to buy the part for is impounded.");
         break;
      case -3:
         _root.abc.contentMC.txtTitle = "Part is Required";
         _root.abc.contentMC.txtMsg = "I\'m sorry, but this part can\'t be uninstalled.";
         _root.abc.removeButtons();
         _root.abc.addButton("Cancel");
         _global.shopPartsMC.clearCart();
   }
}
function getPaintCategories()
{
   classes.Frame.serverLights(true);
   legacyCall("executeCall \"getpaintcats\"","getPaintCategoriesCB","GET");
}
function getPaintCategoriesCB(d)
{
   classes.Frame.serverLights(false);
   _global.paintCategoriesXML = new XML(d);
   getPaints();
}
function getPaints()
{
   classes.Frame.serverLights(true);
   legacyCall("executeCall \"getpaints\"","getPaintsCB","GET");
}
function getPaintsCB(d)
{
   classes.Frame.serverLights(false);
   _global.paintsXML = new XML(d);
   _root.getCars();
}
function buyPaint(acid, partArray, pt, cartArray)
{
   _global.paintJobArr = cartArray;
   classes.Frame.serverLights(true);
   legacyCall("executeCall \"buypaint\", \"acid=" + acid + "&p=" + partArray + "&pt=" + pt + "\"","buyPaintCB","POST");
}
function buyPaintCB(s, b)
{
   classes.Frame.serverLights(false);
   if(_root.abc != undefined)
   {
      _root.abc.closeMe();
   }
   switch(s)
   {
      case 2:
      case 1:
         if(s == 1)
         {
            if(classes.GlobalData.attr != undefined)
            {
               classes.GlobalData.attr.p = b;
            }
            if(_global.loginAttrCache != undefined)
            {
               _global.loginAttrCache.p = b;
               setHttpHudAttrCache(_global.loginAttrCache);
            }
            classes.GlobalData.updateInfo("p",b);
         }
         else if(s == 2)
         {
            if(classes.GlobalData.attr != undefined)
            {
               classes.GlobalData.attr.m = b;
            }
            if(_global.loginAttrCache != undefined)
            {
               _global.loginAttrCache.m = b;
               setHttpHudAttrCache(_global.loginAttrCache);
            }
            classes.GlobalData.updateInfo("m",b);
         }
         var _loc6_ = Number(classes.GlobalData.getSelectedCarXML().attributes.i);
         delete _global.paintJobArr;
         classes.Lookup.addCallback("getOneCar",this,buyPaintRefreshCarCB,String(_loc6_));
         _root.getOneCar(_loc6_);
         break;
      case 0:
         _root.displayAlert("warning","Connection Problem","The purchase did not go through because of a server error.  Please try again later.");
         break;
      case -1:
         _root.displayAlert("warning","Illegal Action","Sorry, one or more of the selected colors are not available.");
         break;
      case -2:
         _root.displayAlert("warning","Unavailable Funds","Sorry, you do not have enough in your account to pay for this.");
         break;
      case -3:
         _root.displayAlert("warning","Car not Available","I\'m sorry, but the car you selected to buy the paint for is impounded.");
   }
}
function buyPaintRefreshCarCB(carXML)
{
   classes.GlobalData.replaceCarNode(carXML.toString());
   if(_global.shopPaintMC == undefined)
   {
      return undefined;
   }
   if(_global.shopPaintMC.cloneSelectedCarXML != undefined)
   {
      _global.shopPaintMC.cloneSelectedCarXML();
   }
   else
   {
      if(_global.shopPaintMC.getSelectedCarXML != undefined)
      {
         _global.shopPaintMC.getSelectedCarXML();
      }
      if(_global.shopPaintMC.cloneCarXML != undefined)
      {
         _global.shopPaintMC.cloneCarXML();
      }
   }
   if(_global.shopPaintMC.carHolder != undefined && _global.shopPaintMC.cloneXML != undefined)
   {
      classes.Drawing.clearThisCarsBmps(_global.shopPaintMC.carHolder);
      classes.Drawing.carView(_global.shopPaintMC.carHolder,_global.shopPaintMC.cloneXML,100,!_global.shopPaintMC.isBack ? "front" : "back");
   }
   if(_global.shopPaintMC.cartArray != undefined)
   {
      _global.shopPaintMC.cartArray = new Array();
      if(_global.shopPaintMC.priceGroup != undefined)
      {
         _global.shopPaintMC.priceGroup.txtPrice = "$0";
         _global.shopPaintMC.priceGroup.fldPrice._xscale = 100;
      }
      if(_global.shopPaintMC.pointsGroup != undefined)
      {
         _global.shopPaintMC.pointsGroup.txtPoints = "0";
         _global.shopPaintMC.pointsGroup.fldPoints._xscale = 100;
      }
   }
}
function buyPlate(acid, pid, pt)
{
   classes.Frame.serverLights(true);
   legacyCall("executeCall \"buyplate\", \"acid=" + acid + "&pid=" + pid + "&pt=" + pt + "\"","buyPlateCB","POST");
}
function buyPlateCB(s, b, pl)
{
   classes.Frame.serverLights(false);
   switch(s)
   {
      case 2:
      case 1:
         if(s == 1)
         {
            classes.GlobalData.updateInfo("p",b);
         }
         else if(s == 2)
         {
            classes.GlobalData.updateInfo("m",b);
         }
         _global.shopLicensesMC.installCartPlate(pl);
         break;
      case 0:
         _root.displayAlert("warning","Connection Problem","The purchase did not go through because of a server error.  Please try again later.");
         break;
      case -1:
         _root.displayAlert("warning","Illegal Action","Sorry, this purchase cannot be made from the store you are currently in.  Please browse to the appropriate store.");
         break;
      case -2:
         _root.displayAlert("warning","Not Enough Street Credit","Sorry, you do not have enough Street Credit to qualify for this purchase.  You need to win races and build up your cred.");
         break;
      case -3:
         _root.displayAlert("warning","Unavailable Funds","Sorry, you do not have enough in your account to pay for this.");
         break;
      case -4:
         _root.displayAlert("warning","Illegal Action","Sorry, you can\'t buy a stock plate for your car.  Stock plates only come with new car purchases.");
         break;
      case -5:
         _root.displayAlert("warning","Car not Available","I\'m sorry, but the car you selected to buy the plate for is impounded.");
   }
}
function getLicensePlates()
{
   classes.Frame.serverLights(true);
   legacyCall("executeCall \"getlicenseplates\"","getLicensePlatesCB","GET");
}
function getLicensePlatesCB(d)
{
   classes.Frame.serverLights(false);
   _global.platesXML = new XML(d);
}
function buyVanity(acid, pn, pt)
{
   classes.Frame.serverLights(true);
   legacyCall("executeCall \"buyvanity\", \"acid=" + acid + "&pn=" + escape(pn) + "&pt=" + pt + "\"","buyVanityCB","POST");
}
function buyVanityCB(s, b)
{
   classes.Frame.serverLights(false);
   switch(s)
   {
      case 2:
      case 1:
         if(s == 1)
         {
            classes.GlobalData.updateInfo("p",b);
         }
         else if(s == 2)
         {
            classes.GlobalData.updateInfo("m",b);
         }
         _global.shopLicensesMC.installCartPlateNumber();
         break;
      case 0:
      case -1:
      case -2:
      case -3:
   }
}
function buyPlateAndVanity(acid, pid, pn, pt)
{
   legacyCall("executeCall \"buyplate\", \"acid=" + acid + "&pid=" + pid + "&pn=" + escape(pn) + "&pt=" + pt + "\"","buyPlateAndVanityCB","POST");
}
function buyPlateAndVanityCB(s, b)
{
   switch(s)
   {
      case 2:
      case 1:
         if(s == 1)
         {
            classes.GlobalData.updateInfo("p",b);
         }
         else if(s == 2)
         {
            classes.GlobalData.updateInfo("m",b);
         }
         break;
      case 0:
      case -1:
      case -2:
      case -3:
      case -4:
      case -5:
      case -6:
   }
}
function getSystemParts(acid, etid)
{
   classes.Frame.serverLights(true);
   legacyCall("executeCall \"getsystemparts\", \"acid=" + acid + "&etid=" + etid + "\"","getSystemPartsCB","POST");
}
function getSystemPartsCB(s, d)
{
   classes.Frame.serverLights(false);
   if(s == 1)
   {
      var _loc5_ = new XML();
      _loc5_.ignoreWhite = true;
      _loc5_.parseXML(d);
      _global.shopPartsMC.gotoAndPlay("swap");
      _global.shopPartsMC.buildSwapMenu(_loc5_);
   }
   else
   {
      _root.displayAlert("warning","Engine not Found","Sorry, the engine type you picked can\'t be loaded.");
   }
}
function systemSwap(acid, etid, aepids)
{
   classes.Frame.serverLights(true);
   legacyCall("executeCall \"systemswap\", \"acid=" + acid + "&etid=" + etid + "&aepids=" + aepids + "\"","systemSwapCB","POST");
}
function systemSwapCB(s)
{
   classes.Frame.serverLights(false);
   switch(s)
   {
      case 1:
         _global.shopPartsMC.gotoAndPlay("retrieve");
         _root.displayAlert("success","System Updated","Congratulations, you have successfully swapped your system.");
         break;
      case -1:
         _root.displayAlert("warning","Incomplete Parts","I\'m sorry, but you\'re missing parts for the system swap.");
         break;
      case -2:
         _root.displayAlert("warning","Incomplete Parts","I\'m sorry, but you\'re missing parts for the system swap.");
         break;
      case -3:
         _root.displayAlert("warning","Incomplete Parts","I\'m sorry, but you\'re missing parts for the system swap.");
         break;
      case -4:
         _root.displayAlert("warning","Incomplete Parts","I\'m sorry, but you\'re missing parts for the system swap.");
         break;
      case -5:
         _root.displayAlert("warning","Incomplete Parts","I\'m sorry, but you\'re missing parts for the system swap.");
         break;
      case -6:
         _root.displayAlert("warning","Incomplete Parts","I\'m sorry, but you\'re missing parts for the system swap.");
         break;
      case -7:
         break;
      case -8:
         _root.displayAlert("warning","Incomplete Parts","I\'m sorry, but you\'re missing parts for the system swap.");
         break;
      case -9:
         _root.displayAlert("warning","Incomplete Parts","I\'m sorry, but you\'re missing parts for the system swap.");
         break;
      case -10:
         _root.displayAlert("warning","Car not Available","I\'m sorry, but the car you selected is impounded.");
   }
}
function engineList()
{
   legacyCall("executeCall \"egue\"","engineListCB","GET");
}
function engineListCB(s, d)
{
   if(s == 1)
   {
   }
}
function engineGetAllParts(aeid)
{
   legacyCall("executeCall \"egep\", \"aeid=" + aeid + "\"","engineGetAllPartsCB","POST");
}
function engineGetAllPartsCB(d)
{
   _global.partXML = new XML();
   _global.partXML.ignoreWhite = true;
   _global.partXML.parseXML(d);
   _global.shopPartsMC.gotoAndPlay("showroom");
}
function engineBuyPart(epid, mid)
{
   legacyCall("executeCall \"ebep\", \"epid=" + epid + "&mid=" + mid + "\"","engineBuyPartCB","POST");
}
function engineBuyPartCB(d)
{
   var _loc3_ = new XML();
   _loc3_.ignoreWhite = true;
   _loc3_.parseXML(d);
   switch(Number(_loc3_.firstChild.attributes.s))
   {
      case 2:
      case 1:
         if(Number(_loc3_.firstChild.attributes.s) == 1)
         {
            classes.GlobalData.updateInfo("p",Number(_loc3_.firstChild.attributes.b));
         }
         else
         {
            classes.GlobalData.updateInfo("m",Number(_loc3_.firstChild.attributes.b));
         }
         _root.abc.contentMC.txtTitle = "Part is Purchased";
         _root.abc.contentMC.txtMsg = "Congratulations, the part is successfully purchased and placed in your garage.";
         _root.abc.removeButtons();
         _root.abc.addButton("OK");
         break;
      case 0:
         _root.displayAlert("warning","Purchase Error","Sorry, the purchase attempt failed.  Please try again later.");
         break;
      case -1:
         _root.displayAlert("warning","Purchase Error","Sorry, this part is only available to users with paid memberships.  Please see www.nitto1320.com for more information.");
         break;
      case -2:
         _root.displayAlert("warning","Purchase Error","This attempt failed because the part is not available for purchase with the chosen payment method.  Please use another form of payment.");
         break;
      case -3:
         _root.displayAlert("warning","Insufficient Funds","Sorry, you do not have enough in your balance to pay for this.  Try winning some races, or you could try buying a cheaper part.");
         break;
      case -4:
         _root.displayAlert("warning","Purchase Error","This part will not fit on the selected car.");
         break;
      case -5:
         _root.displayAlert("warning","Purchase Error","This part is not available for your location.");
   }
}
function engineSwapStart(aeid)
{
   legacyCall("executeCall \"esst\", \"aeid=" + aeid + "\"","engineSwapStartCB","POST");
}
function engineSwapStartCB(s, d)
{
   if(s == 1)
   {
      var _loc5_ = new XML();
      _loc5_.ignoreWhite = true;
      _loc5_.parseXML(d);
      _global.shopPartsMC.gotoAndPlay("swap");
      _global.shopPartsMC.buildSwapMenu(_loc5_);
   }
   else
   {
      _root.displayAlert("warning","Engine not Found","Sorry, the engine type you picked can\'t be loaded.");
   }
}
function engineSwapFinish(acid, aeid, aepids)
{
   legacyCall("executeCall \"esfi\", \"acid=" + acid + "&aeid=" + aeid + "&aepids=" + aepids + "\"","engineSwapFinishCB","POST");
}
function engineSwapFinishCB(s)
{
   switch(s)
   {
      case 1:
         _global.shopPartsMC.gotoAndPlay("retrieve");
         _root.displayAlert("success","Engine Swapped","Congratulations, you have successfully swapped your engine.");
         break;
      case 0:
         _root.displayAlert("warning","Engine Not Available","I\'m sorry, but we can\'t locate the engine you selected.");
         break;
      case -1:
         _root.displayAlert("warning","Car Not Available","I\'m sorry, but we can\'t locate the car you selected.");
         break;
      case -2:
         _root.displayAlert("warning","Engine Not Available","I\'m sorry, but we can\'t locate the engine you selected.");
         break;
      case -3:
         _root.displayAlert("warning","Parts Incompatibility","I\'m sorry, but we can\'t use the parts you selected.");
         break;
      case -4:
         _root.displayAlert("warning","Missing Parts","I\'m sorry, but there are missing parts for the engine swap.");
         break;
      case -5:
         _root.displayAlert("warning","Missing Parts","I\'m sorry, but there are missing parts for the engine swap.");
         break;
      case -6:
         _root.displayAlert("warning","Missing Parts","I\'m sorry, but there are missing parts for the engine swap.");
         break;
      case -7:
         _root.displayAlert("warning","Car not Available","I\'m sorry, but the car you selected to swap the engine for is impounded.");
   }
}
function getRepairParts(acid)
{
   legacyCall("executeCall \"getrepairparts\", \"acid=" + acid + "\"","getRepairPartsCB","POST");
}
function getRepairPartsCB(s, d)
{
   if(s == 1)
   {
      var _loc4_ = new XML();
      _loc4_.ignoreWhite = true;
      _loc4_.parseXML(d);
      repairPartMC.loadRepairShop(_loc4_);
   }
   else
   {
      _root.displayAlert("warning","Repair Error","Sorry, the repair attempt failed.  Please try again later.");
   }
}
function repairParts(acid, aepids, price)
{
   _global.repairPartsPrice = price;
   legacyCall("executeCall \"repairparts\", \"acid=" + acid + "&aepids=" + aepids + "\"","repairPartsCB","POST");
}
function repairPartsCB(s)
{
   switch(s)
   {
      case 1:
         _root.displayAlert("success","Part(s) Repaired","You have repaired the selected part(s).");
         classes.GlobalData.addFunds(- _global.repairPartsPrice);
         repairPartMC.gotoAndPlay("refresh");
         break;
      case 0:
         _root.displayAlert("warning","Repair Error","Sorry, the repair attempt failed.  Please try again later.");
         break;
      case -1:
         _root.displayAlert("warning","Repair Error","Sorry, you don\'t have enough balance to repair the parts.");
   }
   delete _global.repairPartsPrice;
}
function getEmailTotalNew()
{
   legacyCall("executeCall \"gettotalnewmail\"","getEmailTotalNewCB","GET");
}
function getEmailTotalNewCB(s, eNum)
{
   classes.GlobalData.updateInfo("im",eNum);
}
function getEmailList()
{
   legacyCall("executeCall \"getemaillist\"","getEmailListCB","GET");
}
function getEmailListCB(d)
{
   _global.inbox_xml = new XML();
   _global.inbox_xml.ignoreWhite = true;
   _global.inbox_xml.parseXML(d);
   classes.GlobalData.updateInfo("im","count");
   classes.Email.redrawInbox();
}
function getEmail(id)
{
   legacyCall("executeCall \"getemail\", \"eid=" + id + "\"","getEmailCB","POST");
}
function getEmailCB(d)
{
   var _loc2_ = new XML();
   _loc2_.ignoreWhite = true;
   _loc2_.parseXML(d);
   classes.Email.viewMail(_loc2_);
}
function markEmailRead(id)
{
   legacyCall("executeCall \"markemailread\", \"eid=" + id + "\"","","POST");
}
function deleteEmail(id)
{
   classes.Email.viewedEmailID = 0;
   legacyCall("executeCall \"deleteemail\", \"eid=" + id + "\"","deleteEmailCB","POST");
}
function deleteEmailCB(s, eid)
{
   if(s == 1)
   {
      var _loc4_ = 0;
      while(_loc4_ < _global.inbox_xml.firstChild.childNodes.length)
      {
         if(_global.inbox_xml.firstChild.childNodes[_loc4_].attributes.i == eid)
         {
            _global.inbox_xml.firstChild.childNodes[_loc4_].removeNode();
            getEmailTotalNew();
            break;
         }
         _loc4_ += 1;
      }
   }
}
function sendEmail(tu, s, b, id)
{
   var _loc5_ = new LoadVars();
   _loc5_.tu = tu;
   _loc5_.s = s;
   _loc5_.b = b;
   _loc5_.i = id;
   legacyCall("executeCall \"sendemail\", \"" + _loc5_.toString() + "\"","sendEmailCB","POST");
}
function sendEmailCB(s, id)
{
   switch(s)
   {
      case 1:
         _root["compose" + id].removeMovieClip();
         break;
      case 0:
         _root.displayAlert("warning","E-mail Can Not Be Sent","Please make sure your e-mail has a subject and message before sending.");
         break;
      case -1:
         _root.displayAlert("warning","Could Not Deliver E-mail","Sorry, this user is not accepting e-mails.");
         break;
      case -2:
         _root.displayAlert("warning","Could Not Deliver E-mail","Sorry, the user name you are trying to send to was not found.");
   }
}
function addRemark(remark, toID)
{
   var _loc3_ = new LoadVars();
   _loc3_.rmk = remark;
   _loc3_.tid = toID;
   legacyCall("executeCall \"addremark\", \"" + _loc3_.toString() + "\"","addRemarkCB","POST");
}
function addRemarkCB(s)
{
   switch(s)
   {
      case 1:
         dialogGiveRemark.contentMC.gotoAndPlay("success");
         break;
      case 0:
         viewer.remarkError("Sorry, this user was not found in our records.");
         break;
      case -1:
         viewer.remarkError("Sorry, this user is not your buddy.  You may only give remarks to your buddies.");
         break;
      case -2:
         viewer.remarkError("Sorry, there was a server error.  Please try again.");
   }
}
function deleteRemark(accountRemarkID)
{
   legacyCall("executeCall \"deleteremark\", \"arid=" + accountRemarkID + "\"","deleteRemarkCB","POST");
   var _loc3_ = _global.myRemarksXML.firstChild.childNodes.length;
   var _loc4_ = 0;
   while(_loc4_ < _loc3_)
   {
      if(_global.myRemarksXML.firstChild.childNodes[_loc4_].attributes.rid == accountRemarkID)
      {
         _global.myRemarksXML.firstChild.childNodes[_loc4_].removeNode();
      }
      _loc4_ += 1;
   }
}
function deleteRemarkCB(s, arid)
{
   if(s)
   {
      _root.main.sectionHolder.sectionClip.scrollerContent.remarkMC.drawAllRemark(_global.myRemarksXML,true);
   }
}
function getRemarks()
{
   classes.Frame.serverLights(true);
   legacyCall("executeCall \"getremarks\"","getRemarksCB","GET");
}
function getRemarksCB(d)
{
   classes.Frame.serverLights(false);
   classes.Lookup.runCallback("getRemarks","",d);
}
function getUserRemarks(tid)
{
   legacyCall("executeCall \"getuserremarks\", \"tid=" + tid + "\"","getUserRemarksCB","POST");
}
function getUserRemarksCB(d)
{
   classes.Viewer.viewRemarksXML = new XML();
   classes.Viewer.viewRemarksXML.ignoreWhite = true;
   classes.Viewer.viewRemarksXML.parseXML(d);
   _root.viewer.scrollerContent.remarkMC.drawAllRemark(classes.Viewer.viewRemarksXML,false);
}
function setRemarkNonDeletes(arids)
{
   legacyCall("executeCall \"setnondeletes\", \"arids=" + arids + "\"","setRemarkNonDeletesCB","POST");
}
function setRemarkNonDeletesCB(s)
{
   switch(s)
   {
      case 1:
         _root.getRemarks();
         break;
      case 0:
      case -1:
      case -2:
   }
}
function setRemarkDeletes(arids)
{
   legacyCall("executeCall \"setdeletes\", \"arids=" + arids + "\"","setRemarkDeletesCB","POST");
}
function setRemarkDeletesCB(s)
{
   if(s)
   {
      _root.getRemarks();
   }
}
function buddySetTop(baid)
{
   legacyCall("executeCall \"addastopbuddy\", \"baid=" + baid + "\"","","POST");
}
function buddyUnsetTop(baid)
{
   legacyCall("executeCall \"removeastopbuddy\", \"baid=" + baid + "\"","","POST");
}
function getLocations()
{
   legacyCall("executeCall \"getlocations\"","getLocationsCB","GET");
}
function getLocationsCB(d)
{
   _global.locationXML.parseXML(d);
}
function moveLocation(lid)
{
   _global.hMoveLoc = lid;
   legacyCall("executeCall \"movelocation\", \"lid=" + lid + "\"","moveLocationCB","POST");
}
function syncMoveLocationState(lid, money)
{
   if(_root.ensureHttpLoginXmlFromCache != undefined)
   {
      _root.ensureHttpLoginXmlFromCache();
   }
   if(_global.loginXML != undefined && _global.loginXML.firstChild != undefined && _global.loginXML.firstChild.firstChild != undefined)
   {
      _global.loginXML.firstChild.firstChild.attributes.lid = lid;
      if(money != undefined)
      {
         _global.loginXML.firstChild.firstChild.attributes.m = money;
      }
   }
   if(classes.GlobalData != undefined && classes.GlobalData.attr != undefined)
   {
      classes.GlobalData.attr.lid = lid;
      if(money != undefined)
      {
         classes.GlobalData.attr.m = money;
      }
   }
   if(_global.loginAttrCache != undefined)
   {
      _global.loginAttrCache.lid = lid;
      if(money != undefined)
      {
         _global.loginAttrCache.m = money;
      }
   }
   if(_global.httpHudAttrCache != undefined)
   {
      _global.httpHudAttrCache.lid = lid;
      if(money != undefined)
      {
         _global.httpHudAttrCache.m = money;
      }
   }
}
function finalizeMoveLocationRefresh()
{
   var _loc1_ = classes.Frame != undefined && classes.Frame._MC != undefined ? classes.Frame._MC : classes.Frame.__MC;
   if(_loc1_ != undefined && _loc1_.map != undefined)
   {
      _loc1_.resetMap();
      return undefined;
   }
   if(_loc1_ != undefined && _loc1_.sectionHolder != undefined && _loc1_.sectionHolder.sectionClip != undefined && _loc1_.sectionHolder.sectionClip.objectName == "sectionHome")
   {
      if(classes.SectionHome != undefined && classes.SectionHome.__MC != undefined && classes.SectionHome.__MC.updateUserValues != undefined)
      {
         classes.SectionHome.__MC.updateUserValues();
      }
      if(classes.HomeProfile != undefined && classes.HomeProfile._MC != undefined && classes.HomeProfile._MC.goProfilePage != undefined)
      {
         classes.HomeProfile._MC.goProfilePage(2);
      }
      return undefined;
   }
   if(_loc1_ != undefined)
   {
      _loc1_.goMainSection("home");
   }
}
function finalizeBuyCarRefresh()
{
   var _loc1_ = classes.Frame != undefined && classes.Frame._MC != undefined ? classes.Frame._MC : classes.Frame.__MC;
   if(_loc1_ == undefined)
   {
      return undefined;
   }
   _loc1_.goMainSection("home");
   if(classes.SectionHome != undefined && classes.SectionHome.__MC != undefined)
   {
      if(classes.SectionHome.__MC.updateUserValues != undefined)
      {
         classes.SectionHome.__MC.updateUserValues();
      }
      if(classes.SectionHome.__MC.goSection != undefined)
      {
         classes.SectionHome.__MC.goSection(1);
      }
      return undefined;
   }
   setTimeout(finalizeBuyCarRefresh,50);
}
function moveLocationCB(s, m)
{
   switch(s)
   {
      case 1:
         syncMoveLocationState(_global.hMoveLoc,m);
         classes.GlobalData.updateInfo("m",m);
         classes.GlobalData.updateInfo("lid",_global.hMoveLoc);
         classes.GlobalData.attr = getHttpLiveLoginAttrs();
         if(_global.garageXML != undefined && _global.garageXML.firstChild != undefined)
         {
            var _loc5_ = 0;
            while(_loc5_ < _global.garageXML.firstChild.childNodes.length)
            {
               _global.garageXML.firstChild.childNodes[_loc5_].attributes.lid = _global.hMoveLoc;
               _loc5_ += 1;
            }
         }
         finalizeMoveLocationRefresh();
         setTimeout(finalizeMoveLocationRefresh,50);
         setTimeout(finalizeMoveLocationRefresh,150);
         _global.afterGetCarsAction = "moveLocation";
         _root.getCars();
         break;
      case 0:
      case -1:
      case -2:
      case -3:
      case -4:
   }
   delete _global.hMoveLoc;
}
function changeHomeMachine()
{
   legacyCall("executeCall \"changehomemachine\"","changeHomeMachineCB","GET");
}
function changeHomeMachineCB(s)
{
   if(s)
   {
   }
}
function changeEmail(newEmail)
{
   legacyCall("executeCall \"changeemail\", \"e=" + escape(newEmail) + "\"","changeEmailCB","POST");
}
function changeEmailCB(s)
{
   switch(s)
   {
      case 1:
      case 0:
      case -1:
   }
}
function getUser(tid)
{
   classes.Control.getUserID = tid;
   legacyCall("executeCall \"getuser\", \"tid=" + tid + "\"","getUserCB","POST");
}
function getUserCB(d)
{
   var _loc2_ = new XML(d);
   classes.Lookup.addToUsersXML(_loc2_.firstChild.firstChild);
   _loc2_ = new XML(d);
   classes.Lookup.runCallback("getUser",_loc2_.firstChild.firstChild.attributes.i,d);
}
function getUserBuddies(tid)
{
   legacyCall("executeCall \"getbuddies\", \"tid=" + tid + "\"","getUserBuddiesCB","POST");
}
function getUserBuddiesCB(d)
{
   classes.Viewer.viewBuddiesXML = new XML();
   classes.Viewer.viewBuddiesXML.ignoreWhite = true;
   classes.Viewer.viewBuddiesXML.parseXML(d);
   viewer.drawBuddies(1);
}
function updateBgColor(bg)
{
   classes.GlobalData.updateInfo("bg",bg);
   legacyCall("executeCall \"updatebg\", \"bg=" + bg + "\"","updateBgColorCB","POST");
}
function updateBgColorCB(s)
{
}
function updateDefaultCar(acid)
{
   classes.GlobalData.setSelectedCar(acid);
   legacyCall("executeCall \"updatedefaultcar\", \"acid=" + acid + "\"","updateDefaultCarCB","POST");
}
function updateDefaultCarCB(s)
{
}
function syncBoughtCarStateFromXml(d)
{
   trace("syncBoughtCarStateFromXml begin");
   if(d == undefined || d == "")
   {
      trace("syncBoughtCarStateFromXml no data");
      return undefined;
   }
   var _loc4_ = new XML();
   _loc4_.ignoreWhite = true;
   _loc4_.parseXML(d);
   trace("syncBoughtCarStateFromXml parsed=" + (_loc4_.firstChild != undefined));
   if(_loc4_.firstChild == undefined)
   {
      return undefined;
   }
   if(_global.garageXML == undefined || _global.garageXML.firstChild == undefined)
   {
      _global.garageXML = new XML("<garage></garage>");
      _global.garageXML.ignoreWhite = true;
   }
   if(_global.garageXML.firstChild != undefined)
   {
      _global.garageXML.firstChild.appendChild(_loc4_.firstChild);
      trace("syncBoughtCarStateFromXml appended");
   }
   if(classes.GlobalData != undefined && classes.GlobalData.setSelectedCar != undefined && _loc4_.firstChild.attributes.i != undefined)
   {
      classes.GlobalData.setSelectedCar(_loc4_.firstChild.attributes.i);
      trace("syncBoughtCarStateFromXml selected=" + _loc4_.firstChild.attributes.i);
   }
   if(getHttpLiveLoginAttrs != undefined)
   {
      classes.GlobalData.attr = getHttpLiveLoginAttrs();
   }
   if(_root.refreshHttpHud != undefined)
   {
      setTimeout(_root.refreshHttpHud,0);
      setTimeout(_root.refreshHttpHud,125);
   }
}
function racerSearch(st, pn)
{
   if(pn)
   {
      pn = 1;
   }
   classes.Frame.serverLights(true);
   legacyCall("executeCall \"racersearch\", \"st=" + escape(st) + "&pn=" + pn + "\"","racerSearchCB","POST");
}
function racerSearchCB(s, d)
{
   classes.Frame.serverLights(false);
   classes.Lookup.runCallback("racerSearch","",d);
}
function getInfo()
{
   legacyCall("executeCall \"getinfo\"","getInfoCB","GET");
}
function getInfoCB(d)
{
   var _loc3_ = new XML();
   _loc3_.ignoreWhite = true;
   _loc3_.parseXML(d);
   _global.iniXML = _loc3_;
   _global.introData = new classes.IntroData();
   _global.introData.introXML = d;
   _global.introData.broadcastRead = classes.GlobalData.prefsObj.broadcastRead;
   _global.introData.timeDataReceived = new Date();
   _global.introData.testDriveCarExpired = classes.GlobalData.testDriveCarExpired;
   _global.introData.testDriveCarXML = classes.GlobalData.getTestDriveCarXML();
   var _loc4_ = classes.XMLParser.getXMLByID(d,"broadcast");
   if(_loc4_ != undefined && _loc4_.firstChild != undefined && _loc4_.firstChild.firstChild != undefined)
   {
      _global.introData.broadcastNum = Number(_loc4_.firstChild.firstChild.attributes.bid);
      _global.introData.broadcastMessage = String(_loc4_.firstChild.firstChild.attributes.m);
   }
   if(_loc3_.firstChild != undefined)
   {
      var _loc5_ = 0;
      while(_loc5_ < _loc3_.firstChild.childNodes.length)
      {
         if(_loc3_.firstChild.childNodes[_loc5_].nodeName == "locations")
         {
            _global.locationXML = new XML(_loc3_.firstChild.childNodes[_loc5_].toString());
            _global.locationXML.ignoreWhite = true;
         }
         else if(_loc3_.firstChild.childNodes[_loc5_].nodeName == "dyno")
         {
            _global.dynoXML = new XML(_loc3_.firstChild.childNodes[_loc5_].toString());
            _global.dynoXML.ignoreWhite = true;
         }
         _loc5_ += 1;
      }
   }
   classes.Control.loginFinished("web");
}
function getAvatar(tid, io, avatarType, noCache)
{
   if(Number(tid))
   {
      var _loc5_ = false;
      var _loc6_ = 0;
      while(_loc6_ < aryAvatar.length)
      {
         if(aryAvatar[_loc6_][0] == tid && aryAvatar[_loc6_][2] == avatarType)
         {
            _loc5_ = true;
            aryAvatar[_loc6_][1].push(io);
            if(noCache)
            {
               aryAvatar[_loc6_][3] = true;
            }
            break;
         }
         _loc6_ += 1;
      }
      if(_loc5_)
      {
         aryAvatar.push(new Array(tid,new Array(io),avatarType,noCache));
         if(isTimeoutSet)
         {
            isTimeoutSet = true;
            setTimeout(getAvatarTimer,150);
         }
      }
   }
}
function getAvatarCB(tid, avatarType, avatarAvailable)
{
   var _loc4_ = 0;
   while(_loc4_ < aryAvatar.length)
   {
      if(aryAvatar[_loc4_][0] == tid && aryAvatar[_loc4_][2] == avatarType)
      {
         var _loc5_ = 0;
         while(_loc5_ < aryAvatar[_loc4_][1].length)
         {
            if(avatarAvailable)
            {
               aryAvatar[_loc4_][1][_loc5_].showAvatar();
            }
            else
            {
               aryAvatar[_loc4_][1][_loc5_].showDefaultAvatar();
            }
            _loc5_ += 1;
         }
         aryAvatar.splice(_loc4_,1);
         break;
      }
      _loc4_ += 1;
   }
}
function getAvatarTimer()
{
   isTimeoutSet = false;
   var _loc5_ = "";
   var _loc2_ = "";
   var _loc4_ = "";
   var _loc3_ = "";
   var _loc1_ = 0;
   while(_loc1_ < aryAvatar.length)
   {
      if(aryAvatar[_loc1_][2] == "avatars")
      {
         if(aryAvatar[_loc1_][3])
         {
            _loc4_ += aryAvatar[_loc1_][0] + ",";
         }
         else
         {
            _loc5_ += aryAvatar[_loc1_][0] + ",";
         }
      }
      else if(aryAvatar[_loc1_][2] == "teamavatars")
      {
         if(aryAvatar[_loc1_][3])
         {
            _loc3_ += aryAvatar[_loc1_][0] + ",";
         }
         else
         {
            _loc2_ += aryAvatar[_loc1_][0] + ",";
         }
      }
      _loc1_ += 1;
   }
   if(_loc5_)
   {
      _loc5_ = _loc5_.substr(0,_loc5_.length - 1);
      legacyCall("getAvatar \"" + _loc5_ + "\", \"avatars\"","","POST");
   }
   if(_loc2_)
   {
      _loc2_ = _loc2_.substr(0,_loc2_.length - 1);
      legacyCall("getAvatar \"" + _loc2_ + "\", \"teamavatars\"","","POST");
   }
   if(_loc4_)
   {
      _loc4_ = _loc4_.substr(0,_loc4_.length - 1);
      legacyCall("getAvatar \"" + _loc4_ + "\", \"avatars\", 1","","POST");
   }
   if(_loc3_)
   {
      _loc3_ = _loc3_.substr(0,_loc3_.length - 1);
      legacyCall("getAvatar \"" + _loc3_ + "\", \"teamavatars\", 1","","POST");
   }
}
function avatarUploadRequest(l)
{
   legacyCall("executeCall \"uploadrequest\", \"" + l.toString() + "\"","avatarUploadRequestCB","POST");
}
function avatarUploadRequestCB(s)
{
   if(aub)
   {
      aub.uploadRequestCB(s);
   }
}
function normalizeUserGraphicBrowseExt(name)
{
   var _loc2_ = String(name).toLowerCase();
   if(_loc2_.lastIndexOf(".") < 0)
   {
      return "";
   }
   _loc2_ = _loc2_.substr(_loc2_.lastIndexOf(".") + 1);
   if(_loc2_ == "jpeg")
   {
      _loc2_ = "jpg";
   }
   if(_loc2_ == "jpg" || _loc2_ == "png" || _loc2_ == "gif")
   {
      return _loc2_;
   }
   return "";
}
function getUserGraphicPreviewPath(slotKey, ext)
{
   var _loc4_ = undefined;
   if(_global.loginXML != undefined && _global.loginXML.firstChild != undefined && _global.loginXML.firstChild.firstChild != undefined && _global.loginXML.firstChild.firstChild.attributes.i != undefined && _global.loginXML.firstChild.firstChild.attributes.i != "")
   {
      _loc4_ = _global.loginXML.firstChild.firstChild.attributes.i;
   }
   else if(_global.loginAttrCache != undefined && _global.loginAttrCache.i != undefined && _global.loginAttrCache.i != "")
   {
      _loc4_ = _global.loginAttrCache.i;
   }
   else if(classes.GlobalData != undefined && classes.GlobalData.attr != undefined && classes.GlobalData.attr.i != undefined && classes.GlobalData.attr.i != "")
   {
      _loc4_ = classes.GlobalData.attr.i;
   }
   if(_loc4_ == undefined || _loc4_ == "")
   {
      return undefined;
   }
   return _global.mainURL + "data/user_graphics_uploads/" + escape(String(_loc4_)) + "/" + escape(String(slotKey)) + "." + escape(String(ext)) + "?v=" + new Date().getTime();
}
function fileBrowse(slotKey)
{
   var _loc3_ = String(slotKey);
   var _loc4_ = new Array();
   var _loc5_ = new Object();
   _loc5_.description = "PNG (*.png)";
   _loc5_.extension = "*.png";
   _loc4_.push(_loc5_);
   var _loc6_ = new Object();
   _loc6_.description = "JPEG (*.jpg, *.jpeg)";
   _loc6_.extension = "*.jpg;*.jpeg";
   _loc4_.push(_loc6_);
   var _loc7_ = new Object();
   _loc7_.description = "GIF (*.gif)";
   _loc7_.extension = "*.gif";
   _loc4_.push(_loc7_);
   var _loc8_ = new Object();
   _loc8_.description = "All Files (*.*)";
   _loc8_.extension = "*.*";
   _loc4_.push(_loc8_);
   var _loc9_ = new flash.net.FileReference();
   var _loc10_ = new Object();
   _loc10_.slotKey = _loc3_;
   _loc10_.onSelect = function(file)
   {
      var _loc5_ = normalizeUserGraphicBrowseExt(file.name);
      if(_loc5_ == "")
      {
         _root.displayAlert("warning","Invalid Graphic","Please choose a JPG, PNG, or GIF image.");
         return undefined;
      }
      this.pendingToken = "upload:" + this.slotKey;
      this.pendingPreviewPath = getUserGraphicPreviewPath(this.slotKey,_loc5_);
      this.pendingSize = Number(file.size);
      this.pendingName = String(file.name);
      if(!file.upload(_global.mainURL + "UserGraphicUpload.aspx?slot=" + escape(this.slotKey) + "&ext=" + escape(_loc5_)))
      {
         _root.displayAlert("warning","Upload Error","The selected image could not be uploaded.");
      }
   };
   _loc10_.onComplete = function(file)
   {
      classes.Lookup.runCallback("fileBrowse",this.slotKey,{path:this.pendingToken,previewPath:this.pendingPreviewPath,filesize:this.pendingSize,name:this.pendingName});
   };
   _loc10_.onHTTPError = function(file, httpError)
   {
      switch(Number(httpError))
      {
         case 406:
            _root.displayAlert("warning","Upload Error","The selected image is too large.");
            break;
         case 408:
            _root.displayAlert("warning","Invalid Graphic","Please choose a JPG, PNG, or GIF image.");
            break;
         default:
            _root.displayAlert("warning","Upload Error","The selected image could not be uploaded.");
      }
   };
   _loc10_.onIOError = function(file)
   {
      _root.displayAlert("warning","Upload Error","The selected image could not be uploaded.");
   };
   _loc10_.onSecurityError = function(file, errorString)
   {
      _root.displayAlert("warning","Upload Error","The selected image could not be uploaded.");
   };
   _loc9_.addListener(_loc10_);
   _global.fileBrowseRef = _loc9_;
   _global.fileBrowseListener = _loc10_;
   _loc9_.browse(_loc4_);
}
function uggGetPartID(catID)
{
   var _loc3_ = 0;
   if(_global.partXML == undefined || _global.partXML.firstChild == undefined)
   {
      return 0;
   }
   while(_loc3_ < _global.partXML.firstChild.childNodes.length)
   {
      if(Number(_global.partXML.firstChild.childNodes[_loc3_].attributes.pi) == catID)
      {
         return Number(_global.partXML.firstChild.childNodes[_loc3_].attributes.i);
      }
      _loc3_ += 1;
   }
   return 0;
}
function uggUpload(acid, pathHood, pathSide, pathFront, pathBack)
{
   _global.uggUploadObj = new Object();
   _global.uggUploadObj.selectedCar = Number(acid);
   var _loc7_ = new LoadVars();
   _loc7_.acid = acid;
   if(pathHood != undefined && pathHood.length && pathHood != "undefined")
   {
      _loc7_.h = pathHood;
   }
   if(pathSide != undefined && pathSide.length && pathSide != "undefined")
   {
      _loc7_.s = pathSide;
   }
   if(pathFront != undefined && pathFront.length && pathFront != "undefined")
   {
      _loc7_.f = pathFront;
   }
   if(pathBack != undefined && pathBack.length && pathBack != "undefined")
   {
      _loc7_.b = pathBack;
   }
   legacyCall("executeCall \"uggupload\", \"" + _loc7_.toString() + "\"","uggUploadCB","POST");
}
function uggUploadCB(s, d)
{
   trace("uggUploadCB: " + s + ", " + d);
   _global.uggUploadObj.uggInstallArr = new Array();
   if(Number(s) == 1 && d != undefined && d.length)
   {
      var _loc5_ = new XML();
      _loc5_.ignoreWhite = true;
      _loc5_.parseXML(d);
      var _loc6_ = undefined;
      if(_loc5_.firstChild != undefined)
      {
         if(_loc5_.firstChild.attributes.h)
         {
            _loc6_ = uggGetPartID(160);
            if(_loc6_)
            {
               _global.uggUploadObj.uggInstallArr.push({label:"Hood",query:"acid=" + _global.uggUploadObj.selectedCar + "&pid=" + _loc6_ + "&did=" + _loc5_.firstChild.attributes.h + "&fx=" + (_loc5_.firstChild.attributes.hx == undefined || _loc5_.firstChild.attributes.hx == "" ? "png" : _loc5_.firstChild.attributes.hx) + "&pt=p&pvid=&c="});
            }
         }
         if(_loc5_.firstChild.attributes.s)
         {
            _loc6_ = uggGetPartID(161);
            if(_loc6_)
            {
               _global.uggUploadObj.uggInstallArr.push({label:"Side",query:"acid=" + _global.uggUploadObj.selectedCar + "&pid=" + _loc6_ + "&did=" + _loc5_.firstChild.attributes.s + "&fx=" + (_loc5_.firstChild.attributes.sx == undefined || _loc5_.firstChild.attributes.sx == "" ? "png" : _loc5_.firstChild.attributes.sx) + "&pt=p&pvid=&c="});
            }
         }
         if(_loc5_.firstChild.attributes.f)
         {
            _loc6_ = uggGetPartID(162);
            if(_loc6_)
            {
               _global.uggUploadObj.uggInstallArr.push({label:"Front",query:"acid=" + _global.uggUploadObj.selectedCar + "&pid=" + _loc6_ + "&did=" + _loc5_.firstChild.attributes.f + "&fx=" + (_loc5_.firstChild.attributes.fx == undefined || _loc5_.firstChild.attributes.fx == "" ? "png" : _loc5_.firstChild.attributes.fx) + "&pt=p&pvid=&c="});
            }
         }
         if(_loc5_.firstChild.attributes.b)
         {
            _loc6_ = uggGetPartID(163);
            if(_loc6_)
            {
               _global.uggUploadObj.uggInstallArr.push({label:"Back",query:"acid=" + _global.uggUploadObj.selectedCar + "&pid=" + _loc6_ + "&did=" + _loc5_.firstChild.attributes.b + "&fx=" + (_loc5_.firstChild.attributes.bx == undefined || _loc5_.firstChild.attributes.bx == "" ? "png" : _loc5_.firstChild.attributes.bx) + "&pt=p&pvid=&c="});
            }
         }
      }
      if(_global.uggUploadObj.uggInstallArr.length > 0)
      {
         uggBuyCycleCB();
         return undefined;
      }
   }
   _root.abc.contentMC.gotoAndStop("done");
   _root.abc.contentMC.msg = "Sorry, the graphics process failed.";
}
function uggBuyCycleCB(d1, d2)
{
   _root.abc.contentMC.gotoAndStop("installing");
   trace("uggBuyCycleCB...");
   trace(d1);
   trace(d2);
   if(d1 != undefined && d1.length)
   {
      var _loc6_ = new XML();
      _loc6_.ignoreWhite = true;
      _loc6_.parseXML(d1);
      if(_loc6_.firstChild == undefined || Number(_loc6_.firstChild.attributes.s) != 1)
      {
         _root.abc.contentMC.gotoAndStop("done");
         _root.abc.contentMC.msg = "Sorry, the graphics process failed.";
         return undefined;
      }
      var _loc7_ = Number(_loc6_.firstChild.attributes.b);
      if(_global.uggUploadObj.newBal == undefined || _loc7_ <= _global.uggUploadObj.newBal)
      {
         _global.uggUploadObj.newBal = _loc7_;
      }
   }
   if(_global.uggUploadObj.uggInstallArr.length)
   {
      var _loc8_ = _global.uggUploadObj.uggInstallArr.shift();
      trace("cycleBuyUgg Installing " + _loc8_.label);
      legacyCall("executeCall \"buypartugg\", \"" + _loc8_.query + "\"","uggBuyCycleCB","POST");
   }
   else
   {
      classes.Lookup.addCallback("getOneCar",this,uggUpdateCarCB,String(_global.uggUploadObj.selectedCar));
      _root.getOneCar(_global.uggUploadObj.selectedCar);
      if(_global.uggUploadObj.newBal != undefined)
      {
         if(_global.loginAttrCache != undefined)
         {
            _global.loginAttrCache.p = String(_global.uggUploadObj.newBal);
            setHttpHudAttrCache(_global.loginAttrCache);
         }
         if(_global.loginXML != undefined && _global.loginXML.firstChild != undefined && _global.loginXML.firstChild.firstChild != undefined)
         {
            _global.loginXML.firstChild.firstChild.attributes.p = String(_global.uggUploadObj.newBal);
         }
         if(classes.GlobalData != undefined && classes.GlobalData.attr != undefined)
         {
            classes.GlobalData.attr.p = String(_global.uggUploadObj.newBal);
         }
         classes.GlobalData.updateInfo("p",String(_global.uggUploadObj.newBal));
         if(_root.refreshHttpHud != undefined)
         {
            refreshHttpHud();
         }
         delete _global.uggUploadObj.newBal;
      }
      delete _global.uggUploadObj.uggInstallArr;
      delete _global.uggUploadObj;
   }
}
function uggUpdateCarCB(carXML)
{
   trace("uggUpdateCarCB...");
   trace(carXML);
   classes.GlobalData.replaceCarNode(carXML.toString());
   if(_global.shopPartsMC != undefined)
   {
      _global.shopPartsMC.cloneGarageCar();
   }
   if(_global.shopUGGGroup != undefined)
   {
      _global.shopUGGGroup.init();
   }
   if(_global.shopPartsMC != undefined && _global.shopPartsMC.initUGGPurchase != undefined)
   {
      _global.shopPartsMC.initUGGPurchase();
   }
   _root.abc.contentMC.gotoAndStop("done");
   _root.abc.contentMC.msg = "Graphics purchase and installation complete!  " + _root.abc.uggCost + " points have been deducted from your account.";
}
function downloadUgg(finalLocalPath, requestingCarMC)
{
   trace("downloadUgg: " + finalLocalPath + ", " + requestingCarMC);
   var _loc4_ = String(finalLocalPath).split("/");
   var _loc5_ = _loc4_.pop();
   var _loc6_ = undefined;
   var _loc7_ = undefined;
   var _loc8_ = undefined;
   if(_loc5_.length)
   {
      if(!_global.downloadUggArray)
      {
         _global.downloadUggArray = new Array();
      }
      _loc7_ = 0;
      while(_loc7_ < _global.downloadUggArray.length)
      {
         if(_global.downloadUggArray[_loc7_][0] == _loc5_)
         {
            _loc6_ = true;
            break;
         }
         _loc7_ += 1;
      }
      _loc8_ = new Array(_loc5_,requestingCarMC);
      _global.downloadUggArray.push(_loc8_);
      if(!_loc6_)
      {
         legacyCall("executeCall \"downloadugg\", \"f=" + escape(_loc5_) + "\"","downloadUggCB","POST");
      }
   }
}
function downloadUggCB(filename, isAvailable, resolvedPath)
{
   trace("downloadUggCB: " + filename + ", " + isAvailable + ", " + resolvedPath);
   if(_global.downloadUggArray == undefined)
   {
      return undefined;
   }
   var _loc5_ = filename.split("_")[0];
   var _loc6_ = 0;
   while(_loc6_ < _global.downloadUggArray.length)
   {
      if(_global.downloadUggArray[_loc6_][0] == filename)
      {
         if(isAvailable && resolvedPath != undefined && resolvedPath.length && _global.downloadUggArray[_loc6_][1] != undefined && _global.downloadUggArray[_loc6_][1].uggWaitArr != undefined)
         {
            var _loc7_ = 0;
            while(_loc7_ < _global.downloadUggArray[_loc6_][1].uggWaitArr.length)
            {
               if(_global.downloadUggArray[_loc6_][1].uggWaitArr[_loc7_].decalObj != undefined)
               {
                  var _loc8_ = String(_global.downloadUggArray[_loc6_][1].uggWaitArr[_loc7_].decalObj.path).split("/").pop();
                  if(_loc8_ == filename)
                  {
                     _global.downloadUggArray[_loc6_][1].uggWaitArr[_loc7_].decalObj.path = resolvedPath;
                  }
               }
               _loc7_ += 1;
            }
         }
         _global.downloadUggArray[_loc6_][1].uggOnRetrieve(_loc5_,isAvailable);
         _global.downloadUggArray.splice(_loc6_,1);
         _loc6_ -= 1;
      }
      _loc6_ += 1;
   }
}
function getCars()
{
   classes.Frame.serverLights(true);
   legacyCall("executeCall \"getallcars\"","getCarsCB","GET");
}
function getCarsCB(stat, d)
{
   classes.Frame.serverLights(false);
   if(d != undefined && d.length > 0)
   {
      _global.garageXML = new XML(d);
   }
   else
   {
      _global.garageXML = new XML("<garage></garage>");
   }
   classes.Control.loginFinished("cars");
   if(_root.refreshHttpHud != undefined)
   {
      setTimeout(_root.refreshHttpHud,0);
      setTimeout(_root.refreshHttpHud,125);
   }
   switch(stat)
   {
      case 1:
      case 0:
      case -1:
   }
   if(classes.Control.loginObj.completed)
   {
      classes.Frame._MC.onLoginSuccess();
   }
   if(_global.afterGetCarsAction != undefined && classes.Control.loginObj.completed)
   {
      var _loc5_ = null;
      if((_loc5_ = _global.afterGetCarsAction) === "moveLocation")
      {
         finalizeMoveLocationRefresh();
         setTimeout(finalizeMoveLocationRefresh,50);
         setTimeout(finalizeMoveLocationRefresh,150);
      }
      delete _global.afterGetCarsAction;
   }
}
function getCarCategories()
{
   legacyCall("executeCall \"getcarcategories\"","getCarCategoriesCB","GET");
}
function getCarCategoriesCB(d)
{
   _global.dealerXML = new XML(d);
   viewShowroom();
}
function viewShowroom()
{
   legacyCall("executeCall \"viewshowroom\"","viewShowroomCB","GET");
}
function viewShowroomCB(d)
{
   _global.dealerCarsXML = new XML(d);
   if(_root.main != undefined && _root.main.sectionHolder != undefined && _root.main.sectionHolder.sectionClip != undefined && _root.main.sectionHolder.sectionClip.objectName == "sectionDealer")
   {
      _root.main.sectionHolder.sectionClip.gotoAndPlay("refresh");
   }
}
function getOtherUserCars(i)
{
   legacyCall("executeCall \"getallotherusercars\", \"tid=" + i + "\"","getOtherUserCarsCB","POST");
}
function getOtherUserCarsCB(stat, d)
{
   switch(stat)
   {
      case 1:
         var _loc3_ = new XML(d);
         var _loc4_ = _loc3_.firstChild.attributes.i;
         classes.Lookup.runCallback("getOtherUserCars",String(_loc4_),_loc3_);
         break;
      case 0:
      case -1:
   }
}
function buyCar(cid, pt, c)
{
   var _loc4_ = new LoadVars();
   _loc4_.cid = cid;
   _loc4_.pt = pt;
   _loc4_.c = c;
   legacyCall("executeCall \"buycar\", \"" + _loc4_.toString() + "\"","buyCarCB","POST");
}
function buyCarCB(stat, m, d)
{
   stat = Number(stat);
   if(isNaN(stat))
   {
      stat = 0;
   }
   trace("buyCarCB stat=" + stat + " balance=" + m);
   if(stat <= 0)
   {
      if(_root.abc != undefined)
      {
         if(_root.abc.thumb != undefined && _root.abc.thumb.dispose != undefined)
         {
            _root.abc.thumb.dispose();
         }
         _root.abc.closeMe();
      }
   }
   switch(stat)
   {
      case 1:
      case 2:
         var _loc6_ = undefined;
         if(stat == 1)
         {
            classes.GlobalData.updateInfo("p",String(m));
         }
         else if(stat == 2)
         {
            classes.GlobalData.updateInfo("m",String(m));
         }
         if(_root.ensureHttpLoginXmlFromCache != undefined)
         {
            _root.ensureHttpLoginXmlFromCache();
         }
         if(_global.loginXML != undefined && _global.loginXML.firstChild != undefined && _global.loginXML.firstChild.firstChild != undefined)
         {
            _global.loginXML.firstChild.firstChild.attributes[stat == 1 ? "p" : "m"] = String(m);
         }
         trace("buyCarCB success -> switching modal");
         if(_root.abc != undefined && _root.abc.contentMC != undefined)
         {
            _root.abc.removeButtons();
            trace("buyCarCB success -> removed buttons");
            _root.abc.contentMC.gotoAndStop("success");
            trace("buyCarCB success -> goto success");
            _root.abc.addButton("OK");
            trace("buyCarCB success -> added ok button");
            _loc6_ = new Object();
            _loc6_.onRelease = function(theButton, keepBoxOpen)
            {
               if(theButton.btnLabel.text === "OK")
               {
                  if(_root.abc != undefined && _root.abc.thumb != undefined && _root.abc.thumb.dispose != undefined)
                  {
                     _root.abc.thumb.dispose();
                  }
               }
               if(!keepBoxOpen && theButton._parent != undefined && theButton._parent._parent != undefined && theButton._parent._parent.closeMe != undefined)
               {
                  theButton._parent._parent.closeMe();
               }
            };
            _root.abc.addListener(_loc6_);
         }
         setTimeout(syncBoughtCarStateFromXml,0,d);
         break;
      case 0:
         displayAlert("warning","Invalid Vehicle","Sorry, the vehicle is not available for purchase.");
         break;
      case -1:
         displayAlert("warning","Access Denied","Sorry, the vehicle you are purchasing is for member only.");
         break;
      case -2:
         displayAlert("warning","Unrecognized Payment","Sorry, your payment method is not accepted.");
         break;
      case -3:
         displayAlert("warning","Account Inaccessible","Sorry, your account cannot be access at this time. Please try again later.");
         break;
      case -4:
         displayAlert("warning","Insufficient Balance","Sorry, you don\'t have enough balance to purchase this vehicle.");
         break;
      case -5:
         displayAlert("warning","Not Enough Space","Sorry, but your parking lot is full. You can sell a car or move to a better neighborhood to make space.");
         break;
      case -6:
         displayAlert("warning","Invalid Location","Sorry, but you need to move to a better neighborhood to purchase this car.");
   }
}
function getCarPrice(acid)
{
   legacyCall("executeCall \"getcarprice\", \"acid=" + acid + "\"","getCarPriceCB","POST");
}
function getCarPriceCB(s, p)
{
   if(s == 1)
   {
      _global.myGarageMC.carXML.firstChild.attributes.vw = p;
      classes.Control.dialogContainer("dialogSellCarContent",_global.sellCarObj.tObj);
   }
}
function sellCar(acid)
{
   legacyCall("executeCall \"sellcar\", \"acid=" + acid + "\"","sellCarCB","POST");
}
function sellCarCB(s, b)
{
   var _loc3_ = {s:s,b:b};
   classes.Lookup.runCallback("sellCar","",_loc3_);
}
function getAllImCars()
{
   classes.Frame.serverLights(true);
   legacyCall("executeCall \"getallimcars\"","getAllImCarsCB","GET");
}
function getAllImCarsCB(s, d)
{
   classes.Frame.serverLights(false);
   if(s == 1 || s == -1)
   {
      classes.Lookup.runCallback("getAllImCars","",d);
   }
   else
   {
      displayAlert("warning","Problem Encountered","Sorry, there was a problem finding your impounded cars. Please try again later.");
      classes.Lookup.clearCallback("getAllImCars","");
   }
}
function getCarOutOfImpound(acid)
{
   _global.retrieveCarObj = new Object();
   _global.retrieveCarObj.id = acid;
   legacyCall("executeCall \"getoutofimpound\", \"acid=" + acid + "\"","getCarOutOfImpoundCB","POST");
}
function getCarOutOfImpoundCB(s, b)
{
   classes.SectionImpound._MC.infoBar.btnRelease.enabled = true;
   switch(s)
   {
      case 1:
         classes.GlobalData.updateInfo("m",b);
         classes.GlobalData.updateCarAttr(_global.retrieveCarObj.id,"ii",0);
         classes.Frame._MC.goMainSection("impound");
         classes.Control.dialogAlert("Success","You have successfully retrieved this car from impound. It is now back in your garage.");
         _root.abc.contentMC.alertIconMC.gotoAndStop("success");
         break;
      case 0:
         classes.Control.dialogAlert("Problem Encountered","Sorry, there was a problem releasing your impounded car. Please try again later.");
         break;
      case -1:
         classes.Frame._MC.goMainSection("impound");
         classes.Control.dialogAlert("Problem Encountered","We could not find this car in the impound.");
         break;
      case -2:
         classes.Control.dialogAlert("Not Enough Funds","Sorry, you do not have enough funds to release your car. You can sell the car or try again later.");
         break;
      case -3:
         classes.Control.dialogAlert("No Garage Space Available","Sorry, you do not have any available space in your garage to accommodate this vehicle. To make garage space available, you need to either move your home to a nicer area, or sell some cars.");
   }
}
function getOneCar(acid)
{
   legacyCall("executeCall \"getonecar\", \"acid=" + acid + "\"","getOneCarCB","POST");
}
function getOneCarCB(s, d)
{
   if(s == 1)
   {
      var _loc3_ = new XML();
      _loc3_.ignoreWhite = true;
      if(d != undefined && d.length && d.substr(0,2) == "<c")
      {
         _loc3_.parseXML("<cars>" + d + "</cars>");
      }
      else
      {
         _loc3_.parseXML(d);
      }
      if(_loc3_.firstChild != undefined)
      {
         var _loc4_ = undefined;
         if(_loc3_.firstChild.nodeName == "c")
         {
            _loc4_ = _loc3_.firstChild.attributes.i;
            var _loc5_ = new XML();
            _loc5_.ignoreWhite = true;
            _loc5_.parseXML("<cars>" + d + "</cars>");
            _loc3_ = _loc5_;
         }
         else if(_loc3_.firstChild.firstChild != undefined)
         {
            _loc4_ = _loc3_.firstChild.firstChild.attributes.i;
         }
         if(_loc4_ != undefined && _loc4_ != "")
         {
            classes.Lookup.runCallback("getOneCar",String(_loc4_),_loc3_);
         }
      }
   }
}
function teamInfo(tids)
{
   legacyCall("executeCall \"teaminfo\", \"tids=" + escape(tids) + "\"","teamInfoCB","POST");
}
function teamInfoCB(d)
{
   classes.Lookup.runCallback("teamInfo","",d);
}
function teamTrans(tid)
{
   if(classes.Control.serverAvail())
   {
      legacyCall("executeCall \"teamtrans\", \"tid=" + tid + "\"","teamTransCB","POST");
   }
}
function teamTransCB(s, d)
{
   classes.Control.serverUnlock();
   if(s == 1)
   {
      classes.Lookup.runCallback("teamTrans","sectionTeamHQ",d);
   }
}
function teamSearch(st, pn)
{
   if(pn)
   {
      pn = 1;
   }
   classes.Frame.serverLights(true);
   legacyCall("executeCall \"teamsearch\", \"st=" + escape(st) + "&pn=" + pn + "\"","teamSearchCB","POST");
}
function teamSearchCB(s, d)
{
   classes.Frame.serverLights(false);
   classes.Lookup.runCallback("teamSearch","",d);
}
function teamUpdateLeaderComments(lc)
{
   _global.newLeaderComments = lc;
   legacyCall("executeCall \"updateleadercomments\", \"lc=" + lc + "\"","teamUpdateLeaderCommentsCB","POST");
}
function teamUpdateLeaderCommentsCB(s)
{
   if(s == 1)
   {
   }
   classes.Lookup.runCallback("teamUpdateLeaderComments","",s);
}
function teamUpdateTeamReq(rt, v)
{
   legacyCall("executeCall \"updateteamreq\", \"rt=" + rt + "&v=" + v + "\"","teamUpdateTeamReqCB","POST");
}
function teamUpdateTeamReqCB(s)
{
   if(s == 1)
   {
   }
}
function teamGetInfo(tid)
{
   legacyCall("executeCall \"getteaminfo\", \"tid=" + tid + "\"","teamGetInfoCB","POST");
}
function teamGetInfoCB(s, d)
{
   if(s == 1)
   {
      classes.Lookup.runCallback("teamGetInfo","",d);
   }
}
function teamGetAllApps(tid)
{
   if(classes.Control.serverAvail())
   {
      legacyCall("executeCall \"getallteamapps\", \"tid=" + tid + "\"","teamGetAllAppsCB","POST");
   }
}
function teamGetAllAppsCB(s, d)
{
   classes.Control.serverUnlock();
   if(s == 1)
   {
      classes.Lookup.runCallback("teamGetAllApps","sectionTeamHQ",d);
   }
}
function teamGetMyApps()
{
   classes.Frame.serverLights(true);
   legacyCall("executeCall \"getallmyapps\"","teamGetMyAppsCB","GET");
}
function teamGetMyAppsCB(s, d)
{
   classes.Frame.serverLights(false);
   if(s == 1)
   {
   }
   classes.Lookup.runCallback("teamGetMyApps","",d);
}
function teamDeleteApp(tid)
{
   legacyCall("executeCall \"deleteapp\", \"tid=" + tid + "\"","teamDeleteAppCB","POST");
}
function teamDeleteAppCB(s)
{
   if(s == 1)
   {
   }
}
function teamUpdateApp(aaid, r)
{
   classes.Frame.serverLights(true);
   legacyCall("executeCall \"updateteamapp\", \"aaid=" + aaid + "&r=" + r + "\"","teamUpdateAppCB","POST");
}
function teamUpdateAppCB(s)
{
   classes.Frame.serverLights(false);
   switch(s)
   {
      case 1:
      case 0:
      case -1:
      case -2:
   }
   classes.Lookup.runCallback("teamUpdateApp","",s);
}
function teamAddApp(tid, c)
{
   legacyCall("executeCall \"addteamapp\", \"tid=" + tid + "&c=" + escape(c) + "\"","teamAddAppCB","POST");
}
function teamAddAppCB(s)
{
   classes.Lookup.runCallback("teamAddApp","",s);
   switch(s)
   {
      case 1:
      case 0:
      case -1:
      case -2:
      case -3:
      case -4:
      case -5:
      case -6:
   }
}
function teamUpdateBgColor(bg)
{
   _global.teamXML.firstChild.firstChild.attributes.bg = bg;
   var _loc3_ = Number(_global.teamXML.firstChild.firstChild.attributes.i);
   if(_loc3_)
   {
      legacyCall("executeCall \"setteamcolor\", \"tid=" + _loc3_ + "&bg=" + bg + "\"","teamUpdateBgColorCB","POST");
   }
}
function teamUpdateBgColorCB(s)
{
}
function raceGetTwoRacersCars(r1acid, r2acid)
{
   if(r2acid == undefined || r2acid == "")
   {
      r2acid = 0;
   }
   var _loc4_ = classes.Lookup.getRaceCarNode(r1acid);
   var _loc5_ = classes.Lookup.getRaceCarNode(r2acid);
   var _loc6_ = _loc4_ != undefined ? _loc4_.toString() : "";
   var _loc7_ = _loc5_ != undefined ? _loc5_.toString() : "";
   var _loc8_ = undefined;
   if(_loc6_ && (!r2acid || _loc7_))
   {
      _loc8_ = "<n2>";
      _loc8_ += _loc6_;
      if(_loc7_)
      {
         _loc8_ += _loc7_;
      }
      _loc8_ += "</n2>";
      _root.raceGetTwoRacersCarsCB(1,_loc8_);
      return undefined;
   }
   if(r1acid)
   {
      legacyCall("executeCall \"gettworacerscars\", \"r1acid=" + r1acid + "&r2acid=" + r2acid + "\"","raceGetTwoRacersCarsCB","POST");
      return undefined;
   }
   _root.raceGetTwoRacersCarsCB(0,"");
}
function raceGetTwoRacersCarsCB(s, d)
{
   if(s == 1)
   {
      var _loc3_ = new XML();
      _loc3_.ignoreWhite = true;
      _loc3_.parseXML(d);
      var _loc4_ = 0;
      while(_loc3_.firstChild != undefined && _loc3_.firstChild.firstChild != undefined && _loc4_ < _loc3_.firstChild.firstChild.childNodes.length)
      {
         _loc3_.firstChild.firstChild.childNodes[_loc4_].attributes["in"] = 1;
         _loc4_ += 1;
      }
      _loc4_ = 0;
      while(_loc3_.firstChild != undefined && _loc3_.firstChild.childNodes[1] != undefined && _loc4_ < _loc3_.firstChild.childNodes[1].childNodes.length)
      {
         _loc3_.firstChild.childNodes[1].childNodes[_loc4_].attributes["in"] = 1;
         _loc4_ += 1;
      }
      var _loc5_ = new XML(_loc3_.toString());
      var _loc6_ = "";
      if(_loc3_.firstChild != undefined && _loc3_.firstChild.childNodes[1] != undefined && _loc3_.firstChild.childNodes[1].attributes.i)
      {
         _loc6_ = "," + _loc3_.firstChild.childNodes[1].attributes.i;
         classes.Lookup.addToRaceCarsXML(_loc3_.firstChild.childNodes[1]);
      }
      if(_loc3_.firstChild != undefined && _loc3_.firstChild.firstChild != undefined)
      {
         classes.Lookup.addToRaceCarsXML(_loc3_.firstChild.firstChild);
         classes.Lookup.runCallback("raceGetTwoRacersCars",_loc5_.firstChild.childNodes[0].attributes.i + _loc6_,_loc5_);
      }
   }
}
function ctGetRacers()
{
   if(classes.Control.serverAvail())
   {
      legacyCall("executeCall \"ctgr\"","ctGetRacersCB","GET");
   }
}
function ctGetRacersCB(d)
{
   classes.Control.serverUnlock();
   classes.Control.ctourneyMC.compXML = new XML(d);
   classes.Control.ctourneyMC.gotoAndPlay("computerSelection");
}
function ctJoin(ctid)
{
   if(classes.Control.serverAvail())
   {
      legacyCall("executeCall \"ctjt\" \"ctid=" + ctid + "\"","ctJoinCB","POST");
   }
}
function ctJoinCB(s, k)
{
   classes.Control.serverUnlock();
   switch(s)
   {
      case 1:
         classes.Control.ctourneyMC.gotoAndPlay("computerPreQualification");
         tmpCTKey = k;
         break;
      case 0:
         _root.displayAlert("warning","Tournament Error","Sorry, the tournament you selected does not exist.");
         break;
      case -1:
         _root.displayAlert("warning","Tournament Error","Sorry, the tournament you selected is temporarily unavailable.");
   }
}
function ctCreate(k, bt, acid)
{
   k = tmpCTKey;
   _global.chatObj.raceObj = new Object();
   _global.chatObj.raceObj.bt = bt;
   _global.chatObj.raceObj.myObj = new Object();
   var _loc5_ = _global.chatObj.raceObj.myObj;
   _loc5_.cid = acid;
   _loc5_.id = classes.GlobalData.id;
   _loc5_.un = classes.GlobalData.uname;
   _loc5_.ti = classes.GlobalData.attr.ti;
   _loc5_.tn = classes.GlobalData.attr.tn;
   _loc5_.sc = classes.GlobalData.attr.sc;
   _loc5_.bt = bt;
   _global.chatObj.raceObj.r1Obj = _global.chatObj.raceObj.myObj;
   legacyCall("executeCall \"ctct\" \"k=" + escape(k) + "&bt=" + bt + "&acid=" + acid + "\"","ctCreateCB","POST");
}
function CB_getTwoRacersCars(txml)
{
   _global.chatObj.twoRacersCarsXML = txml;
   classes.Control.ctourneyMC.gotoAndPlay("qualifyTrack");
}
function ctCreateCB(s)
{
   if(s == 1)
   {
      classes.Lookup.addCallback("raceGetTwoRacersCars",this,CB_getTwoRacersCars,_global.chatObj.raceObj.myObj.cid);
      _root.raceGetTwoRacersCars(_global.chatObj.raceObj.myObj.cid,0);
   }
   else
   {
      _root.displayAlert("warning","Tournament Error","Sorry, the tournament you selected is temporarily unavailable.");
   }
}
function ctRequest(caid)
{
   legacyCall("executeCall \"ctrt\" \"caid=" + caid + "\"","ctRequestCB","POST");
}
function ctRequestCB(s, d)
{
   if(s == 1)
   {
      var _loc4_ = new XML(d);
      classes.Lookup.runCallback("ctRequest",_loc4_.firstChild.attributes.cid,_loc4_);
   }
   else
   {
      _root.displayAlert("warning","Tournament Error","Sorry, the tournament you selected is temporarily unavailable.");
   }
}
function ctSaveCB(s, d)
{
   if(s == 1)
   {
      var _loc4_ = new XML(d);
      var _loc5_ = Number(_loc4_.firstChild.attributes.b);
      switch(Number(_loc4_.firstChild.attributes.w))
      {
         case 0:
            classes.Control.ctourneyMC.goLoserPage();
            classes.Control.setMapButton("nonrace");
            break;
         case 1:
            classes.GlobalData.updateInfo("m",Number(classes.GlobalData.attr.m) + _loc5_);
            classes.Control.ctourneyMC.goWinOneAndContinue(_loc5_);
            break;
         case 2:
            classes.GlobalData.updateInfo("m",Number(classes.GlobalData.attr.m) + _loc5_);
            classes.Control.ctourneyMC.goWinnerPage(_loc5_);
            classes.Control.setMapButton("nonrace");
      }
   }
   else
   {
      _root.displayAlert("warning","Tournament Error","Sorry, the tournament you selected is temporarily unavailable.");
   }
}
function ctStartAnimateComputerCB()
{
   classes.RacePlay._MC.tripWire(_global.chatObj.raceObj.oppObj.id,_global.chatObj.raceObj.oppObj.rt);
   _global.chatObj.raceObj.oppObj.startTS = new Date();
}
function ctFinishCB(et, ts)
{
   classes.Control.ctourneyMC.finishCompRace(et,ts);
}
function garageDynoBuy(acid)
{
   legacyCall("executeCall \"buydyno\", \"acid=" + acid + "\"","garageDynoBuyCB","POST");
}
function garageDynoBuyCB(s, b, bs, mp, cs)
{
   s = Number(s);
   switch(s)
   {
      case 1:
         classes.GlobalData.updateInfo("m",b);
         garageDynoMC.boostSetting = Number(bs);
         garageDynoMC.maxPsi = Number(mp);
         garageDynoMC.AFMeter = _loc0_ = Number(cs);
         garageDynoMC.chipSetting = _loc0_;
         garageDynoMC.gotoAndStop("dynoReady");
         break;
      case 0:
         _root.displayAlert("warning","Car not Available","Sorry, we cannot locate the car for the dyno.");
         break;
      case -2:
         _root.displayAlert("warning","Insufficient Funds","Sorry, you do not have enough in your balance to pay for dyno run.");
         break;
      case -3:
         _root.displayAlert("warning","Car not Available","I\'m sorry, but the car you selected to buy the part for is impounded.");
   }
}
function garageDynoBuySession(acid, m)
{
   legacyCall("executeCall \"buydyno\", \"acid=" + acid + "\"","garageDynoBuySessionCB","POST");
}
function garageDynoBuySessionCB(s, b)
{
   if(s == 2)
   {
      classes.GlobalData.updateInfo("p",b);
      garageDynoMC.gotoAndStop("dynoReady");
      garageDynoMC.populateSessionSwatch();
   }
   else if(s == 1)
   {
      classes.GlobalData.updateInfo("m",b);
      garageDynoMC.gotoAndStop("dynoReady");
   }
   else
   {
      _root.displayAlert("warning","Insufficient Funds","Sorry, you do not have enough in your balance to pay for dyno run.");
   }
}
function garageDynoRun(boost, chip)
{
   legacyCall("runEngineDyno " + boost + ", " + chip,"garageDynoRunCB","POST");
}
function garageDynoRunCB(strTorque, strFlow, strRatio, strMaxIcon)
{
   var _loc5_ = strTorque.split(",");
   var _loc6_ = strFlow.split(",");
   var _loc7_ = strRatio.split(",");
   var _loc8_ = strMaxIcon.split(",");
   var _loc9_ = 0;
   while(_loc9_ < _loc5_.length)
   {
      _loc5_[_loc9_] = Number(_loc5_[_loc9_]);
      _loc6_[_loc9_] = Number(_loc6_[_loc9_]);
      _loc7_[_loc9_] = Number(_loc7_[_loc9_]);
      _loc8_[_loc9_] = Number(_loc8_[_loc9_]);
      _loc9_ += 1;
   }
   garageDynoMC.drawDyno(_loc5_,_loc6_,_loc7_,_loc8_);
}
function garageDynoLoad()
{
   legacyCall("loadDyno","garageDynoLoadCB","GET");
}
function garageDynoLoadCB(n, strTorque, strFlow, strRatio, strMaxIcon)
{
   var _loc6_ = strTorque.split(",");
   var _loc7_ = strFlow.split(",");
   var _loc8_ = strRatio.split(",");
   var _loc9_ = strMaxIcon.split(",");
   var _loc10_ = 0;
   while(_loc10_ < _loc6_.length)
   {
      _loc6_[_loc10_] = Number(_loc6_[_loc10_]);
      _loc7_[_loc10_] = Number(_loc7_[_loc10_]);
      _loc8_[_loc10_] = Number(_loc8_[_loc10_]);
      _loc9_[_loc10_] = Number(_loc9_[_loc10_]);
      _loc10_ += 1;
   }
   garageDynoMC.drawDyno(_loc6_,_loc7_,_loc8_,_loc9_,n);
}
function garageDynoSave(aryDyno, aryAir, aryRatio, aryMaxIcon)
{
   legacyCall("saveDyno \"" + aryDyno.toString() + "\", \"" + aryAir.toString() + "\", \"" + aryRatio.toString() + "\", \"" + aryMaxIcon.toString() + "\"","garageDynoSaveCB","POST");
}
function garageDynoSaveCB(n)
{
   garageDynoMC.saveDynoInfoCallback(n);
}
function openURL(url)
{
   var _loc2_ = String(url);
   if(_loc2_.indexOf("://") < 0 && _loc2_.indexOf("mailto:") != 0 && _loc2_.indexOf("javascript:") != 0)
   {
      _loc2_ = legacyResolveAssetUrl(_loc2_);
   }
   else
   {
      _loc2_ = normalizeLegacyUrl(_loc2_);
   }
   getURL(_loc2_,"_blank");
}
function saveBroadcastRead(broadcastID)
{
   classes.GlobalData.prefsObj.broadcastRead = Number(broadcastID);
   classes.GlobalData.savePrefsObj();
}
function setSpecialEventTeamID(teamID)
{
   _global.specialEventTeamID = Number(teamID);
}
function displayTestDriveExpiredIfNecessary()
{
   if(_root.introHolder != undefined && _root.introHolder.displayTestDriveExpiredIfNecessaryNotLogin_Intro != undefined)
   {
      return _root.introHolder.displayTestDriveExpiredIfNecessaryNotLogin_Intro();
   }
   return false;
}
function getPromoObjects()
{
   if(_global.promoObjects == undefined)
   {
      _global.promoObjects = new Array();
   }
   return _global.promoObjects;
}
function displayAlert(alertIcon, alertTitle, alertMessage)
{
   _root.abc.closeMe();
   var _loc6_ = classes.AlertBox(this.attachMovie("alertBox","alertMC",this.getNextHighestDepth()));
   _loc6_.setValue(alertTitle,alertMessage,alertIcon);
   _loc6_.addButton("OK");
}
function showConnectionErrorCB(msgTitle, msg)
{
   classes.Frame.serverLights(false);
   displayAlert("warning",msgTitle,msg);
}
function loadUpdate()
{
   completeHttpLoginTransition();
}
function loadInstaller()
{
   completeHttpLoginTransition();
}
function onLoginSuccess()
{
   completeHttpLoginTransition();
}
function completeHttpLoginTransition()
{
   if(_global.httpLoginUiComplete)
   {
      return undefined;
   }
   _global.httpLoginUiComplete = true;
   trace("completeHttpLoginTransition -> root frame 116");
   classes.Frame.serverLights(false);
   _global.serverLocked = false;
   if(classes.Frame._MC != undefined && classes.Frame._MC.loginGroup != undefined)
   {
      classes.Frame._MC.loginGroup.stop();
      classes.Frame._MC.loginGroup._visible = false;
   }
   if(classes.data != undefined && classes.data.TutorialData != undefined && classes.data.TutorialData.init != undefined)
   {
      classes.data.TutorialData.init();
   }
   if(classes.Frame._MC != undefined && classes.Frame._MC.showSupportButton != undefined)
   {
      classes.Frame._MC.showSupportButton(true);
   }
   _global.testShowTestDriveExpiredOnDialogClose = false;
   _root.gotoAndPlay(116);
   setTimeout(refreshHttpHud,50);
   setTimeout(refreshHttpHud,150);
   setTimeout(refreshHttpHud,400);
   setTimeout(refreshHttpHud,900);
}
stop();
_global.mainURL = legacyGetBaseUrlFromSwf();
_global.apiBaseURL = _global.mainURL;
_global.apiBridgeURL = _global.mainURL + "api/legacy/bridge";
_global.assetBaseURL = _global.mainURL;
_global.assetPath = "cache";
_global.socketHost = "127.0.0.1";
_global.socketPort = 1626;
_global.locationXML = new XML("<locations></locations>");
configureLegacyGlobals();
loadServerConfig();
loadPrefsFile();
_global.promoObjects = new Array();
var isInAChat = false;
var raceMovie;
var raceTreeMovie;
var raceSound;
var repairPartMC;
var aryAvatar = new Array();
var isTimeoutSet = false;
var tmpCTKey;
var garageDynoMC;
this.attachMovie("frame","main",1);
var controlMan = new classes.Control(this);
