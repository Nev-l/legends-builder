class classes.Badges
{
   function Badges()
   {
   }
   static function drawBadges(_mc, tArr, badgeAreaWidth, isReversed)
   {
      var _loc6_ = 0;
      var _loc7_ = 0;
      var _loc8_ = 37;
      for(var _loc9_ in _mc)
      {
         trace("children: " + _mc[_loc9_] + " " + _loc9_);
         trace("name: " + _mc[_loc9_].name.substr(0,3));
         trace("removing movie clip");
         trace(_mc[_loc9_]);
         _mc[_loc9_].removeMovieClip();
      }
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
      if(tArr.length)
      {
         _loc10_ = 0;
         while(_loc10_ < tArr.length)
         {
            _loc11_ = tArr[_loc10_].i;
            _loc12_ = _mc.createEmptyMovieClip("item" + _loc11_,_mc.getNextHighestDepth());
            _loc12_.attachBitmap(_root.badgesHolder.arrBmp[_loc11_],0);
            if(isReversed)
            {
               _loc6_ -= _loc12_._width - 4;
               _loc12_._x = _loc6_;
            }
            else
            {
               _loc12_._x = _loc6_;
               _loc6_ += _loc12_._width - 4;
            }
            _loc12_._y = (_loc8_ - _loc12_._height) / 2;
            if(Number(tArr[_loc10_].n) > 1)
            {
               _loc13_ = _loc12_.createTextField("count",2,0,23,24,20);
               _loc14_ = new TextFormat();
               _loc14_.font = "Arial";
               _loc14_.size = 10;
               _loc14_.color = 16777215;
               _loc14_.align = "right";
               _loc13_.embedFonts = true;
               _loc13_.autoSize = "right";
               _loc13_.setNewTextFormat(_loc14_);
               _loc13_.text = tArr[_loc10_].n;
            }
            classes.Help.addAltTag(_loc12_,classes.Lookup.badgeAltText(_loc11_));
            _loc10_ += 1;
         }
         if(_mc._width > badgeAreaWidth)
         {
            _loc15_ = _mc._height;
            _loc16_ = Math.max(badgeAreaWidth / _mc._width,0.6);
            _mc._xscale *= _loc16_;
            _mc._yscale = _mc._xscale;
            _loc17_ = Math.ceil(badgeAreaWidth * 100 / _mc._xscale);
            _loc19_ = _loc17_;
            if(isReversed)
            {
               for(var _loc20_ in _mc)
               {
                  if(Math.abs(_mc[_loc20_]._x) > _loc17_)
                  {
                     _mc[_loc20_]._y = 23 + (_loc8_ - _loc12_._height) / 2;
                     _loc18_ = true;
                     _loc19_ = Math.min(Math.abs(_mc[_loc20_]._x) + _mc[_loc20_]._width,_loc19_);
                  }
               }
               if(_loc18_)
               {
                  for(_loc20_ in _mc)
                  {
                     if(_mc[_loc20_]._y > 0)
                     {
                        _mc[_loc20_]._y = 23 + (_loc8_ - _loc12_._height) / 2;
                        _mc[_loc20_]._x += _loc19_;
                        if(Math.abs(_mc[_loc20_]._x) > _loc17_)
                        {
                           _mc[_loc20_]._visible = false;
                        }
                     }
                  }
               }
            }
            else
            {
               for(_loc20_ in _mc)
               {
                  if(_mc[_loc20_]._x + _mc[_loc20_]._width > _loc17_)
                  {
                     _mc[_loc20_]._y = 23 + (_loc8_ - _loc12_._height) / 2;
                     _loc18_ = true;
                     _loc19_ = Math.min(_mc[_loc20_]._x,_loc19_);
                  }
               }
               if(_loc18_)
               {
                  for(_loc20_ in _mc)
                  {
                     if(_mc[_loc20_]._y > 0)
                     {
                        _mc[_loc20_]._y = 23 + (_loc8_ - _loc12_._height) / 2;
                        _mc[_loc20_]._x -= _loc19_;
                        if(_mc[_loc20_]._x + _mc[_loc20_]._width > _loc17_)
                        {
                           _mc[_loc20_]._visible = false;
                        }
                     }
                  }
               }
            }
            if(!_loc18_)
            {
               _mc._y += Math.round((_loc15_ - _mc._height) / 2);
            }
         }
      }
   }
}
