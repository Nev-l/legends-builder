function init(pid)
{
   var _loc5_ = 0;
   while(_loc5_ < _global.partCatXML.firstChild.childNodes.length)
   {
      if(_global.partCatXML.firstChild.childNodes[_loc5_].attributes.i == pid)
      {
         txtTitle = "Browse " + _global.partCatXML.firstChild.childNodes[_loc5_].attributes.n + ":";
      }
      _loc5_ += 1;
   }
   curPart = 0;
   curVariation = 0;
   partArr = new Array();
   _loc5_ = 0;
   while(_loc5_ < _global.partXML.firstChild.childNodes.length)
   {
      if(_global.partXML.firstChild.childNodes[_loc5_].attributes.pi == pid && _global.partXML.firstChild.childNodes[_loc5_].attributes.l == _parent.locationID)
      {
         partArr.push(_global.partXML.firstChild.childNodes[_loc5_]);
         trace(_global.partXML.firstChild.childNodes[_loc5_]);
      }
      _loc5_ += 1;
   }
   if(!partArr.length)
   {
      this._visible = false;
      txtName = "None Available";
      txtVariation = "";
      variationNav(false);
      togPreview._visible = false;
   }
   else
   {
      this._visible = true;
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
   if(idx > partArr.length - 1)
   {
      idx = 0;
   }
   else if(idx < 0)
   {
      idx = partArr.length - 1;
   }
   curPart = idx;
   txtName = partArr[curPart].attributes.n;
   initVariations(curPart);
}
function initVariations(idx)
{
   variationArr = new Array();
   var _loc2_ = 0;
   while(_loc2_ < partArr[idx].childNodes.length)
   {
      variationArr.push(partArr[idx].childNodes[_loc2_]);
      _loc2_ += 1;
   }
   if(variationArr.length <= 1)
   {
      variationNav(false);
   }
   else
   {
      variationNav(true);
   }
   setCurVariation(0);
}
function setCurVariation(idx)
{
   trace("setCurVariation: " + idx);
   if(idx > variationArr.length - 1)
   {
      idx = 0;
   }
   else if(idx < 0)
   {
      idx = variationArr.length - 1;
   }
   curVariation = idx;
   var _loc3_ = undefined;
   switch(parseInt(partArr[curPart].attributes.pi))
   {
      case 146:
         _loc3_ = "full";
         break;
      case 148:
         _loc3_ = "hood";
         break;
      case 149:
         _loc3_ = "side";
         break;
      case 150:
         _loc3_ = "front";
         break;
      case 151:
         _loc3_ = "back";
   }
   trace("variationArr.length: " + variationArr.length);
   if(variationArr.length)
   {
      trace("load thumbnail: " + _global.assetPath + "/car/decals/" + partArr[curPart].attributes.di + "_" + _loc3_ + "_" + variationArr[idx].attributes.di + "_th.jpg");
      trace("txtVariation: " + variationArr[idx].childNodes.join(""));
      txtVariation = variationArr[idx].childNodes.join("");
      thumb.loadMovie(_global.assetPath + "/car/decals/" + partArr[curPart].attributes.di + "_" + _loc3_ + "_" + variationArr[idx].attributes.di + "_th.jpg");
   }
   else
   {
      txtVariation = "";
      thumb.loadMovie(_global.assetPath + "/car/decals/" + partArr[curPart].attributes.di + "_" + _loc3_ + "_1_th.jpg");
   }
}
function partNav(vis)
{
   btnPartPrev._visible = vis;
   btnPartNext._visible = vis;
}
function variationNav(vis)
{
   btnVariationPrev._visible = vis;
   btnVariationNext._visible = vis;
}
