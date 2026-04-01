function init(pid)
{
   curPart = 0;
   partArr = new Array();
   trace("length: " + _global.partXML.firstChild.childNodes.length);
   var _loc5_ = 0;
   while(_loc5_ < _global.partXML.firstChild.childNodes.length)
   {
      trace(_global.partXML.firstChild.childNodes[_loc5_].attributes.pi);
      if(_global.partXML.firstChild.childNodes[_loc5_].attributes.pi == pid && _global.partXML.firstChild.childNodes[_loc5_].attributes.l == _parent.locationID)
      {
         partArr.push(_global.partXML.firstChild.childNodes[_loc5_]);
      }
      _loc5_ += 1;
   }
   if(!partArr.length)
   {
      this._visible = false;
      txtName = "None Available";
      togPreview._visible = false;
   }
   else
   {
      this._visible = true;
      gaugeHolder._visible = true;
      gaugePreview.takeControlsID(partArr[0].attributes.di,false);
      setCurPart(0);
      togPreview._visible = true;
   }
   if(partArr.length <= 1)
   {
      partNav(false);
   }
   else
   {
      partNav(true);
   }
}
function setCurPart(idx)
{
   trace("idx: " + idx);
   if(partArr.length <= 1)
   {
      partNav(false);
   }
   else
   {
      partNav(true);
   }
   curPart = idx;
   curPart = getIndex(idx);
   leftPart = getIndex(curPart - 1);
   rightPart = getIndex(curPart + 1);
   txtName = partArr[curPart].attributes.n;
   addThumb(thumbMiddle,partArr[curPart].attributes.di);
   trace("calling setControlsID");
   trace(gaugePreview.takeControlsID);
   if(partArr.length == 2 && leftPart < curPart)
   {
      trace("adding left");
      thumbRight.temp.removeMovieClip();
      addThumb(thumbLeft,partArr[leftPart].attributes.di);
      btnPartPrev._visible = false;
   }
   else if(partArr.length == 2 && rightPart > curPart)
   {
      trace("adding right");
      thumbLeft.temp.removeMovieClip();
      addThumb(thumbRight,partArr[rightPart].attributes.di);
      btnPartNext._visible = false;
   }
   else if(partArr.length > 2)
   {
      trace("adding both");
      addThumb(thumbLeft,partArr[leftPart].attributes.di);
      addThumb(thumbRight,partArr[rightPart].attributes.di);
   }
}
function addThumb(clip, arrayIndex)
{
   trace("addThumb");
   trace(clip);
   clip.temp.removeMovieClip();
   trace(clip.temp);
   clip.createEmptyMovieClip("temp",clip.getNextHighestDepth());
   clip.temp.attachBitmap(gaugeHolder.arrThumbs[arrayIndex],0);
}
function getIndex(idx)
{
   if(idx > partArr.length - 1)
   {
      idx = 0;
   }
   else if(idx < 0)
   {
      idx = partArr.length - 1;
   }
   return idx;
}
function partNav(vis)
{
   btnPartPrev._visible = vis;
   btnPartNext._visible = vis;
}
function showPreview(controlsID)
{
   this.previewHolder.removeMovieClip();
   this.createEmptyMovieClip("previewHolder",0);
   this.previe;
}
