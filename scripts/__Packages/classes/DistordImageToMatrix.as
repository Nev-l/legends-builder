class classes.DistordImageToMatrix
{
   var _mc;
   var _texture;
   var _mtx;
   var _vseg;
   var _hseg;
   var _w;
   var _h;
   var _p;
   var _tri;
   var _xMin;
   var _yMin;
   var _xMax;
   var _yMax;
   var _hsLen;
   var _vsLen;
   var _sMat;
   var _tMat;
   function DistordImageToMatrix(mc, bmp, mtx)
   {
      this._mc = mc;
      this._texture = bmp;
      this._mtx = mtx;
      this._vseg = this._mtx.length - 1;
      this._hseg = this._mtx[0].length - 1;
      this._w = this._texture.width;
      this._h = this._texture.height;
      this.__init();
   }
   function __init(Void)
   {
      this._p = new Array();
      this._tri = new Array();
      var _loc3_ = this._w / 2;
      var _loc4_ = this._h / 2;
      this._xMin = this._yMin = 0;
      this._xMax = this._w;
      this._yMax = this._h;
      this._hsLen = this._w / this._hseg;
      this._vsLen = this._h / this._vseg;
      var _loc5_ = undefined;
      var _loc6_ = undefined;
      var _loc7_ = 0;
      var _loc8_ = undefined;
      while(_loc7_ < this._vseg + 1)
      {
         _loc8_ = 0;
         while(_loc8_ < this._hseg + 1)
         {
            _loc5_ = _loc8_ * this._hsLen;
            _loc6_ = _loc7_ * this._vsLen;
            this._p.push({x:_loc5_,y:_loc6_,sx:this._mtx[_loc7_][_loc8_][0],sy:this._mtx[_loc7_][_loc8_][1]});
            _loc8_ += 1;
         }
         _loc7_ += 1;
      }
      _loc7_ = 0;
      while(_loc7_ < this._vseg)
      {
         _loc8_ = 0;
         while(_loc8_ < this._hseg)
         {
            this._tri.push([this._p[_loc8_ + _loc7_ * (this._hseg + 1)],this._p[_loc8_ + _loc7_ * (this._hseg + 1) + 1],this._p[_loc8_ + (_loc7_ + 1) * (this._hseg + 1)]]);
            this._tri.push([this._p[_loc8_ + (_loc7_ + 1) * (this._hseg + 1) + 1],this._p[_loc8_ + (_loc7_ + 1) * (this._hseg + 1)],this._p[_loc8_ + _loc7_ * (this._hseg + 1) + 1]]);
            _loc8_ += 1;
         }
         _loc7_ += 1;
      }
      this.__render();
   }
   function setTransform(x0, y0, x1, y1, x2, y2, x3, y3)
   {
      var _loc10_ = this._w;
      var _loc11_ = this._h;
      var _loc12_ = x3 - x0;
      var _loc13_ = y3 - y0;
      var _loc14_ = x2 - x1;
      var _loc15_ = y2 - y1;
      var _loc16_ = this._p.length;
      var _loc17_ = undefined;
      var _loc18_ = undefined;
      var _loc19_ = undefined;
      var _loc20_ = undefined;
      var _loc21_ = undefined;
      var _loc22_ = undefined;
      var _loc23_ = undefined;
      var _loc24_ = undefined;
      var _loc25_ = undefined;
      var _loc26_ = undefined;
      var _loc27_ = undefined;
      var _loc28_ = undefined;
      var _loc29_ = undefined;
      var _loc30_ = undefined;
      while((_loc16_ -= 1) > -1)
      {
         _loc17_ = this._p[_loc16_];
         _loc18_ = (_loc17_.x - this._xMin) / _loc10_;
         _loc19_ = (_loc17_.y - this._yMin) / _loc11_;
         _loc20_ = y3 - y0;
         _loc21_ = y2 - y1;
         if(_loc20_ <= _loc21_)
         {
            _loc22_ = _loc20_ / _loc21_;
            _loc23_ = Math.pow(1 - _loc18_,0.65);
            _loc24_ = Math.pow(_loc22_,_loc23_);
            _loc18_ *= _loc24_;
         }
         else
         {
            _loc22_ = _loc21_ / _loc20_;
            _loc23_ = Math.pow(_loc18_,0.65);
            _loc24_ = Math.pow(_loc22_,_loc23_);
            _loc18_ = 1 - (1 - _loc18_) * _loc24_;
         }
         _loc25_ = x1 - x0;
         _loc26_ = x2 - x3;
         if(_loc25_ < _loc26_)
         {
            _loc27_ = _loc25_ / _loc26_;
            _loc23_ = Math.pow(1 - _loc19_,1.4);
            _loc28_ = Math.pow(_loc27_,_loc23_);
            _loc19_ *= _loc28_;
         }
         else
         {
            _loc27_ = _loc25_ / _loc26_;
            _loc23_ = Math.pow(1 - _loc19_,0.9);
            _loc28_ = Math.pow(_loc27_,_loc23_);
            _loc19_ *= _loc28_;
         }
         _loc29_ = x0 + _loc19_ * _loc12_;
         _loc30_ = y0 + _loc19_ * _loc13_;
         _loc17_.sx = _loc29_ + _loc18_ * (x1 + _loc19_ * _loc14_ - _loc29_);
         _loc17_.sy = _loc30_ + _loc18_ * (y1 + _loc19_ * _loc15_ - _loc30_);
      }
      this.__render();
   }
   function __render(Void)
   {
      var _loc3_ = undefined;
      var _loc4_ = undefined;
      var _loc5_ = undefined;
      var _loc6_ = undefined;
      var _loc7_ = undefined;
      var _loc8_ = this._mc;
      var _loc9_ = undefined;
      _loc8_.clear();
      this._sMat = new flash.geom.Matrix();
      this._tMat = new flash.geom.Matrix();
      var _loc10_ = this._tri.length;
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
      while((_loc10_ -= 1) > -1)
      {
         _loc9_ = this._tri[_loc10_];
         _loc5_ = _loc9_[0];
         _loc6_ = _loc9_[1];
         _loc7_ = _loc9_[2];
         _loc11_ = _loc5_.sx;
         _loc12_ = _loc5_.sy;
         _loc13_ = _loc6_.sx;
         _loc14_ = _loc6_.sy;
         _loc15_ = _loc7_.sx;
         _loc16_ = _loc7_.sy;
         _loc17_ = _loc5_.x;
         _loc18_ = _loc5_.y;
         _loc19_ = _loc6_.x;
         _loc20_ = _loc6_.y;
         _loc21_ = _loc7_.x;
         _loc22_ = _loc7_.y;
         this._tMat.tx = _loc17_;
         this._tMat.ty = _loc18_;
         this._tMat.a = (_loc19_ - _loc17_) / this._w;
         this._tMat.b = (_loc20_ - _loc18_) / this._w;
         this._tMat.c = (_loc21_ - _loc17_) / this._h;
         this._tMat.d = (_loc22_ - _loc18_) / this._h;
         this._sMat.a = (_loc13_ - _loc11_) / this._w;
         this._sMat.b = (_loc14_ - _loc12_) / this._w;
         this._sMat.c = (_loc15_ - _loc11_) / this._h;
         this._sMat.d = (_loc16_ - _loc12_) / this._h;
         this._sMat.tx = _loc11_;
         this._sMat.ty = _loc12_;
         this._tMat.invert();
         this._tMat.concat(this._sMat);
         _loc8_.beginBitmapFill(this._texture,this._tMat,false,true,true);
         _loc8_.moveTo(_loc11_,_loc12_);
         _loc8_.lineTo(_loc13_,_loc14_);
         _loc8_.lineTo(_loc15_,_loc16_);
         _loc8_.endFill();
      }
   }
}
