function setCar()
{
   drawSwatches();
   selCarID = Number(carsNode.childNodes[selCarIdx].attributes.i);
   wheelsNode = carsNode.childNodes[selCarIdx].childNodes[0];
   selWheelIdx = 0;
   selWheelID = Number(wheelsNode.firstChild.attributes.wid);
   selWheelPartID = Number(wheelsNode.firstChild.attributes.id);
   selWheelSize = Number(wheelsNode.firstChild.attributes.ws);
   selTireSize = Number(carsNode.childNodes[selCarIdx].attributes.ts);
   selRideHeight = Number(carsNode.childNodes[selCarIdx].attributes.rh);
   showLogo(selCarID);
   updateCarView();
   showWheelThumb(selWheelID);
}
function showLogo(id)
{
   logo.loadMovie("cache/car/logo_" + id + ".swf");
}
function showWheelThumb(id)
{
   wheelThumb.loadMovie("cache/parts/14_" + id + ".swf");
}
function updateWheel()
{
   selWheelID = Number(wheelsNode.childNodes[selWheelIdx].attributes.wid);
   selWheelPartID = Number(wheelsNode.childNodes[selWheelIdx].attributes.id);
   selWheelSize = Number(wheelsNode.childNodes[selWheelIdx].attributes.ws);
   showWheelThumb(selWheelID);
   updateCarView();
}
function drawSwatches()
{
   var _loc7_ = 8;
   var _loc9_ = 22;
   var _loc10_ = 8;
   var _loc8_ = 30;
   trace("selCarIndex: " + selCarIdx);
   trace(infoXML.firstChild.childNodes[selCarIdx]);
   var _loc4_ = 0;
   while(_loc4_ < paintSwatchArray.length)
   {
      paintSwatchArray[_loc4_].removeMovieClip();
      _loc4_ += 1;
   }
   paintSwatchArray = new Array();
   var _loc6_ = infoXML.firstChild.childNodes[selCarIdx].childNodes[1];
   trace("ahhh haaa");
   trace(_loc6_);
   trace(_loc6_.childNodes.length);
   _loc4_ = 0;
   var _loc5_;
   var _loc3_;
   while(_loc4_ < _loc6_.childNodes.length)
   {
      _loc5_ = paintSwatchArray.length;
      _loc3_ = classes.PaintSwatch(paintSwatchContainer.attachMovie("paintSwatch","swatch" + _loc5_,500 - _loc4_));
      _loc3_._x = Math.floor(_loc5_ / _loc7_) * _loc10_ + _loc5_ % _loc7_ * _loc9_;
      _loc3_._y = Math.floor(_loc5_ / _loc7_) * _loc8_;
      trace(_loc6_.childNodes[_loc4_].attributes.cd);
      _loc3_.HexColor = _loc6_.childNodes[_loc4_].attributes.cd;
      _loc3_.swatchColorMC.onRelease = function()
      {
         _root.dialogCreateAccount.onSwatchClick(this._parent.hexColor);
      };
      paintSwatchArray.push(_loc3_);
      _loc4_ += 1;
   }
   selColor = _loc6_.childNodes[0].attributes.cd;
}
function onSwatchClick(newColor)
{
   selColor = newColor;
   updateCarView();
}
function updateCarView()
{
   var _loc3_ = new classes.CarSpecs();
   _loc3_.modSpec("globalClr",Number("0x" + selColor));
   var _loc1_ = new Object();
   _loc1_.cs = _loc3_;
   _loc1_.carID = selCarID;
   _loc1_.cs.spoilerID = 1;
   _loc1_.cs.rideHeight = selRideHeight;
   _loc1_.cs.wheelSize = selWheelSize;
   _loc1_.cs.wheelFID = _loc1_.cs.wheelRID = selWheelID;
   _loc1_.cs.tireScaleFactor = 1 + selTireSize / 100;
   _loc1_.cs.setWheelAndTireScales();
   carThumb.clearCarView();
   var _loc2_ = "";
   if(isBack)
   {
      _loc2_ = "back";
      carThumb._x = 110;
   }
   else
   {
      _loc2_ = "front";
      carThumb._x = 150;
   }
   classes.Drawing.carView(carThumb,new XML(),100,_loc2_,_loc1_);
}
function pickSetting(p)
{
   gender = p;
   showGender(gender);
}
function showGender(p)
{
   switch(p)
   {
      case "M":
         genderPicker.gotoAndStop(2);
         return undefined;
      case "F":
         genderPicker.gotoAndStop(3);
   }
   return undefined;
}
function isValidEmailAddress(value)
{
   if(value == undefined || value == "")
   {
      return false;
   }
   var _loc2_ = String(value);
   var _loc3_ = _loc2_.indexOf("@");
   var _loc4_ = _loc2_.lastIndexOf(".");
   return _loc3_ > 0 && _loc4_ > _loc3_ + 1 && _loc4_ < _loc2_.length - 1;
}
function countDigits(value)
{
   var _loc2_ = 0;
   var _loc3_ = 0;
   var _loc4_ = String(value);
   while(_loc3_ < _loc4_.length)
   {
      if(_loc4_.charCodeAt(_loc3_) >= 48 && _loc4_.charCodeAt(_loc3_) <= 57)
      {
         _loc2_ = _loc2_ + 1;
      }
      _loc3_ += 1;
   }
   return _loc2_;
}
function isValidRecoveryContact(value)
{
   if(value == undefined || value == "")
   {
      return false;
   }
   if(isValidEmailAddress(value))
   {
      return true;
   }
   return countDigits(value) >= 7;
}
function sendForm()
{
   err = "";
   var _loc2_ = String(fldE.text).split(" ").join("");
   var _loc3_ = String(fldZ.text).split(" ").join("");
   if(fldU.text.length < 3)
   {
      err += "Racer Name must be at least 3 characters long.\r";
   }
   if(fldPW.text.length < 6)
   {
      err += "New Password must be at least 6 characters long.\r";
   }
   else if(fldPW.text == fldU.text)
   {
      err += "Password can not be the same as Racer Name. Please create a new password.\r";
      fldPW.text = "";
   }
   else if(fldPW.text.toLowerCase() == "password" || fldPW.text.toLowerCase() == "pw" || fldPW.text.toLowerCase() == "pass")
   {
      err += "Please create a stronger password.\r";
      fldPW.text = "";
   }
   if(fldPW.text != fldCPW.text)
   {
      err += "Confirm Password must be exactly the same as New Password. Please re-enter them.\r";
      fldPW.text = "";
      fldCPW.text = "";
   }
   if(_loc2_.length && !isValidEmailAddress(_loc2_) && !isValidRecoveryContact(_loc2_))
   {
      err += "Please enter a valid e-mail address.\r";
   }
   if(_loc3_.length && !isValidRecoveryContact(_loc3_))
   {
      err += "Please enter a valid phone number or recovery address.\r";
   }
   if(!_loc2_.length && !_loc3_.length)
   {
      err += "Please enter an e-mail address or phone number for account recovery.\r";
   }
   if(!fldY.text.length)
   {
      err += "Please enter your Birth Year.\r";
   }
   else if(fldY.text.length < 4)
   {
      err += "Birth Year must be 4 digits long (for example, 1965).\r";
   }
   if(!gender.length)
   {
      err += "Please select if you are Male or Female.\r";
   }
   if(err.length)
   {
      gotoAndStop("error");
      play();
   }
   else
   {
      username = fldU.text;
      password = fldPW.text;
      email = fldE.text;
      zip = fldZ.text;
      recoveryContact = !!fldZ.text.length ? fldZ.text : fldE.text;
      birth_year = fldY.text;
      starterCarID = selCarID;
      starterWheelID = selWheelID;
      starterWheelPartID = selWheelPartID;
      starterColor = selColor;
      gotoAndStop("sending");
      play();
   }
}
function ensureStarterCatalog()
{
   if(infoXML != undefined && infoXML.firstChild != undefined && infoXML.firstChild.childNodes.length > 0 && infoXML.firstChild.childNodes[0].attributes.i != undefined)
   {
      return undefined;
   }
   infoXML = new XML("<cd><car i=\"1\" ts=\"0\" rh=\"0\"><wheels><wheel id=\"214001\" wid=\"1\" ws=\"17\"/><wheel id=\"214002\" wid=\"2\" ws=\"17\"/><wheel id=\"214003\" wid=\"3\" ws=\"18\"/><wheel id=\"214004\" wid=\"4\" ws=\"18\"/></wheels><colors><color cd=\"57CFE0\"/><color cd=\"4AA54A\"/><color cd=\"C552CB\"/><color cd=\"222222\"/></colors></car><car i=\"3\" ts=\"0\" rh=\"0\"><wheels><wheel id=\"214001\" wid=\"1\" ws=\"17\"/><wheel id=\"214002\" wid=\"2\" ws=\"17\"/><wheel id=\"214003\" wid=\"3\" ws=\"18\"/><wheel id=\"214004\" wid=\"4\" ws=\"18\"/></wheels><colors><color cd=\"FF0000\"/><color cd=\"000000\"/><color cd=\"FFFFFF\"/><color cd=\"1F4E79\"/></colors></car><car i=\"55\" ts=\"0\" rh=\"0\"><wheels><wheel id=\"214001\" wid=\"1\" ws=\"17\"/><wheel id=\"214002\" wid=\"2\" ws=\"17\"/><wheel id=\"214003\" wid=\"3\" ws=\"18\"/><wheel id=\"214004\" wid=\"4\" ws=\"18\"/></wheels><colors><color cd=\"FF0000\"/><color cd=\"FFFFFF\"/><color cd=\"000000\"/><color cd=\"C0C0C0\"/></colors></car><car i=\"76\" ts=\"0\" rh=\"0\"><wheels><wheel id=\"214001\" wid=\"1\" ws=\"17\"/><wheel id=\"214002\" wid=\"2\" ws=\"17\"/><wheel id=\"214003\" wid=\"3\" ws=\"18\"/><wheel id=\"214004\" wid=\"4\" ws=\"18\"/></wheels><colors><color cd=\"FF0000\"/><color cd=\"FFFFFF\"/><color cd=\"000000\"/><color cd=\"0033CC\"/></colors></car></cd>");
   infoXML.ignoreWhite = true;
}
stop();
_root.dialogCreateAccount = this;
if(paintSwatchArray == undefined)
{
   paintSwatchArray = new Array();
}
if(gender == undefined)
{
   gender = "";
}
if(isBack == undefined)
{
   isBack = false;
}
if(txtU == undefined)
{
   txtU = "";
}
if(txtPW == undefined)
{
   txtPW = "";
}
if(txtCPW == undefined)
{
   txtCPW = "";
}
if(txtE == undefined)
{
   txtE = "";
}
if(txtZ == undefined)
{
   txtZ = "";
}
if(txtY == undefined)
{
   txtY = "";
}
if(txtCode == undefined)
{
   txtCode = "";
}
ensureStarterCatalog();
this.onEnterFrame = function()
{
   delete this.onEnterFrame;
   if(this._currentframe == 1)
   {
      this.gotoAndStop(2);
   }
};
