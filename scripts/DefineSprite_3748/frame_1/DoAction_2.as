var partArr;
var curPart;
btnPartNext.onRelease = function()
{
   trace("btnPartNext: " + _parent.curPart + 1);
   trace("btnPartNext: " + curPart);
   setCurPart(curPart + 1);
};
btnPartPrev.onRelease = function()
{
   setCurPart(curPart - 1);
};
togPreview.onRollOver = function()
{
   this.icn._xscale = this.icn._yscale = 115;
};
togPreview.onRollOut = function()
{
   this.icn._xscale = this.icn._yscale = 100;
};
togPreview.onRelease = function()
{
   this.icn._xscale = this.icn._yscale = 100;
   var _loc3_ = new XML(partArr[curPart].toString());
   _parent.selPartXML = _loc3_.firstChild;
   _parent.selPartXML.attributes.pdi = _parent.selPartXML.attributes.di;
   if(variationArr.length)
   {
      _parent.selPartXML.attributes.n += " (" + variationArr[curVariation].childNodes.join("") + ")";
      _parent.selPartXML.attributes.di = variationArr[curVariation].attributes.di;
      _parent.selPartXML.attributes.pvid = variationArr[curVariation].attributes.i;
   }
   else
   {
      _parent.selPartXML.attributes.pvid = 0;
   }
   _parent.selPartXML.attributes.cc = curColor;
   gaugePreview.takeControlsID(_parent.selPartXML.attributes.di,false);
   _parent.showPartPreview(_parent.selPartXML.attributes.i,"c");
};
