class classes.mc.Bubble extends MovieClip
{
   var bubbleText;
   var my_fmt;
   var matrix;
   var bubbleBG;
   var avatar;
   var bubbleClose;
   var bubXMid;
   var bubYMid;
   var btnNext;
   var offsetX = 0;
   var offsetY = 0;
   var cRad = 10;
   var lineWeight = 1;
   var lineColor = 13158;
   var lineAlpha = 75;
   var fillColor1 = 15530238;
   var alpha1 = 100;
   var fillColor2 = 10465465;
   var alpha2 = 100;
   var fillType = "linear";
   var colors = [classes.mc.Bubble.prototype.fillColor1,classes.mc.Bubble.prototype.fillColor2];
   var alphas = [classes.mc.Bubble.prototype.alpha1,classes.mc.Bubble.prototype.alpha2];
   var ratios = [0,255];
   var rot = 90;
   var angle = classes.mc.Bubble.prototype.rot * 3.141592653589793 / 180;
   function Bubble()
   {
      super();
   }
   function createBubble(pX, pY, bX, bY, txt, onCreate, onCreateParam)
   {
      this.setText(txt);
      this.drawBubble(bX,bY);
      this.drawPointer(pX - bX,pY - bY);
      if(onCreate != undefined)
      {
         trace("onCreate is not undefined!");
         trace(onCreateParam);
         onCreate(onCreateParam);
      }
   }
   function setText(t)
   {
      this.clearOldBubble();
      this.createTextField("bubbleText",2,55,10,200,10);
      this.bubbleText.autoSize = true;
      this.bubbleText.wordWrap = true;
      this.bubbleText.multiline = true;
      this.bubbleText.embedFonts = true;
      this.bubbleText.selectable = false;
      this.bubbleText.text = t;
      this.my_fmt = new TextFormat();
      this.my_fmt.font = "Arial";
      this.my_fmt.size = 11;
      this.my_fmt.color = 5466225;
      this.bubbleText.setTextFormat(this.my_fmt);
   }
   function drawBubble(bX, bY, pX, pY)
   {
      this._x = bX;
      this._y = bY;
      var _loc6_ = this.bubbleText._width + 80;
      var _loc7_ = Math.max(this.bubbleText._height + 20,47);
      this.matrix = new flash.geom.Matrix();
      this.matrix.createGradientBox(_loc6_,_loc7_,this.angle,1,1);
      if(this.bubbleBG == undefined)
      {
         this.createEmptyMovieClip("bubbleBG",1);
      }
      this.bubbleBG.lineStyle(this.lineWeight,this.lineColor,this.lineAlpha);
      this.bubbleBG.beginGradientFill(this.fillType,this.colors,this.alphas,this.ratios,this.matrix);
      this.bubbleBG.moveTo(this.offsetX + this.cRad,this.offsetY);
      this.bubbleBG.lineTo(this.offsetX + _loc6_ - this.cRad,this.offsetY);
      this.bubbleBG.curveTo(this.offsetX + _loc6_,this.offsetY,this.offsetX + _loc6_,this.offsetY + this.cRad);
      this.bubbleBG.lineTo(this.offsetX + _loc6_,this.offsetY + _loc7_ - this.cRad);
      this.bubbleBG.curveTo(this.offsetX + _loc6_,this.offsetY + _loc7_,this.offsetX + _loc6_ - this.cRad,this.offsetY + _loc7_);
      this.bubbleBG.lineTo(this.offsetX + this.cRad,this.offsetY + _loc7_);
      this.bubbleBG.curveTo(this.offsetX,this.offsetY + _loc7_,this.offsetX,this.offsetY + _loc7_ - this.cRad);
      this.bubbleBG.lineTo(this.offsetX,this.offsetY + this.cRad);
      this.bubbleBG.curveTo(this.offsetX,this.offsetY,this.offsetX + this.cRad,this.offsetY);
      this.bubbleBG.endFill();
      if(this.avatar == undefined)
      {
         this.avatar = this.attachMovie("bubbleAvatar","avatar",3);
         this.avatar._y = 30;
         this.avatar._x = 30;
      }
      if(this.bubbleClose == undefined)
      {
         this.attachMovie("btnBubbleClose","bubbleClose",4);
         this.bubbleClose.onRelease = function()
         {
            this._parent._parent.tutorialBGOverlay.removeMovieClip();
            delete this._parent._parent.tutorialBGOverlay;
            this._parent.removeMovieClip();
         };
         this.bubbleClose._y = 12;
         this.bubbleClose._x = 267;
      }
      this.bubXMid = this.bubbleBG._width / 2;
      this.bubYMid = this.bubbleBG._height / 2;
   }
   function drawPointer(pX, pY)
   {
      var _loc4_ = this.bubbleText._width + 80;
      var _loc5_ = this.bubbleText._height + 20;
      var _loc6_ = undefined;
      var _loc7_ = undefined;
      var _loc8_ = undefined;
      var _loc9_ = undefined;
      var _loc10_ = undefined;
      var _loc11_ = undefined;
      var _loc12_ = -20;
      var _loc13_ = _loc5_ + 15;
      var _loc14_ = _loc4_ + 15;
      var _loc15_ = -20;
      if(pX <= this.bubXMid && pY <= _loc12_)
      {
         _loc6_ = this.offsetX + this.cRad;
         _loc7_ = _loc6_ + 30;
         _loc8_ = this.offsetY;
         _loc9_ = this.offsetY;
      }
      else if(pX >= this.bubXMid && pY <= _loc12_)
      {
         _loc6_ = this.offsetX + _loc4_ - this.cRad;
         _loc7_ = _loc6_ - 30;
         _loc8_ = this.offsetY;
         _loc9_ = this.offsetY;
      }
      else if(pX >= _loc14_ && pY <= this.bubYMid && pY >= _loc12_)
      {
         _loc6_ = _loc4_;
         _loc7_ = _loc4_;
         _loc8_ = this.offsetY + this.cRad;
         _loc9_ = _loc8_ + 30;
      }
      else if(pX >= _loc14_ && pY >= this.bubYMid && pY <= _loc13_)
      {
         _loc6_ = _loc4_;
         _loc7_ = _loc4_;
         _loc8_ = this.offsetY + _loc5_ - this.cRad;
         _loc9_ = _loc8_ - 30;
      }
      else if(pX >= this.bubXMid && pY >= _loc13_)
      {
         _loc6_ = this.offsetX + _loc4_ - this.cRad;
         _loc7_ = _loc6_ - 30;
         _loc8_ = this.offsetY + _loc5_;
         _loc9_ = _loc8_;
      }
      else if(pX <= this.bubXMid && pY >= _loc13_)
      {
         _loc6_ = this.offsetX + this.cRad;
         _loc7_ = _loc6_ + 30;
         _loc8_ = this.offsetY + _loc5_;
         _loc9_ = _loc8_;
      }
      else if(pX <= _loc15_ && pY >= this.bubYMid && pY <= _loc13_)
      {
         _loc6_ = 0;
         _loc7_ = 0;
         _loc8_ = this.offsetY + _loc5_ - this.cRad;
         _loc9_ = _loc8_ - 30;
      }
      else if(pX <= _loc15_ && pY <= this.bubYMid && pY >= _loc12_)
      {
         _loc6_ = 0;
         _loc7_ = 0;
         _loc8_ = this.offsetY + this.cRad;
         _loc9_ = _loc8_ + 30;
      }
      var _loc16_ = undefined;
      var _loc17_ = undefined;
      if(_loc6_ != undefined)
      {
         _loc16_ = (_loc7_ + _loc6_) / 2;
         _loc17_ = (_loc9_ + _loc8_) / 2;
         _loc10_ = _loc16_ - (pX - _loc16_) / 4;
         _loc11_ = _loc17_ - (pY - _loc17_) / 4;
         this.bubbleBG.lineStyle(this.lineWeight,this.lineColor,this.lineAlpha);
         this.bubbleBG.beginGradientFill(this.fillType,this.colors,this.alphas,this.ratios,this.matrix);
         this.bubbleBG.moveTo(_loc6_,_loc8_);
         this.bubbleBG.lineTo(pX,pY);
         this.bubbleBG.lineTo(_loc7_,_loc9_);
         this.bubbleBG.lineStyle(0,this.lineColor,0);
         this.bubbleBG.lineTo(_loc10_,_loc11_);
         this.bubbleBG.endFill();
      }
   }
   function clearOldBubble()
   {
      this.bubbleText.removeTextField();
      this.bubbleBG.removeMovieClip();
      this.btnNext._visible = false;
   }
   function addNextButton()
   {
      if(this.btnNext == undefined)
      {
         this.attachMovie("btnBubbleNext","btnNext",this.getNextHighestDepth());
         this.btnNext._x = this.bubbleClose._x - 3;
      }
      else
      {
         this.btnNext._visible = true;
      }
      this.btnNext._y = this.bubYMid * 2 - this.btnNext._height - 6;
   }
}
