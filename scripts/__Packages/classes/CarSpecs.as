class classes.CarSpecs
{
   var globalClr;
   var wheelFID;
   var wheelRID;
   var tiresID;
   var hoodID;
   var bumperID;
   var bodyID;
   var brakeID;
   var rideHeight;
   var tireScale;
   var tireScaleFactor;
   var wheelScale;
   var wheelSize;
   var decalArr;
   function CarSpecs(pClr)
   {
      if(pClr)
      {
         this.globalClr = pClr;
      }
      else
      {
         this.globalClr = 0;
      }
      this.wheelFID = 1;
      this.wheelRID = 1;
      this.tiresID = 1;
      this.hoodID = 1;
      this.bumperID = 1;
      this.bodyID = 1;
      this.brakeID = 1;
      this.rideHeight = 8;
      this.tireScale = 90;
      this.tireScaleFactor = 1.1;
      this.wheelScale = 78;
      this.wheelSize = 16;
   }
   function modSpec(specName, val)
   {
      this[specName] = val;
   }
   function modAllColor(val)
   {
      for(var _loc3_ in this)
      {
         if(_loc3_.substr(_loc3_.length - 3,3) == "Clr")
         {
            this[_loc3_] = val;
         }
      }
   }
   function applyCarXML(carXML)
   {
      var _loc3_ = undefined;
      var _loc4_ = undefined;
      var _loc5_ = undefined;
      if(carXML != undefined)
      {
         this.modSpec("globalClr",Number("0x" + carXML.firstChild.attributes.cc));
         this.modSpec("plateID",carXML.firstChild.attributes.pi);
         this.modSpec("lic",carXML.firstChild.attributes.pn);
         this.decalArr = new Array();
         _loc4_ = 0;
         for(; _loc4_ < carXML.firstChild.childNodes.length; _loc4_ += 1)
         {
            if(Number(carXML.firstChild.childNodes[_loc4_].attributes["in"]) != 1)
            {
               continue;
            }
            _loc3_ = classes.CarSpecs.getName(Number(carXML.firstChild.childNodes[_loc4_].attributes.ci));
            trace("paramName: " + _loc3_);
            if(_loc3_)
            {
               this.modSpec(_loc3_ + "ID",Number(carXML.firstChild.childNodes[_loc4_].attributes.di));
               if(_loc3_ == "wheelF")
               {
                  this.modSpec("wheelRID",Number(carXML.firstChild.childNodes[_loc4_].attributes.di));
               }
               else if(_loc3_ == "body")
               {
                  this.modSpec("bodyOppID",Number(carXML.firstChild.childNodes[_loc4_].attributes.di));
               }
               if(carXML.firstChild.childNodes[_loc4_].attributes.cc.length > 1)
               {
                  this.modSpec(_loc3_ + "Clr",Number("0x" + carXML.firstChild.childNodes[_loc4_].attributes.cc));
                  if(_loc3_ == "wheelF")
                  {
                     this.modSpec("wheelRClr",Number("0x" + carXML.firstChild.childNodes[_loc4_].attributes.cc));
                  }
                  else if(_loc3_ == "body")
                  {
                     this.modSpec("bodyOppClr",Number("0x" + carXML.firstChild.childNodes[_loc4_].attributes.cc));
                  }
               }
            }
            switch(Number(carXML.firstChild.childNodes[_loc4_].attributes.ci))
            {
               case 160:
                  _loc5_ = true;
               case 148:
                  this.decalArr.push({part:"hood",order:1,isUGG:_loc5_,localPath:carXML.firstChild.childNodes[_loc4_].attributes.localPath,parentdi:Number(carXML.firstChild.childNodes[_loc4_].attributes.pdi),di:Number(carXML.firstChild.childNodes[_loc4_].attributes.di),partID:Number(carXML.firstChild.childNodes[_loc4_].attributes.i),catID:Number(carXML.firstChild.childNodes[_loc4_].attributes.ci),partClr:Number("0x" + carXML.firstChild.childNodes[_loc4_].attributes.cc)});
                  break;
               case 161:
                  _loc5_ = true;
               case 149:
                  this.decalArr.push({part:"side",order:2,isUGG:_loc5_,localPath:carXML.firstChild.childNodes[_loc4_].attributes.localPath,parentdi:Number(carXML.firstChild.childNodes[_loc4_].attributes.pdi),di:Number(carXML.firstChild.childNodes[_loc4_].attributes.di),partID:Number(carXML.firstChild.childNodes[_loc4_].attributes.i),catID:Number(carXML.firstChild.childNodes[_loc4_].attributes.ci),partClr:Number("0x" + carXML.firstChild.childNodes[_loc4_].attributes.cc)});
                  break;
               case 162:
                  _loc5_ = true;
               case 150:
                  this.decalArr.push({part:"front",order:3,isUGG:_loc5_,localPath:carXML.firstChild.childNodes[_loc4_].attributes.localPath,parentdi:Number(carXML.firstChild.childNodes[_loc4_].attributes.pdi),di:Number(carXML.firstChild.childNodes[_loc4_].attributes.di),partID:Number(carXML.firstChild.childNodes[_loc4_].attributes.i),catID:Number(carXML.firstChild.childNodes[_loc4_].attributes.ci),partClr:Number("0x" + carXML.firstChild.childNodes[_loc4_].attributes.cc)});
                  break;
               case 163:
                  _loc5_ = true;
               case 151:
                  this.decalArr.push({part:"back",order:4,isUGG:_loc5_,localPath:carXML.firstChild.childNodes[_loc4_].attributes.localPath,parentdi:Number(carXML.firstChild.childNodes[_loc4_].attributes.pdi),di:Number(carXML.firstChild.childNodes[_loc4_].attributes.di),partID:Number(carXML.firstChild.childNodes[_loc4_].attributes.i),catID:Number(carXML.firstChild.childNodes[_loc4_].attributes.ci),partClr:Number("0x" + carXML.firstChild.childNodes[_loc4_].attributes.cc)});
                  break;
               case 146:
                  this.decalArr.push({part:"full",order:5,localPath:carXML.firstChild.childNodes[_loc4_].attributes.localPath,parentdi:Number(carXML.firstChild.childNodes[_loc4_].attributes.pdi),di:Number(carXML.firstChild.childNodes[_loc4_].attributes.di),partID:Number(carXML.firstChild.childNodes[_loc4_].attributes.i),catID:Number(carXML.firstChild.childNodes[_loc4_].attributes.ci),partClr:Number("0x" + carXML.firstChild.childNodes[_loc4_].attributes.cc)});
            }
            switch(Number(carXML.firstChild.childNodes[_loc4_].attributes.ci))
            {
               case 13:
                  if(carXML.firstChild.childNodes[_loc4_].attributes.ps.length)
                  {
                     this.tireScaleFactor = 1 + Number(carXML.firstChild.childNodes[_loc4_].attributes.ps) / 100;
                  }
                  break;
               case 14:
                  if(Number(carXML.firstChild.childNodes[_loc4_].attributes.ps))
                  {
                     this.wheelSize = Math.max(14,Math.min(20,Number(carXML.firstChild.childNodes[_loc4_].attributes.ps)));
                  }
                  break;
               case 114:
                  this.rideHeight = Number(carXML.firstChild.childNodes[_loc4_].attributes.ps);
                  break;
            }
         }
         this.decalArr.sortOn("order");
         trace("sorting... ");
         this.setWheelAndTireScales();
      }
   }
   function setWheelAndTireScales()
   {
      this.wheelScale = 70 + (this.wheelSize - 14) * 24 / 6;
      this.tireScale = Math.min(100,this.wheelScale * this.tireScaleFactor);
   }
   function toString()
   {
      var _loc2_ = "";
      for(var _loc3_ in this)
      {
         if(_loc3_.substr(_loc3_.length - 2,2) == "ID")
         {
            _loc2_ += _loc3_ + ":" + this[_loc3_] + " _ ";
         }
      }
      return _loc2_;
   }
   static function isVisible(partCatID)
   {
      var _loc2_ = new Array(13,14,65,68,71,72,73,74,75,76,77,114,128,129,130,140,141,142,143,144,145,146,148,149,150,151,174);
      var _loc3_ = false;
      var _loc4_ = 0;
      while(_loc4_ < _loc2_.length)
      {
         if(_loc2_[_loc4_] == partCatID)
         {
            _loc3_ = true;
            break;
         }
         _loc4_ += 1;
      }
      return _loc3_;
   }
   static function isPaintable(partCatID)
   {
      var _loc2_ = new Array(65,68,71,72,73,74,75,76,77,128,129,130,140,141,142,143,144,174);
      var _loc3_ = false;
      var _loc4_ = 0;
      while(_loc4_ < _loc2_.length)
      {
         if(_loc2_[_loc4_] == partCatID)
         {
            _loc3_ = true;
            break;
         }
         _loc4_ += 1;
      }
      return _loc3_;
   }
   static function getName(id)
   {
      var _loc2_ = undefined;
      switch(id)
      {
         case 13:
            _loc2_ = "tires";
            break;
         case 14:
            _loc2_ = "wheelF";
            break;
         case 65:
            _loc2_ = "spoiler";
            break;
         case 68:
            _loc2_ = "roofEffect";
            break;
         case 71:
            _loc2_ = "hood";
            break;
         case 72:
            _loc2_ = "hoodCenterEffect";
            break;
         case 73:
            _loc2_ = "sideEffect";
            break;
         case 74:
            _loc2_ = "hoodFrontEffect";
            break;
         case 75:
            _loc2_ = "eyelids";
            break;
         case 76:
            _loc2_ = "lights";
            break;
         case 77:
            _loc2_ = "tailLights";
            break;
         case 128:
            _loc2_ = "bumper";
            break;
         case 129:
            _loc2_ = "skirt";
            break;
         case 130:
            _loc2_ = "bumperRear";
            break;
         case 140:
            _loc2_ = "grille";
            break;
         case 141:
            _loc2_ = "cPillarEffect";
            break;
         case 142:
            _loc2_ = "fenderEffect";
            break;
         case 143:
            _loc2_ = "doorEffect";
            break;
         case 144:
            _loc2_ = "trunk";
            break;
         case 174:
            _loc2_ = "top";
            break;
         default:
            _loc2_;
      }
      return _loc2_;
   }
}
