function init()
{
   var _loc2_ = 148;
   while(_loc2_ <= 151)
   {
      this["loadin" + _loc2_].unloadMovie();
      delete this["path" + _loc2_];
      delete this["previewPath" + _loc2_];
      delete this["filesize" + _loc2_];
      _loc2_ += 1;
   }
   setRemoveButtons();
}
function setPrices()
{
   var _loc3_ = 0;
   var _loc4_ = undefined;
   var _loc5_ = undefined;
   while(_loc3_ < _global.partXML.firstChild.childNodes.length)
   {
      _loc4_ = 148;
      while(_loc4_ <= 151)
      {
         if(_global.partXML.firstChild.childNodes[_loc3_].attributes.pi == _loc4_ + 12)
         {
            _loc5_ = Number(_global.partXML.firstChild.childNodes[_loc3_].attributes.pp);
            if(_loc5_ || _loc5_ === 0)
            {
               this["cost" + _loc4_] = _loc5_;
               break;
            }
            this["cost" + _loc4_] = 9999;
            break;
         }
         _loc4_ += 1;
      }
      _loc3_ += 1;
   }
}
function setLocalPath(ci, path, filesize, previewPath)
{
   var _loc6_ = undefined;
   var _loc7_ = undefined;
   var _loc8_ = undefined;
   if(ci)
   {
      this["path" + ci] = path;
      this["previewPath" + ci] = previewPath == undefined || previewPath == "" ? path : previewPath;
      this["filesize" + ci] = filesize;
      _loc8_ = this["previewPath" + ci];
      trace("setLocalPath: " + ci + ", " + path + ", " + filesize + ", " + _loc8_);
      if(_loc8_ && _loc8_.length)
      {
         _loc6_ = new Object();
         _loc6_.ci = ci;
         _loc6_.onLoadError = function(target_mc, errorCode, httpStatus)
         {
            trace(">> loadListener.onLoadError()");
            trace(">> ==========================");
            trace(">> errorCode: " + errorCode);
            trace(">> httpStatus: " + httpStatus);
         };
         _loc6_.onLoadStart = function(mc)
         {
            mc._xscale = 100;
            mc._yscale = 100;
         };
         _loc6_.onLoadInit = function(mc)
         {
            trace("MCMCMCMCMCMC: " + mc._width + ", " + mc._height);
            mc._visible = false;
            _global.setTimeout(onGraphicLoad,700,mc,ci);
            delete mcLoader;
            false;
         };
         _loc7_ = new MovieClipLoader();
         _loc7_.addListener(_loc6_);
         _loc7_.loadClip(_loc8_,this["loadin" + ci]);
      }
      else
      {
         delete this["previewPath" + ci];
         this["loadin" + ci].unloadMovie();
         setRemoveButtons();
         _parent.previewCustomGraphics();
      }
   }
}
function onGraphicLoad(mc, ci)
{
   trace("onGraphicLoad: " + mc + ", " + ci);
   mc.do_ci = ci;
   mc.onEnterFrame = function()
   {
      do_onGraphicLoad(this,this.do_ci);
      delete this.onEnterFrame;
   };
}
function onGraphicLoad(mc, ci)
{
   trace("onGraphicLoad: " + mc + ", " + ci);
   trace(_parent);
   if(mc._width > 0 && mc._height > 0)
   {
      switch(ci)
      {
         case 148:
            mc._xscale = 5200 / mc._width;
            mc._yscale = 5000 / mc._height;
            break;
         case 149:
            mc._xscale = 16350 / mc._width;
            mc._yscale = 4675 / mc._height;
            break;
         case 150:
            mc._xscale = 7700 / mc._width;
            mc._yscale = 4000 / mc._height;
            break;
         case 151:
            mc._xscale = 8950 / mc._width;
            mc._yscale = 3750 / mc._height;
      }
   }
   else
   {
      trace("MCMCMCMCMC: no size after resize");
      delete _global.shopUGGGroup["path" + ci];
      delete _global.shopUGGGroup["previewPath" + ci];
      delete _global.shopUGGGroup["filesize" + ci];
      _global.shopUGGGroup["loadin" + ci].unloadMovie();
      _root.displayAlert("warning","Bad File","Sorry, there\'s a problem with the file you selected.  Make sure that it is one of the following types of images: jpg, gif, png");
   }
   mc._visible = true;
   setRemoveButtons();
   _parent.previewCustomGraphics();
}
function setRemoveButtons()
{
   trace("setRemoveButtons");
   var _loc2_ = 148;
   while(_loc2_ <= 151)
   {
      if(this["path" + _loc2_])
      {
         this["btnRemove" + _loc2_]._visible = true;
      }
      else
      {
         this["btnRemove" + _loc2_]._visible = false;
      }
      _loc2_ += 1;
   }
}
function getCombinedCost()
{
   var _loc2_ = 0;
   var _loc3_ = 148;
   while(_loc3_ <= 151)
   {
      if(this["path" + _loc3_])
      {
         _loc2_ += this["cost" + _loc3_];
      }
      _loc3_ += 1;
   }
   return _loc2_;
}
function getCombinedFilesize()
{
   var _loc2_ = 0;
   var _loc3_ = 148;
   while(_loc3_ <= 151)
   {
      if(this["filesize" + _loc3_])
      {
         _loc2_ += this["filesize" + _loc3_];
      }
      _loc3_ += 1;
   }
   return _loc2_;
}
function getUggCount()
{
   var _loc2_ = 0;
   var _loc3_ = 148;
   while(_loc3_ <= 151)
   {
      if(this["filesize" + _loc3_])
      {
         _loc2_ += 1;
      }
      _loc3_ += 1;
   }
   return _loc2_;
}
