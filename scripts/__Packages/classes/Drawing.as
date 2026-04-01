class classes.Drawing
{
   var context;
   var userID;
   var action;
   var teamID;
   var decal;
   var decalLoadin;
   var onEnterFrame;
   var _xscale;
   static var bmpObj = new Object();
   static var aryCarDrawings = new Array();
   static var loadPartsArr = new Array("wheelMaskAddR","wheelMaskAddF","shadow","underCarriage","trunk","bodyOpp","body","bumperRear","skirt","bumper","grille","hood","lights","doorEffect","fenderEffect","cPillarEffect","sideEffect","hoodCenterEffect","hoodFrontEffect","eyelids","spoiler","top","roofEffect","tireF","tireR");
   static var loadPartsBackArr = new Array("wheelMaskAddF","wheelMaskAddR","shadow","underCarriage","tireBack","body","bodyOpp","top","trunk","roofEffect","spoiler","sideEffect","cPillarEffect","fenderEffect","doorEffect","bumperRear","tailLights","skirt","tireF","tireR");
   static var optionalPartsArr = new Array("grille","lights","doorEffect","fenderEffect","cPillarEffect","sideEffect","hoodCenterEffect","hoodFrontEffect","eyelids","spoiler","roofEffect","top");
   static var optionalPartsBackArr = new Array("roofEffect","spoiler","sideEffect","cPillarEffect","fenderEffect","doorEffect","tailLights","top");
   static var drawCarQueue = new Array();
   function Drawing(context)
   {
   }
   static function newBaseWindow(_context, ww, hh)
   {
      with(_context)
      {
         colors = [10660788,1845553,0];
         alphas = [100,100,100];
         ratios = [0,207,255];
         matrix = {matrixType:"box",x:0,y:0,w:ww - 5,h:hh - 30,r:1.2217304763960306};
         beginGradientFill("linear",colors,alphas,ratios,matrix);
         moveTo(0,0);
         lineTo(ww,0);
         lineTo(ww,hh);
         lineTo(0,hh);
         lineTo(0,0);
         endFill();
         beginFill(0,100);
         moveTo(0,0);
         lineTo(Math.round(ww * 0.19),0);
         lineTo(ww,Math.round(hh * 0.85));
         lineTo(ww,hh);
         lineTo(0,hh);
         lineTo(0,0);
         endFill();
      }
   }
   static function newConsoleWindow(_context, ww, hh)
   {
      var _loc4_ = new flash.geom.Point(0,0);
      var _loc5_ = new flash.geom.Point(ww,0);
      var _loc6_ = new flash.geom.Point(ww,hh);
      var _loc7_ = new flash.geom.Point(0,hh);
      classes.Drawing.rect(_context,ww,hh,0,100,_loc4_.x,_loc4_.y,8);
   }
   static function rotateConsoleWindow(_context, ww, hh, p1, p2, p3, p4, degrees)
   {
      with(_context)
      {
         clear();
         var _loc9_ = 30;
         var _loc10_ = undefined;
         var _loc11_ = undefined;
         var _loc12_ = 3;
         var _loc13_ = undefined;
         var _loc14_ = undefined;
         if(Math.abs(degrees) > 0)
         {
            _loc10_ = _loc9_ * Math.sin(degrees * 3.141592653589793 / 180);
            _loc11_ = p3.y;
            edge.lineTo(_loc10_,vPersp);
            edge.lineTo(_loc10_,_loc11_ - vPersp);
            vPersp = _loc9_ / 2 * Math.cos(ptheta);
            _loc13_ = new flash.geom.Point();
            _loc14_ = new flash.geom.Point();
            if(degrees > 0)
            {
               _loc13_.x = p2.x + _loc10_;
               _loc13_.y = p2.y + vPersp;
               _loc14_.x = _loc13_.x;
               _loc14_.y = p3.y - vPersp;
               moveTo(p2.x,p2.y + _loc12_);
               beginFill(0);
               lineTo(_loc13_.x,_loc13_.y + _loc12_);
               lineTo(_loc14_.x,_loc14_.y - _loc12_);
               lineTo(p3.x,p3.y - _loc12_);
               lineTo(p2.x,p2.y + _loc12_);
               endFill();
            }
            else
            {
               _loc13_.x = p1.x + _loc10_;
               _loc13_.y = p1.y + vPersp;
               _loc14_.x = _loc13_.x;
               _loc14_.y = p4.y - vPersp;
               moveTo(p1.x,p1.y + _loc12_);
               beginFill(0);
               lineTo(_loc13_.x,_loc13_.y + _loc12_);
               lineTo(_loc14_.x,_loc14_.y - _loc12_);
               lineTo(p4.x,p4.y - _loc12_);
               lineTo(p1.x,p1.y + _loc12_);
               endFill();
            }
         }
      }
   }
   static function addCornerResizer(_context, handleName)
   {
      _context.createEmptyMovieClip("corner",_context.getNextHighestDepth());
      with(_context.corner)
      {
         beginFill(0,0);
         lineTo(20,0);
         lineTo(20,20);
         lineTo(0,20);
         endFill();
      }
      with(_context)
      {
         corner._x = _context._width - corner._width;
         corner._y = _context._y + _context._height - corner._height;
         _context.attachMovie("cornerHandle",handleName,_context.getNextHighestDepth());
         _context[handleName]._x = corner._x;
         _context[handleName]._y = corner._y;
      }
   }
   static function topLines(_lines, _linesMask, ww)
   {
      with(_lines)
      {
         clear();
         colors = [0,0,0,0];
         alphas = [20,50,50,20];
         ratios = [0,15,240,255];
         matrix = {matrixType:"box",x:0,y:0,w:ww,h:1,r:0};
         beginGradientFill("linear",colors,alphas,ratios,matrix);
         moveTo(0,0);
         lineTo(ww,0);
         lineTo(ww,1);
         lineTo(0,1);
         lineTo(0,0);
         endFill();
         colors = [16777215,16777215,16777215,16777215];
         beginGradientFill("linear",colors,alphas,ratios,matrix);
         moveTo(0,1);
         lineTo(ww,1);
         lineTo(ww,2);
         lineTo(0,2);
         lineTo(0,1);
         endFill();
      }
      with(_linesMask)
      {
         clear();
         beginFill(16777215,100);
         lineTo(19,0);
         lineTo(19,10);
         lineTo(0,10);
         lineTo(0,0);
         endFill();
         beginFill(16777215,100);
         moveTo(82,0);
         lineTo(90,0);
         lineTo(90,10);
         lineTo(82,10);
         lineTo(82,0);
         endFill();
         beginFill(16777215,100);
         moveTo(153,0);
         lineTo(_lines._width,0);
         lineTo(_lines._width,10);
         lineTo(153,10);
         lineTo(153,0);
         endFill();
      }
   }
   static function midLines(_lines, ww)
   {
      with(_lines)
      {
         clear();
         colors = [0,0,0,0];
         alphas = [20,50,50,20];
         ratios = [0,15,240,255];
         matrix = {matrixType:"box",x:0,y:0,w:ww,h:1,r:0};
         beginGradientFill("linear",colors,alphas,ratios,matrix);
         moveTo(0,0);
         lineTo(ww,0);
         lineTo(ww,1);
         lineTo(0,1);
         lineTo(0,0);
         endFill();
         colors = [16777215,16777215,16777215,16777215];
         beginGradientFill("linear",colors,alphas,ratios,matrix);
         moveTo(0,1);
         lineTo(ww,1);
         lineTo(ww,2);
         lineTo(0,2);
         lineTo(0,1);
         endFill();
      }
   }
   static function portrait(_context, accountID, shadStrength, offLeft, offTop, lineWeight, fadeIn, avatarType, noCache)
   {
      trace("portrait");
      if(!avatarType)
      {
         avatarType = "avatars";
      }
      if(_context.photo == undefined)
      {
         if(!lineWeight)
         {
            lineWeight = 1;
         }
         if(!offLeft)
         {
            offLeft = 0;
         }
         if(!offTop)
         {
            offTop = 0;
         }
         _context.createEmptyMovieClip("photo",_context.getNextHighestDepth());
         _context.photo.id = accountID;
         with(_context)
         {
            with(photo)
            {
               var _loc10_ = 6;
               var _loc11_ = 98;
               var _loc12_ = 80;
               var _loc13_ = offLeft;
               var _loc14_ = offTop;
               clear();
               moveTo(_loc13_ + _loc10_,_loc14_);
               beginFill(16777215);
               lineTo(_loc13_ + _loc11_ - _loc10_,_loc14_);
               curveTo(_loc13_ + _loc11_,_loc14_,_loc13_ + _loc11_,_loc14_ + _loc10_);
               lineTo(_loc13_ + _loc11_,_loc14_ + _loc12_ - _loc10_);
               curveTo(_loc13_ + _loc11_,_loc14_ + _loc12_,_loc13_ + _loc11_ - _loc10_,_loc14_ + _loc12_);
               lineTo(_loc13_ + _loc10_,_loc14_ + _loc12_);
               curveTo(_loc13_,_loc14_ + _loc12_,_loc13_,_loc14_ + _loc12_ - _loc10_);
               lineTo(_loc13_,_loc14_ + _loc10_);
               curveTo(_loc13_,_loc14_,_loc13_ + _loc10_,_loc14_);
               endFill();
            }
            if(photo.pic == undefined)
            {
               photo.createEmptyMovieClip("pic",photo.getNextHighestDepth());
               photo.pic.createEmptyMovieClip("loadin",photo.pic.getNextHighestDepth());
               if(fadeIn)
               {
                  photo.pic.loadin._alpha = 0;
               }
               photo.createEmptyMovieClip("picMask",photo.getNextHighestDepth());
               photo.pic._x = offLeft + lineWeight;
               photo.pic._y = offTop + lineWeight;
            }
            with(photo.picMask)
            {
               var _loc10_ = 6 - (lineWeight - 1);
               var _loc11_ = 98 - 2 * lineWeight;
               var _loc12_ = 80 - 2 * lineWeight;
               var _loc13_ = offLeft + lineWeight;
               var _loc14_ = offTop + lineWeight;
               clear();
               moveTo(_loc13_ + _loc10_,_loc14_);
               beginFill(0);
               lineTo(_loc13_ + _loc11_ - _loc10_,_loc14_);
               curveTo(_loc13_ + _loc11_,_loc14_,_loc13_ + _loc11_,_loc14_ + _loc10_);
               lineTo(_loc13_ + _loc11_,_loc14_ + _loc12_ - _loc10_);
               curveTo(_loc13_ + _loc11_,_loc14_ + _loc12_,_loc13_ + _loc11_ - _loc10_,_loc14_ + _loc12_);
               lineTo(_loc13_ + _loc10_,_loc14_ + _loc12_);
               curveTo(_loc13_,_loc14_ + _loc12_,_loc13_,_loc14_ + _loc12_ - _loc10_);
               lineTo(_loc13_,_loc14_ + _loc10_);
               curveTo(_loc13_,_loc14_,_loc13_ + _loc10_,_loc14_);
               endFill();
            }
            photo.pic.setMask(photo.picMask);
         }
         if(avatarType == "teamavatars")
         {
            _context.photo.pic.loadin.attachMovie("portraitTeamAvatar","portrait_offline",1);
         }
         else
         {
            trace("creating portrait_offline!");
            _context.photo.pic.loadin.attachMovie("portrait_offline","portrait_offline",1);
         }
      }
      var _loc15_ = undefined;
      if(accountID)
      {
         _loc15_ = new classes.ImageIO();
         _loc15_.avatarType = avatarType;
         _loc15_.loadAvatar(_context.photo.pic.loadin,accountID,noCache);
      }
      var _loc16_ = undefined;
      var _loc17_ = undefined;
      if(shadStrength)
      {
         _loc16_ = new flash.filters.DropShadowFilter(3 + 2 * shadStrength,45,0,0.45 + 0.05 * shadStrength,9 * shadStrength,9 * shadStrength,1,2);
         _loc17_ = [];
         _loc17_.push(_loc16_);
         _context.photo.filters = _loc17_;
      }
   }
   static function userListItem(_context, newName, pid, puname, px, py, action)
   {
      if(!newName)
      {
         newName = "userListItem";
      }
      if(!px)
      {
         px = 0;
      }
      if(!py)
      {
         py = 0;
      }
      if(!pid || !puname)
      {
         return undefined;
      }
      _context.attachMovie("userListItem",newName,_context.getNextHighestDepth(),{_x:px,_y:py,userID:pid,userName:puname});
      classes.Drawing.portrait(_context[newName],pid,2,0,0,4);
      _context[newName].photo._xscale = 25;
      _context[newName].photo._yscale = 25;
      _context[newName].photo._x = 100;
      if(action)
      {
         _context[newName].context = _context;
         _context[newName].action = action;
         _context[newName].onRelease = function()
         {
            this.action.call(this.context,this.userID);
         };
      }
   }
   static function teamListItem(_context, newName, pid, ptname, px, py, action)
   {
      if(!newName)
      {
         newName = "teamListItem";
      }
      if(!px)
      {
         px = 0;
      }
      if(!py)
      {
         py = 0;
      }
      if(!pid || !ptname)
      {
         return undefined;
      }
      _context.attachMovie("teamListItem",newName,_context.getNextHighestDepth(),{_x:px,_y:py,teamID:pid,teamName:ptname});
      classes.Drawing.portrait(_context[newName],pid,2,0,0,4,false,"teamavatars");
      _context[newName].photo._xscale = 25;
      _context[newName].photo._yscale = 25;
      if(action)
      {
         _context[newName].context = _context;
         _context[newName].action = action;
         _context[newName].onRelease = function()
         {
            this.action.call(this.context,this.teamID);
         };
      }
   }
   static function clearCarBmps()
   {
      var _loc1_ = 0;
      var _loc2_;
      while(_loc1_ < classes.Drawing.aryCarDrawings.length)
      {
         if(classes.Drawing.aryCarDrawings[_loc1_][0].toString() == undefined)
         {
            _loc2_ = 1;
            while(_loc2_ < classes.Drawing.aryCarDrawings[_loc1_].length)
            {
               classes.Drawing.aryCarDrawings[_loc1_][_loc2_].dispose();
               _loc2_ += 1;
            }
            classes.Drawing.aryCarDrawings.splice(_loc1_,1);
            _loc1_ -= 1;
         }
         _loc1_ += 1;
      }
   }
   static function clearThisCarsBmps(targetClip)
   {
      var _loc2_ = targetClip._target;
      var _loc3_ = 0;
      var _loc4_ = undefined;
      while(_loc3_ < classes.Drawing.aryCarDrawings.length)
      {
         if(classes.Drawing.aryCarDrawings[_loc3_][0]._target == _loc2_)
         {
            _loc4_ = 1;
            while(_loc4_ < classes.Drawing.aryCarDrawings[_loc3_].length)
            {
               classes.Drawing.aryCarDrawings[_loc3_][_loc4_].dispose();
               _loc4_ += 1;
            }
            classes.Drawing.aryCarDrawings.splice(_loc3_,1);
            _loc3_ -= 1;
         }
         _loc3_ += 1;
      }
   }
   static function drawDecalsOnCar(targetClip, decalArr, coreYAdj, isBack)
   {
      if(!decalArr.length || !targetClip)
      {
         return undefined;
      }
      targetClip.decalLoader._y -= coreYAdj;
      var _loc4_ = 0;
      var _loc5_ = undefined;
      var _loc6_ = undefined;
      var _loc7_ = undefined;
      var _loc8_ = undefined;
      var _loc9_ = undefined;
      var _loc10_ = undefined;
      var _loc11_ = undefined;
      var _loc12_ = undefined;
      var _loc13_ = undefined;
      var _loc14_ = undefined;
      var _loc15_ = undefined;
      var _loc16_ = undefined;
      var _loc17_ = undefined;
      var _loc18_ = undefined;
      var _loc19_ = undefined;
      var _loc20_ = undefined;
      var _loc21_ = undefined;
      var _loc22_ = undefined;
      var _loc23_ = undefined;
      var _loc24_ = undefined;
      loop0:
      while(_loc4_ < decalArr.length)
      {
         _loc5_ = decalArr[_loc4_].part == "full";
         if(_loc5_)
         {
            _loc6_ = targetClip.decalLoader.createEmptyMovieClip("full",targetClip.decalLoader.getNextHighestDepth());
         }
         else
         {
            _loc6_ = undefined;
            for(_loc26_ in targetClip.decalLoader)
            {
               if(typeof targetClip.decalLoader[_loc26_] == "movieclip")
               {
                  _loc6_ = targetClip.decalLoader[_loc26_][decalArr[_loc4_].part];
                  if(_loc6_ != undefined)
                  {
                     break loop0;
                  }
               }
            }
            if(_loc6_ == undefined)
            {
               _loc4_ += 1;
               continue;
            }
         }
         _loc6_.isBack = isBack;
         _loc6_.decalLoadin = decalArr[_loc4_].localPath == undefined ? targetClip[decalArr[_loc4_].catID] : decalArr[_loc4_].localPath;
         _loc6_.part = decalArr[_loc4_].part;
         _loc6_.partClr = decalArr[_loc4_].partClr;
         _loc6_.ii = _loc4_;
         _loc6_.di = Number(decalArr[_loc4_].di);
         _loc6_.decalTextureMap = function(tpm)
         {
            var _loc3_ = tpm.actual;
            if(!_loc3_)
            {
               return undefined;
            }
            if(!_loc3_.decal)
            {
               _loc3_.createEmptyMovieClip("decal",_loc3_.getNextHighestDepth());
               _loc3_.shad.swapDepths(_loc3_.getNextHighestDepth());
               _loc3_.hi.swapDepths(_loc3_.getNextHighestDepth());
               _loc3_.noPaint.swapDepths(_loc3_.getNextHighestDepth());
               _loc3_.bmp = new flash.display.BitmapData(_loc3_.paint._width,_loc3_.paint._height,true,0);
            }
            _loc3_.bmp.draw(this.decal,new flash.geom.Matrix(1,0,0,1,- tpm._x - _loc3_.paint._x,- tpm._y - _loc3_.paint._y - coreYAdj),new flash.geom.ColorTransform(),null,null,true);
            _loc3_.bmp.draw(_loc3_.paint,new flash.geom.Matrix(),new flash.geom.ColorTransform(),"alpha",null,true);
            _loc3_.decal.attachBitmap(_loc3_.bmp,1,"never",true);
            _loc3_.decal._x = _loc3_.paint._x;
            _loc3_.decal._y = _loc3_.paint._y;
         };
         _loc6_.decalTexturePerfect = function(tpm)
         {
            var _loc3_ = tpm.actual;
            if(!_loc3_)
            {
               return undefined;
            }
            if(!_loc3_.decalPerfect)
            {
               _loc3_.createEmptyMovieClip("decalPerfect",_loc3_.getNextHighestDepth());
               _loc3_.shad.swapDepths(_loc3_.getNextHighestDepth());
               _loc3_.hi.swapDepths(_loc3_.getNextHighestDepth());
               _loc3_.noPaint.swapDepths(_loc3_.getNextHighestDepth());
               _loc3_.bmp = new flash.display.BitmapData(_loc3_.paint._width,_loc3_.paint._height,true,0);
            }
            _loc3_.bmp.draw(this.decalLoadin,new flash.geom.Matrix(1,0,0,1,- tpm._x - _loc3_.paint._x,- tpm._y - _loc3_.paint._y - coreYAdj),new flash.geom.ColorTransform(),null,null,true);
            _loc3_.bmp.draw(_loc3_.paint,new flash.geom.Matrix(),new flash.geom.ColorTransform(),"alpha",null,true);
            _loc3_.decalPerfect.attachBitmap(_loc3_.bmp,1,"never",true);
            _loc3_.decalPerfect._x = _loc3_.paint._x;
            _loc3_.decalPerfect._y = _loc3_.paint._y;
         };
         if(_loc5_)
         {
            _loc6_.decalLoadin.gotoAndStop(_loc6_.di);
            if(_loc6_.decalLoadin.paint != undefined)
            {
               _loc6_.decalLoadin.clr = new Color(_loc6_.decalLoadin.paint);
               _loc6_.decalLoadin.clr.setRGB(_loc6_.partClr);
            }
            _loc6_.decalTexturePerfect(targetClip.roofEffect);
            _loc6_.decalTexturePerfect(targetClip.eyelids);
            _loc6_.decalTexturePerfect(targetClip.hoodCenterEffect);
            _loc6_.decalTexturePerfect(targetClip.hoodBackEffect);
            _loc6_.decalTexturePerfect(targetClip.sideEffect);
            _loc6_.decalTexturePerfect(targetClip.fenderEffect);
            _loc6_.decalTexturePerfect(targetClip.cPillarEffect);
            _loc6_.decalTexturePerfect(targetClip.doorEffect);
            _loc6_.decalTexturePerfect(targetClip.trunk);
            _loc6_.decalTexturePerfect(targetClip.hood);
            _loc6_.decalTexturePerfect(targetClip.grille);
            _loc6_.decalTexturePerfect(targetClip.bumper);
            _loc6_.decalTexturePerfect(targetClip.bumperRear);
            _loc6_.decalTexturePerfect(targetClip.skirt);
            _loc6_.decalTexturePerfect(targetClip.body);
            _loc6_.decalTexturePerfect(targetClip.bodyOpp);
         }
         else
         {
            _loc6_.decalLoadin.gotoAndStop(_loc6_.di);
            if(_loc6_.decalLoadin != undefined)
            {
               _loc7_ = "_________";
               for(_loc26_ in _loc6_.decalLoadin)
               {
                  _loc7_ += _loc26_ + "_______";
               }
            }
            if(_loc6_.decalLoadin.paint != undefined)
            {
               _loc6_.decalLoadin.clr = new Color(_loc6_.decalLoadin.paint);
               _loc6_.decalLoadin.clr.setRGB(_loc6_.partClr);
            }
            _loc8_ = 0;
            _loc9_ = 0;
            for(_loc26_ in _loc6_)
            {
               if(typeof _loc6_[_loc26_] == "movieclip" && _loc26_.substr(0,1) == "p")
               {
                  _loc10_ = _loc26_.substr(1).split("_");
                  if(parseInt(_loc10_[0],10) > _loc8_)
                  {
                     _loc8_ = parseInt(_loc10_[0],10);
                  }
                  if(parseInt(_loc10_[1],10) > _loc9_)
                  {
                     _loc9_ = parseInt(_loc10_[1],10);
                  }
               }
            }
            _loc11_ = new Array();
            _loc12_ = 1;
            while(_loc12_ <= _loc8_)
            {
               _loc13_ = new Array();
               _loc14_ = 1;
               while(_loc14_ <= _loc9_)
               {
                  _loc13_.push([_loc6_["p" + _loc12_ + "_" + _loc14_]._x,_loc6_["p" + _loc12_ + "_" + _loc14_]._y]);
                  _loc14_ += 1;
               }
               _loc11_.push(_loc13_);
               _loc12_ += 1;
            }
            _loc15_ = 0;
            _loc16_ = 0;
            switch(decalArr[_loc4_].part)
            {
               case "side":
                  _loc15_ = 650;
                  _loc16_ = 187;
                  break;
               case "front":
                  _loc15_ = 300;
                  _loc16_ = 160;
                  break;
               case "back":
                  _loc15_ = 350;
                  _loc16_ = 150;
                  break;
               case "hood":
                  _loc15_ = 200;
                  _loc16_ = 200;
            }
            trace("scale scale scale scale scale scale: " + _loc6_.decalLoadin._xscale);
            _loc17_ = Math.floor(_loc6_.decalLoadin._width * 100 / _loc6_.decalLoadin._xscale);
            _loc18_ = Math.floor(_loc6_.decalLoadin._height * 100 / _loc6_.decalLoadin._yscale);
            _loc19_ = new flash.geom.Matrix(_loc15_ / _loc17_,0,0,_loc16_ / _loc18_,0,0);
            _loc6_.bmp = new flash.display.BitmapData(_loc15_,_loc16_,true,0);
            _loc6_.bmp.draw(_loc6_.decalLoadin,_loc19_,new flash.geom.ColorTransform(),null,null,true);
            if(_loc6_.decal == undefined)
            {
               _loc6_.createEmptyMovieClip("decal",_loc6_.getNextHighestDepth());
            }
            _loc20_ = new classes.DistordImageToMatrix(_loc6_.decal,_loc6_.bmp,_loc11_);
            switch(_loc6_.part)
            {
               case "side":
                  _loc6_.decalTextureMap(targetClip.body);
                  _loc6_.decalTextureMap(targetClip.skirt);
                  _loc6_.decalTextureMap(targetClip.sideEffect);
                  _loc6_.decalTextureMap(targetClip.doorEffect);
                  _loc6_.decalTextureMap(targetClip.fenderEffect);
                  _loc6_.decalTextureMap(targetClip.cPillarEffect);
                  if(!_loc6_.isBack)
                  {
                     _loc6_.decalTextureMap(targetClip.bumperRear);
                     _loc6_.decalTextureMap(targetClip.trunk);
                  }
                  if(targetClip.bodyOpp != undefined && targetClip.decalLoader.actual.sideOpp != undefined)
                  {
                     trace("************* IS exists **************");
                     _loc21_ = targetClip.decalLoader.actual.sideOpp;
                     _loc22_ = 0;
                     _loc23_ = 0;
                     for(_loc26_ in _loc21_)
                     {
                        if(typeof _loc21_[_loc26_] == "movieclip" && _loc26_.substr(0,1) == "p")
                        {
                           _loc10_ = _loc26_.substr(1).split("_");
                           if(parseInt(_loc10_[0],10) > _loc22_)
                           {
                              _loc22_ = parseInt(_loc10_[0],10);
                           }
                           if(parseInt(_loc10_[1],10) > _loc23_)
                           {
                              _loc23_ = parseInt(_loc10_[1],10);
                           }
                        }
                     }
                     _loc24_ = new Array();
                     _loc12_ = 1;
                     while(_loc12_ <= _loc22_)
                     {
                        _loc13_ = new Array();
                        _loc14_ = 1;
                        while(_loc14_ <= _loc23_)
                        {
                           _loc13_.push([_loc21_["p" + _loc12_ + "_" + _loc14_]._x,_loc21_["p" + _loc12_ + "_" + _loc14_]._y]);
                           _loc14_ += 1;
                        }
                        _loc24_.push(_loc13_);
                        _loc12_ += 1;
                     }
                     trace(_loc24_);
                     _loc20_ = new classes.DistordImageToMatrix(_loc6_.decal,_loc6_.bmp,_loc24_);
                     _loc6_.decalTextureMap(targetClip.bodyOpp);
                  }
                  _loc6_.bmp.dispose();
                  _loc6_.decal.removeMovieClip();
                  break;
               case "front":
                  _loc6_.decalTextureMap(targetClip.bumper);
                  _loc6_.bmp.dispose();
                  _loc6_.decal.removeMovieClip();
                  break;
               case "hood":
                  _loc6_.decalTextureMap(targetClip.hood);
                  _loc6_.bmp.dispose();
                  _loc6_.decal.removeMovieClip();
                  break;
               case "back":
                  _loc6_.decalTextureMap(targetClip.trunk);
                  _loc6_.decalTextureMap(targetClip.bumperRear);
                  _loc6_.bmp.dispose();
                  _loc6_.decal.removeMovieClip();
            }
         }
         _loc4_ += 1;
      }
   }
   static function plateView(targetClip, plateID, lic, scale, registerZero, adjustEuroScale)
   {
      if(!scale)
      {
         scale = 100;
      }
      if(adjustEuroScale && plateID > 7 && plateID < 11)
      {
         scale *= 0.7;
      }
      if(!lic.length)
      {
         lic = "";
      }
      var _loc2_ = new Object();
      _loc2_.onLoadComplete = function(target_mc)
      {
         var _loc2_ = classes.GlobalData.getPlateXML(plateID);
         target_mc.region = _loc2_.attributes.c;
         target_mc.id = _loc2_.attributes.i;
         var _loc3_ = lic.split("_");
         target_mc.seq1 = _loc3_[0];
         target_mc.seq2 = _loc3_[1];
         target_mc.seq3 = _loc3_[2];
         if(target_mc.region == "euro")
         {
            targetClip._xscale = targetClip._yscale = scale;
            if(registerZero)
            {
               target_mc._x = 0;
               target_mc._y = 0;
            }
         }
         else
         {
            targetClip._xscale = targetClip._yscale = scale;
            if(registerZero)
            {
               target_mc._x = -91;
               target_mc._y = 0;
            }
         }
      };
      var _loc3_ = new MovieClipLoader();
      _loc3_.addListener(_loc2_);
      if(targetClip.plateHolder == undefined)
      {
         targetClip.createEmptyMovieClip("plateHolder",targetClip.getNextHighestDepth());
      }
      _loc3_.loadClip("cache/car/plates.swf",targetClip.plateHolder);
   }
   static function drawPlateOnCar(cs, context, pid, lic)
   {
      trace("drawPlateOnCar");
      if(!pid)
      {
         pid = cs.plateID;
      }
      if(!lic)
      {
         lic = cs.lic;
      }
      if(!pid || !lic)
      {
         return undefined;
      }
      trace("drawPlateOnCar: " + pid + ", " + lic);
      if(context.plate == undefined)
      {
         context.createEmptyMovieClip("plate",context.getNextHighestDepth());
      }
      context.plate.transform.colorTransform = new flash.geom.ColorTransform(1,1,1,1,-80,-80,-80,0);
      var _loc6_ = context.bumperRear.actual;
      var _loc7_ = context.bumperRear._x;
      var _loc8_ = context.bumperRear._y;
      trace("plate MC: " + context._parent._parent._parent._parent._parent._name);
      if(context._parent._parent._parent._parent._parent._name == "carAni1")
      {
         if(pid >= 8 && pid <= 10)
         {
            var x1 = _loc7_ + _loc6_.e1._x;
            var y1 = _loc8_ + _loc6_.e1._y;
            var x0 = _loc7_ + _loc6_.e2._x;
            var y0 = _loc8_ + _loc6_.e2._y;
            var x3 = _loc7_ + _loc6_.e3._x;
            var y3 = _loc8_ + _loc6_.e3._y;
            var x2 = _loc7_ + _loc6_.e4._x;
            var y2 = _loc8_ + _loc6_.e4._y;
         }
         else
         {
            var x1 = _loc7_ + _loc6_.p1._x;
            var y1 = _loc8_ + _loc6_.p1._y;
            var x0 = _loc7_ + _loc6_.p2._x;
            var y0 = _loc8_ + _loc6_.p2._y;
            var x3 = _loc7_ + _loc6_.p3._x;
            var y3 = _loc8_ + _loc6_.p3._y;
            var x2 = _loc7_ + _loc6_.p4._x;
            var y2 = _loc8_ + _loc6_.p4._y;
         }
      }
      else if(pid >= 8 && pid <= 10)
      {
         var x0 = _loc7_ + _loc6_.e1._x;
         var y0 = _loc8_ + _loc6_.e1._y;
         var x1 = _loc7_ + _loc6_.e2._x;
         var y1 = _loc8_ + _loc6_.e2._y;
         var x2 = _loc7_ + _loc6_.e3._x;
         var y2 = _loc8_ + _loc6_.e3._y;
         var x3 = _loc7_ + _loc6_.e4._x;
         var y3 = _loc8_ + _loc6_.e4._y;
      }
      else
      {
         var x0 = _loc7_ + _loc6_.p1._x;
         var y0 = _loc8_ + _loc6_.p1._y;
         var x1 = _loc7_ + _loc6_.p2._x;
         var y1 = _loc8_ + _loc6_.p2._y;
         var x2 = _loc7_ + _loc6_.p3._x;
         var y2 = _loc8_ + _loc6_.p3._y;
         var x3 = _loc7_ + _loc6_.p4._x;
         var y3 = _loc8_ + _loc6_.p4._y;
      }
      var _loc9_ = classes.GlobalData.getPlateXML(pid);
      _root.platesHolder.region = _loc9_.attributes.c;
      _root.platesHolder.id = pid;
      var _loc10_ = lic.split("_");
      _root.platesHolder.seq1 = _loc10_[0];
      _root.platesHolder.seq2 = _loc10_[1];
      _root.platesHolder.seq3 = _loc10_[2];
      _root.platesHolder.init();
      var _loc11_ = _root.platesHolder.filters;
      var _loc12_ = new flash.filters.DropShadowFilter(4,120,0,0.8,4,4,1,2);
      _loc11_[0] = _loc12_;
      _root.platesHolder.filters = _loc11_;
      context.plate.onEnterFrame = function()
      {
         classes.Drawing.bmpObj.shopPlate.draw(_root.platesHolder,new flash.geom.Matrix(),new flash.geom.ColorTransform(),null,null,true);
         var _loc3_ = new classes.DistordImageB(this,classes.Drawing.bmpObj.shopPlate,2,2);
         trace([x0,y0,x1,y1,x2,y2,x3,y3]);
         _loc3_.setTransform(x0,y0,x1,y1,x2,y2,x3,y3);
         delete this.onEnterFrame;
      };
      classes.Drawing.bmpObj.shopPlate = new flash.display.BitmapData(414,120,true,0);
   }
   static function refreshPlateOnCar(plateMC, pid, lic)
   {
      function onTO()
      {
         if(plateMC.plate != undefined)
         {
            clearInterval(toSI);
            classes.Drawing.bmpObj.shopPlate.fillRect(classes.Drawing.bmpObj.shopPlate.rectangle,0);
            classes.Drawing.bmpObj.shopPlate.draw(plateMC,new flash.geom.Matrix(),new flash.geom.ColorTransform(),null,null,true);
         }
      }
      var _loc3_ = classes.GlobalData.getPlateXML(pid);
      plateMC.region = _loc3_.attributes.c;
      plateMC.id = pid;
      var _loc4_ = lic.split("_");
      plateMC.seq1 = _loc4_[0];
      plateMC.seq2 = _loc4_[1];
      plateMC.seq3 = _loc4_[2];
      plateMC.init();
      var toSI = setInterval(onTO,50);
   }
   static function carLogo(targetClip, carID)
   {
      targetClip.loadMovie("cache/car/logo_" + carID + ".swf");
   }
   static function insetBox(_context, ww, hh, th, headerColor, winColor, winColor2, angle)
   {
      var _loc9_ = undefined;
      var _loc10_ = undefined;
      var _loc11_ = undefined;
      var _loc12_ = angle <= 0 ? 0 : angle;
      var _loc13_ = 5;
      var _loc14_ = th <= _loc13_ ? _loc13_ : th;
      with(_context)
      {
         _loc9_ = undefined;
         if(headerColor > 0 || headerColor === 0)
         {
            _loc9_ = headerColor;
         }
         else
         {
            _loc9_ = 16777215;
         }
         _loc10_ = undefined;
         if(winColor > 0 || winColor === 0)
         {
            _loc10_ = winColor;
         }
         else
         {
            _loc10_ = 16777215;
         }
         _loc11_ = undefined;
         if(winColor2 > 0 || winColor === 0)
         {
            _loc11_ = winColor2;
         }
         clear();
         lineStyle(undefined,0,100);
         beginFill(_loc9_);
         moveTo(_loc13_,0);
         lineTo(ww - _loc13_,0);
         curveTo(ww,0,ww,_loc13_);
         lineTo(ww,_loc14_);
         lineTo(0,_loc14_);
         lineTo(0,_loc13_);
         curveTo(0,0,_loc13_,0);
         endFill();
         moveTo(ww,_loc14_);
         if(_loc11_ != undefined)
         {
            colors = [_loc10_,_loc11_];
            alphas = [100,100];
            ratios = [0,255];
            matrix = {matrixType:"box",x:10,y:10,w:ww - 10,h:hh - 10,r:_loc12_ / 180 * 3.141592653589793};
            beginGradientFill("linear",colors,alphas,ratios,matrix);
         }
         else
         {
            beginFill(_loc10_);
         }
         lineTo(ww,hh - _loc13_);
         curveTo(ww,hh,ww - _loc13_,hh);
         lineTo(_loc13_,hh);
         curveTo(0,hh,0,hh - _loc13_);
         lineTo(0,_loc14_);
         lineTo(ww,_loc14_);
         endFill();
      }
   }
   static function applyInsetBoxFilters(subject)
   {
      var _loc2_ = new flash.filters.DropShadowFilter(5,90,0,0.6,20,20,1,2,true);
      var _loc3_ = new flash.filters.BevelFilter(3,100,0,1,0,1,2,0,1,1,"outer");
      var _loc4_ = new flash.filters.BevelFilter(3,0,0,1,1976107,1,0,0,1,1,"outer");
      var _loc5_ = [];
      _loc5_[0] = _loc2_;
      _loc5_[1] = _loc3_;
      _loc5_[2] = _loc4_;
      subject.filters = _loc5_;
   }
   static function insetBoxBuddies(_context, ww, hh, th, headerColor, winColor, winColor2, angle, tabPos, tabWidth)
   {
      if(!tabPos)
      {
         tabPos = 15;
      }
      if(!tabWidth)
      {
         tabWidth = 54;
      }
      var _loc11_ = undefined;
      var _loc12_ = undefined;
      var _loc13_ = undefined;
      var _loc14_ = angle <= 0 ? 0 : angle;
      var _loc15_ = 0;
      var _loc16_ = th <= _loc15_ ? _loc15_ : th;
      with(_context)
      {
         _loc11_ = undefined;
         if(headerColor > 0 || headerColor === 0)
         {
            _loc11_ = headerColor;
         }
         else
         {
            _loc11_ = 16777215;
         }
         _loc12_ = undefined;
         if(winColor > 0 || winColor === 0)
         {
            _loc12_ = winColor;
         }
         else
         {
            _loc12_ = 16777215;
         }
         _loc13_ = undefined;
         if(winColor2 > 0 || winColor === 0)
         {
            _loc13_ = winColor2;
         }
         clear();
         lineStyle(undefined,0,100);
         beginFill(_loc11_);
         moveTo(_loc15_,0);
         lineTo(ww - _loc15_,0);
         curveTo(ww,0,ww,_loc15_);
         lineTo(ww,_loc16_);
         lineTo(0,_loc16_);
         lineTo(0,_loc15_);
         curveTo(0,0,_loc15_,0);
         endFill();
         moveTo(ww,_loc16_);
         if(_loc13_ != undefined)
         {
            colors = [_loc12_,_loc13_];
            alphas = [100,100];
            ratios = [0,255];
            matrix = {matrixType:"box",x:10,y:10,w:ww - 10,h:hh - 10,r:_loc14_ / 180 * 3.141592653589793};
            beginGradientFill("linear",colors,alphas,ratios,matrix);
         }
         else
         {
            beginFill(_loc12_);
         }
         lineTo(ww,hh - _loc15_);
         curveTo(ww,hh,ww - _loc15_,hh);
         lineTo(_loc15_,hh);
         curveTo(0,hh,0,hh - _loc15_);
         lineTo(0,_loc16_);
         lineTo(tabPos,_loc16_);
         lineTo(tabPos,_loc16_ - 15);
         curveTo(tabPos,_loc16_ - 18,tabPos + 3,_loc16_ - 18);
         lineTo(tabPos + tabWidth - 3,_loc16_ - 18);
         curveTo(tabPos + tabWidth,_loc16_ - 18,tabPos + tabWidth,_loc16_ - 15);
         lineTo(tabPos + tabWidth,_loc16_);
         lineTo(ww,_loc16_);
         endFill();
      }
   }
   static function standardText(_context, fldName, pText, x, y, alpha, pAutoSize, tf)
   {
      if(!fldName.length)
      {
         fldName = "newTextField" + _context.getNextHighestDepth();
      }
      if(!x)
      {
         x = 0;
      }
      if(!y)
      {
         y = 0;
      }
      if(!alpha && alpha !== 0)
      {
         alpha = 100;
      }
      if(!pAutoSize.length || pAutoSize == "true")
      {
         pAutoSize = "left";
      }
      if(!tf)
      {
         tf = new TextFormat();
         tf.font = "Arial";
         tf.size = 11;
         tf.color = 16777215;
      }
      var _loc9_ = _context.createTextField(fldName,_context.getNextHighestDepth(),x,y,5,5);
      _loc9_.selectable = false;
      _loc9_.embedFonts = true;
      _loc9_.autoSize = pAutoSize;
      _loc9_.setNewTextFormat(tf);
      _loc9_._alpha = alpha;
      _loc9_.text = pText;
   }
   static function roundedRect(_context, pWidth, pHeight, cRad, fillColor, alpha, offsetX, offsetY)
   {
      if(!fillColor)
      {
         fillColor = 16777215;
      }
      if(!alpha)
      {
         alpha = 100;
      }
      if(!offsetX)
      {
         offsetX = 0;
      }
      if(!offsetY)
      {
         offsetY = 0;
      }
      with(_context)
      {
         beginFill(fillColor,alpha);
         moveTo(offsetX + cRad,offsetY);
         lineTo(offsetX + pWidth - cRad,offsetY);
         curveTo(offsetX + pWidth,offsetY,offsetX + pWidth,offsetY + cRad);
         lineTo(offsetX + pWidth,offsetY + pHeight - cRad);
         curveTo(offsetX + pWidth,offsetY + pHeight,offsetX + pWidth - cRad,offsetY + pHeight);
         lineTo(offsetX + cRad,offsetY + pHeight);
         curveTo(offsetX,offsetY + pHeight,offsetX,offsetY + pHeight - cRad);
         lineTo(offsetX,offsetY + cRad);
         curveTo(offsetX,offsetY,offsetX + cRad,offsetY);
         endFill();
      }
   }
   static function rect(_context, pWidth, pHeight, fillColor, alpha, offsetX, offsetY, cRad, lineWeight, lineColor, lineAlpha)
   {
      if(fillColor == undefined)
      {
         fillColor = 16777215;
      }
      else if(fillColor == -1)
      {
         fillColor;
      }
      if(!alpha && alpha !== 0)
      {
         alpha = 100;
      }
      if(!offsetX)
      {
         offsetX = 0;
      }
      if(!offsetY)
      {
         offsetY = 0;
      }
      if(!cRad)
      {
         cRad = 0;
      }
      with(_context)
      {
         if(lineWeight || lineWeight === 0)
         {
            lineStyle(lineWeight,lineColor,lineAlpha);
         }
         beginFill(fillColor,alpha);
         moveTo(offsetX + cRad,offsetY);
         lineTo(offsetX + pWidth - cRad,offsetY);
         curveTo(offsetX + pWidth,offsetY,offsetX + pWidth,offsetY + cRad);
         lineTo(offsetX + pWidth,offsetY + pHeight - cRad);
         curveTo(offsetX + pWidth,offsetY + pHeight,offsetX + pWidth - cRad,offsetY + pHeight);
         lineTo(offsetX + cRad,offsetY + pHeight);
         curveTo(offsetX,offsetY + pHeight,offsetX,offsetY + pHeight - cRad);
         lineTo(offsetX,offsetY + cRad);
         curveTo(offsetX,offsetY,offsetX + cRad,offsetY);
         endFill();
         lineStyle(undefined);
      }
   }
   static function applyMainShad(subject)
   {
      var _loc2_ = new flash.filters.DropShadowFilter(23,45,0,0.6,29,29,1,2);
      var _loc3_ = [];
      _loc3_.push(_loc2_);
      subject.filters = _loc3_;
   }
   static function addToCarQueue(qObj)
   {
      trace("addToCarQueue");
      classes.Drawing.drawCarQueue.push(qObj);
      if(_root.amCarQueue == undefined)
      {
         _root.amCarQueue = _root.createEmptyMovieClip("amCarQueue",_root.getNextHighestDepth());
      }
      _root.amCarQueue.onEnterFrame = function()
      {
         var _loc2_ = undefined;
         if(classes.Drawing.drawCarQueue.length)
         {
            _loc2_ = classes.Drawing.drawCarQueue[0];
            classes.Drawing.drawCarView(_loc2_.targetClip,_loc2_.carXML,_loc2_.scale,_loc2_.view,_loc2_.override);
            classes.Drawing.drawCarQueue.splice(0,1);
         }
         else
         {
            delete this.onEnterFrame;
         }
      };
   }
   static function carView(targetClip, carXML, scale, view, override)
   {
      trace("carView: ");
      trace("scale: " + scale);
      trace("view: " + view);
      var _loc6_ = undefined;
      if(targetClip)
      {
         _loc6_ = new Object();
         _loc6_.targetClip = targetClip;
         _loc6_.carXML = carXML;
         _loc6_.scale = scale;
         _loc6_.view = view;
         _loc6_.override = override;
         classes.Drawing.addToCarQueue(_loc6_);
      }
   }
   static function drawCarView(targetClip, carXML, scale, view, override)
   {
      var _loc3_ = Number(carXML.firstChild.attributes.ci);
      if(!scale)
      {
         scale = 100;
      }
      classes.Drawing.clearCarView(targetClip);
      targetClip._visible = false;
      var isBack;
      var _loc4_ = undefined;
      var _loc5_ = undefined;
      var _loc6_ = "F";
      if(view == "back" || view == "race" || view == "dyno" || view == "spectate")
      {
         isBack = true;
         _loc6_ = "B";
      }
      var drawSmooth = true;
      if(view == "dyno")
      {
         _loc4_ = true;
         view = "race";
      }
      else if(view == "race")
      {
         if(classes.GlobalData.prefsObj.raceQuality < 5)
         {
            drawSmooth = false;
         }
      }
      else if(view == "spectate")
      {
         if(classes.GlobalData.prefsObj.spectateQuality < 5)
         {
            drawSmooth = false;
         }
         _loc5_ = true;
         view = "race";
      }
      var isPlaceholder;
      var frac = scale / 100;
      var _loc7_ = targetClip.createEmptyMovieClip("carLoadin",targetClip.getNextHighestDepth());
      var _loc8_ = undefined;
      var _loc9_ = undefined;
      var _loc10_ = undefined;
      var _loc11_ = undefined;
      var _loc12_ = undefined;
      var _loc13_ = undefined;
      var _loc14_ = undefined;
      var _loc15_ = undefined;
      var _loc16_ = undefined;
      var _loc17_ = undefined;
      if(view == "race" && !_loc5_ && !_loc4_ && classes.GlobalData.prefsObj.raceQuality == 1 || _loc5_ && classes.GlobalData.prefsObj.spectateQuality == 1)
      {
         _loc9_ = new Object();
         _loc9_.onLoadInit = function(mc)
         {
            targetClip._xscale = -100;
            targetClip._x += 600;
            targetClip._visible = true;
         };
         _loc9_.onLoadError = function(mc)
         {
         };
         _loc8_ = targetClip.createEmptyMovieClip("carBody",targetClip.getNextHighestDepth());
         _loc10_ = new MovieClipLoader();
         _loc10_.addListener(_loc9_);
         _loc10_.loadClip("cache/car/packages/" + _loc3_ + "b/line.swf",_loc8_);
      }
      else if(view == "race" && !_loc5_ && !_loc4_ && classes.GlobalData.prefsObj.raceQuality == 0)
      {
         targetClip.createEmptyMovieClip("carBody",targetClip.getNextHighestDepth());
      }
      else
      {
         trace("Regular view");
         _loc8_ = targetClip.createEmptyMovieClip("carBody",targetClip.getNextHighestDepth());
         var cc;
         var cs = new classes.CarSpecs();
         if(override)
         {
            cs = override.cs;
            _loc3_ = override.carID;
         }
         else
         {
            cs.applyCarXML(carXML);
         }
         var checkLoaded = function()
         {
            var _loc1_ = true;
            var _loc2_ = 0;
            while(_loc2_ < arrMCL.length)
            {
               if(!arrMCL[_loc2_].mc.isLoaded)
               {
                  _loc1_ = false;
                  break;
               }
               _loc2_ += 1;
            }
            if(_loc1_)
            {
               trace("isAllLoaded!!!");
               targetClip.carLoadin.wheelF._x = targetClip.carLoadin.tireF._x;
               targetClip.carLoadin.wheelF._y = targetClip.carLoadin.tireF._y;
               targetClip.carLoadin.wheelR._x = targetClip.carLoadin.tireR._x;
               targetClip.carLoadin.wheelR._y = targetClip.carLoadin.tireR._y;
               targetClip.carLoadin.wheelF._xscale = targetClip.carLoadin.tireF._xscale;
               targetClip.carLoadin.wheelF._yscale = targetClip.carLoadin.tireF._yscale;
               trace(targetClip.carLoadin.wheelF._xscale);
               targetClip.carLoadin.wheelR._xscale = targetClip.carLoadin.tireR._xscale;
               targetClip.carLoadin.wheelR._yscale = targetClip.carLoadin.tireR._yscale;
               _loc2_ = 0;
               while(_loc2_ < cs.decalArr.length)
               {
                  if(cs.decalArr[_loc2_].catID == 146)
                  {
                     targetClip.carLoadin["146"].paint.hood.gotoAndStop(cs.hoodID);
                     targetClip.carLoadin["146"].paint.skirt.gotoAndStop(cs.skirtID);
                     targetClip.carLoadin["146"].paint.bumper.gotoAndStop(cs.bumperID);
                     targetClip.carLoadin["146"].paint.bumperRear.gotoAndStop(cs.bumperRearID);
                     break;
                  }
                  _loc2_ += 1;
               }
               if(isBack)
               {
                  classes.Drawing.drawPlateOnCar(cs,targetClip.carLoadin);
               }
               loadTheRest();
            }
         };
         var checkLoadedPhaseTwo = function()
         {
            if(targetClip.carLoadin.tireF.actual.isLoaded && targetClip.carLoadin.tireR.actual.isLoaded)
            {
               if(isBack)
               {
                  if(!targetClip.carLoadin.tireBack.isLoaded && !targetClip.carLoadin.tireBack.isMissing)
                  {
                     return undefined;
                  }
               }
               if(view == "race" && (!targetClip.carBody.wheelF.isLoaded || !targetClip.carBody.wheelR.isLoaded))
               {
                  return undefined;
               }
               trace("checkLoadedTwo DONE!");
               targetClip._visible = true;
               for(var _loc1_ in targetClip.carLoadin)
               {
                  targetClip.carLoadin[_loc1_]._visible = true;
               }
               cc = new classes.CarConstruction(targetClip.carLoadin,isBack);
               if(view == "race")
               {
                  cc.setCar(cs,true);
               }
               else
               {
                  cc.setCar(cs,false,scale);
               }
               if(!isPlaceholder)
               {
                  classes.Drawing.drawDecalsOnCar(targetClip.carLoadin,cs.decalArr,cc.coreYAdj,isBack);
               }
               finishCar();
               snapshotCar();
            }
         };
         var finishCar = function()
         {
            trace("finishCar: " + view);
            classes.Drawing.clearCarBmps();
            targetClip.snapshot = new flash.display.BitmapData(Math.ceil(640 * frac),Math.ceil(400 * frac),true,0);
            classes.Drawing.aryCarDrawings.push(targetClip,targetClip.snapshot);
            targetClip.carBody.attachBitmap(targetClip.snapshot,targetClip.carBody.getNextHighestDepth(),"always",drawSmooth);
            targetClip.carBody.wheelF.swapDepths(targetClip.carBody.getNextHighestDepth());
            targetClip.carBody.wheelR.swapDepths(targetClip.carBody.getNextHighestDepth());
            if(view == "race")
            {
               targetClip.carLoadin.tireF._x += frac * 18;
            }
            var _loc1_ = targetClip.carLoadin.createEmptyMovieClip("tireMaskAddF",targetClip.carLoadin.getNextHighestDepth());
            var _loc2_ = targetClip.carLoadin.createEmptyMovieClip("tireMaskAddR",targetClip.carLoadin.getNextHighestDepth());
            _loc1_._x = targetClip.carLoadin.wheelMaskAddF._x;
            _loc1_._y = targetClip.carLoadin.wheelMaskAddF._y;
            _loc2_._x = targetClip.carLoadin.wheelMaskAddR._x;
            _loc2_._y = targetClip.carLoadin.wheelMaskAddR._y;
            classes.Drawing.rect(_loc1_,targetClip.carLoadin.wheelMaskAddF._width,targetClip.carLoadin.wheelMaskAddF._height);
            classes.Drawing.rect(_loc2_,targetClip.carLoadin.wheelMaskAddR._width,targetClip.carLoadin.wheelMaskAddR._height);
            var _loc3_ = undefined;
            var _loc4_ = undefined;
            if(view == "race")
            {
               _loc3_ = targetClip.carBody.wheelF;
               _loc4_ = targetClip.carBody.wheelR;
               _loc3_._x = targetClip.carLoadin.wheelF._x + frac * 18;
               _loc3_._y = targetClip.carLoadin.wheelF._y;
               _loc4_._x = targetClip.carLoadin.wheelR._x;
               _loc4_._y = targetClip.carLoadin.wheelR._y;
               _loc3_._xscale = targetClip.carLoadin.wheelF._xscale;
               _loc3_._yscale = targetClip.carLoadin.wheelF._yscale;
               _loc4_._xscale = targetClip.carLoadin.wheelR._xscale;
               _loc4_._yscale = targetClip.carLoadin.wheelR._yscale;
               _loc3_._visible = true;
               _loc4_._visible = true;
               trace("race scale: ");
               trace(_loc3_._xscale);
               trace(_loc3_._yscale);
            }
         };
         var addToSnapshot = function(src, scaleFrac)
         {
            var _loc3_ = new flash.geom.Matrix();
            _loc3_.a = _loc3_.d = scaleFrac;
            _loc3_.tx = frac * src._x;
            _loc3_.ty = frac * src._y;
            targetClip.snapshot.draw(src,_loc3_,new flash.geom.ColorTransform(),"normal",null,true);
         };
         var snapshotCar = function()
         {
            trace("snapshotCar: " + view + ", " + frac);
            if(!isBack)
            {
               targetClip.carLoadin.body.actual.racerNumRev.swapDepths(targetClip.carLoadin.body.actual.getNextHighestDepth());
               targetClip.carLoadin.body.actual.racerNum.swapDepths(targetClip.carLoadin.body.actual.getNextHighestDepth());
            }
            targetClip.snapshot.fillRect(targetClip.snapshot.rectangle,0);
            addToSnapshot(targetClip.carLoadin.shadow,frac);
            addToSnapshot(targetClip.carLoadin.underCarriage,frac);
            targetClip.carLoadin.tireF.setMask(null);
            targetClip.carLoadin.tireR.setMask(null);
            targetClip.carLoadin.wheelF.setMask(null);
            targetClip.carLoadin.wheelR.setMask(null);
            addToSnapshot(targetClip.carLoadin.tireR,frac * targetClip.carLoadin.tireR._yscale / 100);
            var _loc2_ = new flash.geom.Matrix();
            _loc2_.a = frac * targetClip.carLoadin.tireF._xscale / 100;
            _loc2_.d = frac * targetClip.carLoadin.tireF._yscale / 100;
            _loc2_.tx = frac * targetClip.carLoadin.tireF._x;
            _loc2_.ty = frac * targetClip.carLoadin.tireF._y;
            targetClip.snapshot.draw(targetClip.carLoadin.tireF,_loc2_,new flash.geom.ColorTransform(),"normal",null,true);
            if(view != "race")
            {
               addToSnapshot(targetClip.carLoadin.wheelF,frac * targetClip.carLoadin.wheelF._yscale / 100);
               addToSnapshot(targetClip.carLoadin.wheelR,frac * targetClip.carLoadin.wheelR._yscale / 100);
            }
            targetClip.carLoadin.tireF.setMask(targetClip.carLoadin.tireMaskAddF);
            targetClip.carLoadin.tireR.setMask(targetClip.carLoadin.tireMaskAddR);
            if(view != "race")
            {
               targetClip.carLoadin.wheelF.setMask(targetClip.carLoadin.wheelMaskAddF);
               targetClip.carLoadin.wheelR.setMask(targetClip.carLoadin.wheelMaskAddR);
            }
            var _loc3_ = new Array("underCarriage","shadow","decalLoader",146,148,149,150,151,160,161,162,163);
            var _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               targetClip.carLoadin[_loc3_[_loc4_]]._visible = false;
               _loc4_ += 1;
            }
            if(view == "race")
            {
               targetClip.carLoadin.wheelF._visible = false;
               targetClip.carLoadin.wheelR._visible = false;
            }
            targetClip.carLoadin.cacheAsBitmap = true;
            addToSnapshot(targetClip.carLoadin,frac);
            targetClip.carBody._visible = true;
            targetClip._visible = true;
            if(isPlaceholder)
            {
               targetClip.carLoadin._visible = false;
               _loc4_ = 0;
               while(_loc4_ < targetClip.uggWaitArr.length)
               {
                  _root.downloadUgg(targetClip.uggWaitArr[_loc4_].decalObj.path,targetClip);
                  _loc4_ += 1;
               }
               targetClip.carBody.transform.colorTransform = new flash.geom.ColorTransform(0.3,0.3,0.3,1,0,0,0,0);
               isPlaceholder = false;
            }
            else
            {
               for(var _loc5_ in targetClip.carLoadin)
               {
                  targetClip.carLoadin[_loc5_].actual.bmp.dispose();
               }
               targetClip.carLoadin.removeMovieClip();
            }
            if(targetClip._parent._parent._parent._parent._name.substr(0,6) == "carAni")
            {
               targetClip.flip();
            }
            targetClip.loaded = true;
         };
         var loadTheRest = function()
         {
            trace("loadTheRest");
            if(view == "front" && targetClip.racerNumSeq)
            {
               if(targetClip.isReversed)
               {
                  targetClip.carLoadin.body.actual.racerNumRev.txt = targetClip.racerNumSeq;
               }
               else
               {
                  targetClip.carLoadin.body.actual.racerNum.txt = targetClip.racerNumSeq;
               }
            }
            var _loc1_ = new MovieClipLoader();
            var _loc2_ = new MovieClipLoader();
            _loc1_.addListener(telPhase2);
            _loc2_.addListener(telPhase2);
            var _loc3_ = undefined;
            if(!targetClip.carLoadin.tireBack.isMissing)
            {
               _loc3_ = new MovieClipLoader();
               _loc3_.addListener(telPhase2);
               _loc3_.loadClip("cache/car/wheel/tireBack.swf",targetClip.carLoadin.tireBack);
            }
            var _loc4_ = undefined;
            var _loc5_ = undefined;
            var _loc6_ = undefined;
            var _loc7_ = undefined;
            if(view == "race")
            {
               _loc1_.loadClip("cache/car/wheel/tireF.swf",targetClip.carLoadin.tireF.actual);
               _loc2_.loadClip("cache/car/wheel/tireR.swf",targetClip.carLoadin.tireR.actual);
               _loc4_ = targetClip.carBody.createEmptyMovieClip("wheelF",targetClip.carBody.getNextHighestDepth());
               _loc5_ = targetClip.carBody.createEmptyMovieClip("wheelR",targetClip.carBody.getNextHighestDepth());
               _loc4_._x = targetClip.carLoadin.wheelF._x;
               _loc4_._y = targetClip.carLoadin.wheelF._y;
               _loc5_._x = targetClip.carLoadin.wheelR._x;
               _loc5_._y = targetClip.carLoadin.wheelR._y;
               _loc4_._visible = false;
               _loc5_._visible = false;
               _loc6_ = new MovieClipLoader();
               _loc7_ = new MovieClipLoader();
               _loc6_.addListener(telPhase2);
               _loc7_.addListener(telPhase2);
               _loc6_.loadClip("cache/car/wheel/wheelR_" + cs.wheelFID + ".swf",_loc4_);
               _loc7_.loadClip("cache/car/wheel/wheelR_" + cs.wheelRID + ".swf",_loc5_);
            }
            else
            {
               _loc1_.loadClip("cache/car/wheel/tire" + (!isBack ? "F" : "B") + "F_" + cs.tiresID + ".swf",targetClip.carLoadin.tireF.actual);
               _loc2_.loadClip("cache/car/wheel/tire" + (!isBack ? "F" : "B") + "R_" + cs.tiresID + ".swf",targetClip.carLoadin.tireR.actual);
            }
         };
         _loc11_ = new Object();
         _loc11_.onLoadInit = function(mc)
         {
            mc._visible = false;
            if(mc._name != 146 && mc._name != 148 && mc._name != 149 && mc._name != 150 && mc._name != 151 && mc._name != 160 && mc._name != 161 && mc._name != 162 && mc._name != 163 && mc._name != "wheelF" && mc._name != "wheelR")
            {
               for(var _loc2_ in mc)
               {
                  if(typeof mc[_loc2_] == "movieclip")
                  {
                     mc[_loc2_]._name = "actual";
                  }
               }
               if(mc._name != "decalLoader")
               {
                  mc._x = mc.actual.tx;
                  mc._y = mc.actual.ty;
                  mc._xscale = mc.actual.scx;
                  mc._yscale = mc.actual.scy;
               }
            }
            trace("movieclip loaded: " + mc._name);
            mc.isLoaded = true;
            checkLoaded();
         };
         _loc11_.onLoadError = function(mc)
         {
            mc.isLoaded = true;
            mc.isMissing = true;
            var _loc1_ = undefined;
            var _loc2_ = undefined;
            if(mc._name == 160 || mc._name == 161 || mc._name == 162 || mc._name == 163)
            {
               isPlaceholder = true;
               if(!targetClip.uggWaitArr)
               {
                  targetClip.uggWaitArr = new Array();
               }
               _loc2_ = arrMCL.length - 1;
               while(_loc2_ >= 0)
               {
                  if(arrMCL[_loc2_].mc == mc)
                  {
                     _loc1_ = arrMCL[_loc2_].decalObj;
                     break;
                  }
                  _loc2_ -= 1;
               }
               targetClip.uggWaitArr.push({cname:mc._name,mc:mc,decalObj:_loc1_});
               targetClip.uggOnRetrieve = function(cname, isNewFileAvailable)
               {
                  trace("uggOnRetrieve..." + cname);
                  var _loc3_ = 0;
                  var _loc4_ = undefined;
                  var _loc5_ = undefined;
                  while(_loc3_ < targetClip.uggWaitArr.length)
                  {
                     if(cname == targetClip.uggWaitArr[_loc3_].cname)
                     {
                        trace("found in uggWaitArr");
                        if(!isNewFileAvailable)
                        {
                           targetClip.uggWaitArr[_loc3_].mc.isUpdated = true;
                           targetClip.checkUggUpdate();
                           return undefined;
                        }
                        _loc4_ = new MovieClipLoader();
                        _loc5_ = new Object();
                        _loc5_.onLoadInit = function(mc)
                        {
                           trace("onUgg.onLoadInit: " + mc._name);
                           mc._visible = false;
                           mc.isUpdated = true;
                           targetClip.checkUggUpdate();
                        };
                        _loc5_.onLoadError = function(mc)
                        {
                           trace("onLoadError: " + mc._name);
                           mc.isUpdated = true;
                           targetClip.checkUggUpdate();
                        };
                        _loc4_.addListener(_loc5_);
                        _loc4_.loadClip(targetClip.uggWaitArr[_loc3_].decalObj.path,targetClip.carLoadin[cname]);
                        break;
                     }
                     _loc3_ += 1;
                  }
               };
               targetClip.checkUggUpdate = function()
               {
                  var _loc1_ = true;
                  var _loc2_ = 0;
                  while(_loc2_ < targetClip.uggWaitArr.length)
                  {
                     if(!targetClip.uggWaitArr[_loc2_].mc.isUpdated)
                     {
                        _loc1_ = false;
                        break;
                     }
                     _loc2_ += 1;
                  }
                  if(_loc1_)
                  {
                     trace("isAllUpdated");
                     classes.Drawing.drawDecalsOnCar(targetClip.carLoadin,cs.decalArr,cc.coreYAdj,isBack);
                     snapshotCar();
                     targetClip.carBody.transform.colorTransform = new flash.geom.ColorTransform(1,1,1,1,0,0,0,0);
                  }
                  else
                  {
                     trace("is NOT allUpdated");
                  }
               };
            }
         };
         var telPhase2 = new Object();
         telPhase2.onLoadInit = function(mc)
         {
            trace("telPhase2.onLoadInit: " + mc._name);
            mc.isLoaded = true;
            checkLoadedPhaseTwo();
         };
         telPhase2.onLoadError = function(mc)
         {
            trace("onLoadError: " + mc._name);
            mc.isLoaded = true;
            checkLoadedPhaseTwo();
         };
         var arrMCL = new Array();
         _loc12_ = 0;
         while(_loc12_ < cs.decalArr.length)
         {
            arrMCL.push({decalObj:cs.decalArr[_loc12_],cname:cs.decalArr[_loc12_].catID,mc:_loc7_.createEmptyMovieClip(cs.decalArr[_loc12_].catID,_loc7_.getNextHighestDepth()),mcl:new MovieClipLoader()});
            _loc12_ += 1;
         }
         arrMCL.push({cname:"decalLoader",mc:_loc7_.createEmptyMovieClip("decalLoader",_loc7_.getNextHighestDepth()),mcl:new MovieClipLoader()});
         _loc13_ = !isBack ? classes.Drawing.loadPartsArr : classes.Drawing.loadPartsBackArr;
         _loc14_ = !isBack ? classes.Drawing.optionalPartsArr : classes.Drawing.optionalPartsBackArr;
         _loc12_ = 0;
         while(_loc12_ < _loc13_.length)
         {
            _loc15_ = false;
            _loc16_ = 0;
            while(_loc16_ < _loc14_.length)
            {
               if(_loc13_[_loc12_] == _loc14_[_loc16_])
               {
                  _loc15_ = true;
                  break;
               }
               _loc16_ += 1;
            }
            if(!_loc15_ || _loc15_ && cs[_loc13_[_loc12_] + "ID"] > 0)
            {
               trace("adding part: " + _loc13_[_loc12_] + ", " + cs[_loc13_[_loc12_] + "ID"]);
               arrMCL.push({cname:_loc13_[_loc12_],mc:_loc7_.createEmptyMovieClip(_loc13_[_loc12_],_loc7_.getNextHighestDepth()),mcl:new MovieClipLoader()});
            }
            _loc12_ += 1;
         }
         arrMCL.push({cname:"wheelF",mc:_loc7_.createEmptyMovieClip("wheelF",_loc7_.getNextHighestDepth()),mcl:new MovieClipLoader()});
         arrMCL.push({cname:"wheelR",mc:_loc7_.createEmptyMovieClip("wheelR",_loc7_.getNextHighestDepth()),mcl:new MovieClipLoader()});
         _loc12_ = 0;
         while(_loc12_ < arrMCL.length)
         {
            arrMCL[_loc12_].mcl.addListener(_loc11_);
            if(arrMCL[_loc12_].decalObj)
            {
               if(arrMCL[_loc12_].decalObj.localPath == undefined)
               {
                  if(arrMCL[_loc12_].decalObj.isUGG)
                  {
                     arrMCL[_loc12_].decalObj.path = "cache/car/userDecals/" + arrMCL[_loc12_].decalObj.catID + "_" + arrMCL[_loc12_].decalObj.di + ".swf";
                     _loc17_ = arrMCL[_loc12_].decalObj.path;
                  }
                  else
                  {
                     _loc17_ = "cache/car/decals/" + arrMCL[_loc12_].decalObj.parentdi + "_" + arrMCL[_loc12_].decalObj.part + (!(arrMCL[_loc12_].decalObj.part == "full" && isBack) ? "" : "_b") + ".swf";
                  }
                  arrMCL[_loc12_].mcl.loadClip(_loc17_,arrMCL[_loc12_].mc);
               }
               else
               {
                  arrMCL[_loc12_].mc = arrMCL[_loc12_].decalObj.localPath;
                  arrMCL[_loc12_].mc.isLoaded = true;
                  trace("decal localPath clip: " + arrMCL[_loc12_].mc);
                  checkLoaded();
               }
            }
            else if(arrMCL[_loc12_].cname == "wheelF" || arrMCL[_loc12_].cname == "wheelR")
            {
               arrMCL[_loc12_].mcl.loadClip("cache/car/wheel/wheel" + (!isBack ? "F" : "B") + arrMCL[_loc12_].cname.substr(5,1) + "_" + cs.wheelRID + ".swf",arrMCL[_loc12_].mc);
            }
            else
            {
               trace("cache/car/packages/" + _loc3_ + (!isBack ? "f" : "b") + "/" + arrMCL[_loc12_].cname + ".swf");
               arrMCL[_loc12_].mcl.loadClip("cache/car/packages/" + _loc3_ + (!isBack ? "f" : "b") + "/" + arrMCL[_loc12_].cname + ".swf",arrMCL[_loc12_].mc);
            }
            _loc12_ += 1;
         }
      }
      targetClip.clearCarView = function()
      {
         targetClip.snapshot.dispose();
         delete targetClip.snapshot;
         targetClip.carBody.removeMovieClip();
         classes.Drawing.clearThisCarsBmps(targetClip);
         classes.ClipFuncs.removeAllClips(targetClip);
      };
      targetClip.flip = function()
      {
         var _loc2_ = this._xscale / 100;
         var _loc3_ = this._xscale / Math.abs(this._xscale);
         this._xscale *= -1;
         trace("flip...");
         trace(_loc3_);
         trace(_loc2_);
         trace(this._xscale);
         targetClip._x += _loc3_ * _loc2_ * 600;
      };
   }
   static function clearCarView(context)
   {
      context.snapshot.dispose();
      delete context.snapshot;
      classes.Drawing.clearThisCarsBmps(context);
      classes.ClipFuncs.removeAllClips(context);
   }
}
