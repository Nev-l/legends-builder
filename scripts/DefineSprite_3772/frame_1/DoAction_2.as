var partArr;
var variationArr;
var curPart;
var curVariation;
var curColor = "0";
var swatchClr = new Color(swatch);
swatchClr.setRGB(0);
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
btnVariationNext.onRelease = function()
{
   setCurVariation(curVariation + 1);
};
btnVariationPrev.onRelease = function()
{
   setCurVariation(curVariation - 1);
};
colorPicker.onPress = function()
{
   var _loc2_ = new flash.display.BitmapData(this._width,this._height);
   _loc2_.draw(this);
   curColor = _loc2_.getPixel(this._xmouse,this._ymouse).toString(16);
   swatchClr.setRGB(Number("0x" + curColor));
   crosshairs._x = _xmouse;
   crosshairs._y = _ymouse;
   false;
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
      _parent.selPartXML.attributes.di = 1;
      _parent.selPartXML.attributes.pvid = 0;
   }
   _parent.selPartXML.attributes.cc = curColor;
   _parent.showPartPreview(_parent.selPartXML.attributes.i,"c");
};
