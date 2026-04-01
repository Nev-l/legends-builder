function makeLabel(parent, name, depth, x, y, w, h, value, color)
{
   parent.createTextField(name,depth,x,y,w,h);
   var _loc10_ = parent[name];
   var _loc11_ = new TextFormat();
   _loc11_.font = "_sans";
   _loc11_.size = 12;
   _loc11_.bold = true;
   _loc11_.color = color;
   _loc10_.selectable = false;
   _loc10_.multiline = false;
   _loc10_.wordWrap = false;
   _loc10_.text = value;
   _loc10_.setNewTextFormat(_loc11_);
   _loc10_.setTextFormat(_loc11_);
   return _loc10_;
}
function makeInput(parent, name, depth, x, y, w, h, value, isPassword, restrictValue)
{
   parent.createTextField(name,depth,x,y,w,h);
   var _loc11_ = parent[name];
   var _loc12_ = new TextFormat();
   _loc12_.font = "_sans";
   _loc12_.size = 12;
   _loc12_.color = 2236962;
   _loc11_.type = "input";
   _loc11_.border = true;
   _loc11_.borderColor = 5395026;
   _loc11_.background = true;
   _loc11_.backgroundColor = 16777215;
   _loc11_.text = value == undefined ? "" : value;
   _loc11_.password = isPassword;
   _loc11_.setNewTextFormat(_loc12_);
   _loc11_.setTextFormat(_loc12_);
   if(restrictValue != undefined)
   {
      _loc11_.restrict = restrictValue;
   }
   return _loc11_;
}
function makeStatusField(parent, name, depth, x, y, w, h)
{
   parent.createTextField(name,depth,x,y,w,h);
   var _loc8_ = parent[name];
   _loc8_.multiline = true;
   _loc8_.wordWrap = true;
   _loc8_.selectable = false;
   return _loc8_;
}
function applyStatus(target, value, isError)
{
   var _loc4_ = new TextFormat();
   _loc4_.font = "_sans";
   _loc4_.size = 12;
   _loc4_.bold = true;
   _loc4_.color = !isError ? 255 : 13382451;
   target.text = value;
   target.setNewTextFormat(_loc4_);
   target.setTextFormat(_loc4_);
}
function makeButton(parent, name, depth, x, y, w, h, label, baseColor)
{
   var _loc10_ = parent.createEmptyMovieClip(name,depth);
   _loc10_._x = x;
   _loc10_._y = y;
   _loc10_._w = w;
   _loc10_._h = h;
   _loc10_._label = label;
   _loc10_._baseColor = baseColor;
   _loc10_._enabled = true;
   _loc10_.drawButton = function(fillColor)
   {
      this.clear();
      this.lineStyle(1,1710618,100);
      this.beginFill(fillColor,100);
      this.moveTo(0,0);
      this.lineTo(this._w,0);
      this.lineTo(this._w,this._h);
      this.lineTo(0,this._h);
      this.lineTo(0,0);
      this.endFill();
      if(this.labelField == undefined)
      {
         this.createTextField("labelField",1,0,7,this._w,this._h - 8);
      }
      var _loc3_ = new TextFormat();
      _loc3_.font = "_sans";
      _loc3_.size = 12;
      _loc3_.bold = true;
      _loc3_.align = "center";
      _loc3_.color = 16777215;
      this.labelField.selectable = false;
      this.labelField.text = this._label;
      this.labelField.setNewTextFormat(_loc3_);
      this.labelField.setTextFormat(_loc3_);
      this.labelField._width = this._w;
      this.labelField._height = this._h - 8;
   };
   _loc10_.setEnabled = function(enabled)
   {
      this._enabled = enabled;
      this._alpha = !enabled ? 55 : 100;
      this.drawButton(!enabled ? 7303023 : this._baseColor);
   };
   _loc10_.onRollOver = function()
   {
      if(this._enabled)
      {
         this.drawButton(this._baseColor + 1579032);
      }
   };
   _loc10_.onRollOut = _loc10_.onReleaseOutside = function()
   {
      this.drawButton(this._baseColor);
   };
   _loc10_.useHandCursor = true;
   _loc10_.drawButton(baseColor);
   return _loc10_;
}
function drawGenderButton(btn, selected)
{
   btn.clear();
   btn.lineStyle(1,1710618,100);
   btn.beginFill(!selected ? 4277580 : 12316228,100);
   btn.moveTo(0,0);
   btn.lineTo(btn._w,0);
   btn.lineTo(btn._w,btn._h);
   btn.lineTo(0,btn._h);
   btn.lineTo(0,0);
   btn.endFill();
   if(btn.labelField == undefined)
   {
      btn.createTextField("labelField",1,0,6,btn._w,btn._h - 8);
   }
   var _loc3_ = new TextFormat();
   _loc3_.font = "_sans";
   _loc3_.size = 12;
   _loc3_.bold = true;
   _loc3_.align = "center";
   _loc3_.color = 16777215;
   btn.labelField.selectable = false;
   btn.labelField.text = btn._label;
   btn.labelField.setNewTextFormat(_loc3_);
   btn.labelField.setTextFormat(_loc3_);
}
function makeGenderButton(parent, name, depth, x, y, w, h, value, label)
{
   var _loc10_ = parent.createEmptyMovieClip(name,depth);
   _loc10_._x = x;
   _loc10_._y = y;
   _loc10_._w = w;
   _loc10_._h = h;
   _loc10_._value = value;
   _loc10_._label = label;
   _loc10_.useHandCursor = true;
   _loc10_.onRelease = function()
   {
      _root.dialogCreateAccount.gender = this._value;
      _root.dialogCreateAccount.refreshGenderButtons();
   };
   return _loc10_;
}
function isFormEmail(value)
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
function countFormDigits(value)
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
function isRecoveryValue(value)
{
   if(value == undefined || value == "")
   {
      return false;
   }
   if(isFormEmail(value))
   {
      return true;
   }
   return countFormDigits(value) >= 7;
}
function syncFormState()
{
   username = formFields.fldU.text;
   password = formFields.fldPW.text;
   email = formFields.fldE.text;
   zip = formFields.fldPhone.text;
   recoveryContact = !!formFields.fldPhone.text.length ? formFields.fldPhone.text : formFields.fldE.text;
   birth_year = formFields.fldY.text;
}
function showCreateError(message)
{
   applyStatus(formFields.statusField,message,true);
}
function mapCreateError(statusCode, httpStatus)
{
   switch(statusCode)
   {
      case -4:
         return "That Racer Name is already taken.";
      case -5:
         return "Racer Name must be at least 3 characters long.";
      case -6:
         return "New Password must be at least 6 characters long.";
      case -7:
         return "Please enter a valid e-mail address.";
      case -8:
         return "Please enter an e-mail address or phone number for account recovery.";
      case -9:
         return "Please enter a valid Birth Year.";
      case -10:
         return "Please select if you are Male or Female.";
      default:
         if(httpStatus != undefined && httpStatus > 0)
         {
            return "There was a problem creating your account. HTTP=" + httpStatus;
         }
         return "There was a problem creating your account.";
   }
}
function refreshGenderButtons()
{
   drawGenderButton(formFields.btnMale,gender == "M");
   drawGenderButton(formFields.btnFemale,gender == "F");
}
function submitCreateForm()
{
   syncFormState();
   var _loc3_ = String(formFields.fldE.text).split(" ").join("");
   var _loc4_ = String(formFields.fldPhone.text).split(" ").join("");
   var _loc5_ = "";
   if(formFields.fldU.text.length < 3)
   {
      _loc5_ += "Racer Name must be at least 3 characters long.\r";
   }
   if(formFields.fldPW.text.length < 6)
   {
      _loc5_ += "New Password must be at least 6 characters long.\r";
   }
   else if(formFields.fldPW.text == formFields.fldU.text)
   {
      _loc5_ += "Password can not be the same as Racer Name.\r";
   }
   else if(formFields.fldPW.text.toLowerCase() == "password" || formFields.fldPW.text.toLowerCase() == "pw" || formFields.fldPW.text.toLowerCase() == "pass")
   {
      _loc5_ += "Please create a stronger password.\r";
   }
   if(formFields.fldPW.text != formFields.fldCPW.text)
   {
      _loc5_ += "Re-type Password must exactly match Password.\r";
   }
   if(_loc3_.length && !isFormEmail(_loc3_))
   {
      _loc5_ += "Please enter a valid e-mail address.\r";
   }
   if(_loc4_.length && !isRecoveryValue(_loc4_))
   {
      _loc5_ += "Please enter a valid phone number for recovery.\r";
   }
   if(!_loc3_.length && !_loc4_.length)
   {
      _loc5_ += "Please enter an e-mail address or phone number for account recovery.\r";
   }
   if(!formFields.fldY.text.length)
   {
      _loc5_ += "Please enter your Birth Year.\r";
   }
   else if(formFields.fldY.text.length < 4)
   {
      _loc5_ += "Birth Year must be 4 digits long.\r";
   }
   if(!gender.length)
   {
      _loc5_ += "Please select if you are Male or Female.\r";
   }
   if(_loc5_.length)
   {
      showCreateError(_loc5_);
      return undefined;
   }
   applyStatus(formFields.statusField,"Creating account...",false);
   formFields.btnSubmit.setEnabled(false);
   formFields.btnBack.setEnabled(false);
   classes.Frame.serverLights(true);
   var _loc6_ = new LoadVars();
   var _loc7_ = new LoadVars();
   _loc6_.username = formFields.fldU.text;
   _loc6_.password = formFields.fldPW.text;
   _loc6_.email = _loc3_;
   _loc6_.zip = _loc4_;
   _loc6_.recovery_contact = !!_loc4_.length ? _loc4_ : _loc3_;
   _loc6_.birth_year = formFields.fldY.text;
   _loc6_.gender = gender;
   _loc6_.mailer_opt_in = 0;
   _loc6_.starterCarID = selCarID;
   _loc6_.starterWheelID = selWheelID;
   _loc6_.starterWheelPartID = selWheelPartID;
   _loc6_.starterColor = selColor;
   _loc7_.owner = this;
   _loc7_.sentUsername = formFields.fldU.text;
   _loc7_.sentPassword = formFields.fldPW.text;
   _loc7_.onHTTPStatus = function(httpStatus)
   {
      this.httpStatus = httpStatus;
   };
   _loc7_.onData = function(src)
   {
      classes.Frame.serverLights(false);
      this.owner.formFields.btnSubmit.setEnabled(true);
      this.owner.formFields.btnBack.setEnabled(true);
      if(src == undefined || src.length == 0)
      {
         this.owner.showCreateError("The server did not return any account data. HTTP=" + this.httpStatus);
         return undefined;
      }
      var _loc3_ = new XML(src);
      _loc3_.ignoreWhite = true;
      if(_loc3_.firstChild != undefined && _loc3_.firstChild.firstChild != undefined && _loc3_.firstChild.firstChild.nodeName == "a")
      {
         this.owner.username = this.sentUsername;
         this.owner.password = this.sentPassword;
         this.owner.gotoAndStop(16);
         this.owner.play();
         return undefined;
      }
      var _loc4_ = 0;
      if(_loc3_.firstChild != undefined && _loc3_.firstChild.firstChild != undefined && _loc3_.firstChild.firstChild.attributes.s != undefined)
      {
         _loc4_ = Number(_loc3_.firstChild.firstChild.attributes.s);
      }
      this.owner.showCreateError(this.owner.mapCreateError(_loc4_,this.httpStatus));
   };
   var _loc8_ = _global.apiBaseURL;
   if(_loc8_ == undefined || _loc8_ == "")
   {
      _loc8_ = _global.mainURL;
   }
   if(_loc8_.charAt(_loc8_.length - 1) != "/")
   {
      _loc8_ += "/";
   }
   _loc6_.sendAndLoad(_loc8_ + "api/auth/create",_loc7_,"POST");
}
stop();
classes.Frame.serverLights(false);
if(loadin != undefined)
{
   loadin.removeMovieClip();
}
this.createEmptyMovieClip("loadin",1);
loadin._x = 20;
loadin._y = 18;
loadin.createEmptyMovieClip("panel",0);
loadin.panel.lineStyle(1,2368548,100);
loadin.panel.beginFill(1579032,92);
loadin.panel.moveTo(0,0);
loadin.panel.lineTo(470,0);
loadin.panel.lineTo(470,270);
loadin.panel.lineTo(0,270);
loadin.panel.lineTo(0,0);
loadin.panel.endFill();
formFields = new Object();
makeLabel(loadin,"titleTxt",2,14,10,300,22,"Create Your Account",16777215);
makeLabel(loadin,"subtitleTxt",3,14,30,430,22,"Starter car and rims are already selected. Fill out the account details below.",14020589);
formFields.statusField = makeStatusField(loadin,"statusField",4,14,52,440,40);
applyStatus(formFields.statusField,"Enter your account details and recovery info.",false);
makeLabel(loadin,"lblU",5,14,96,120,20,"Racer Name",16777215);
formFields.fldU = makeInput(loadin,"fldU",6,14,116,200,22,username,false,undefined);
makeLabel(loadin,"lblPW",7,14,146,120,20,"Password",16777215);
formFields.fldPW = makeInput(loadin,"fldPW",8,14,166,200,22,password,true,undefined);
makeLabel(loadin,"lblCPW",9,14,196,150,20,"Re-type Password",16777215);
formFields.fldCPW = makeInput(loadin,"fldCPW",10,14,216,200,22,password,true,undefined);
makeLabel(loadin,"lblGender",11,236,96,100,20,"Male / Female",16777215);
formFields.btnMale = makeGenderButton(loadin,"btnMale",12,236,116,90,24,"M","Male");
formFields.btnFemale = makeGenderButton(loadin,"btnFemale",13,334,116,90,24,"F","Female");
makeLabel(loadin,"lblYear",14,236,146,100,20,"Birth Year",16777215);
formFields.fldY = makeInput(loadin,"fldY",15,236,166,90,22,birth_year,false,"0-9");
makeLabel(loadin,"lblE",16,236,196,190,20,"Email",16777215);
formFields.fldE = makeInput(loadin,"fldE",17,236,216,190,22,email,false,undefined);
makeLabel(loadin,"lblPhone",18,14,246,220,20,"Phone Number for Recovery",16777215);
formFields.fldPhone = makeInput(loadin,"fldPhone",19,14,266,200,22,zip,false,undefined);
formFields.btnBack = makeButton(loadin,"btnBack",20,236,258,90,28,"Back",5197647);
formFields.btnSubmit = makeButton(loadin,"btnSubmit",21,336,258,118,28,"Create Account",3893922);
formFields.btnBack._handler = function()
{
   syncFormState();
   gotoAndStop("car");
   play();
};
formFields.btnBack.onRelease = function()
{
   if(this._enabled)
   {
      this._handler();
   }
};
formFields.btnSubmit._handler = function()
{
   submitCreateForm();
};
formFields.btnSubmit.onRelease = function()
{
   if(this._enabled)
   {
      this._handler();
   }
};
if(gender == undefined)
{
   gender = "";
}
refreshGenderButtons();
Selection.setFocus(formFields.fldU);
