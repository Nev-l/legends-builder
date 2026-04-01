stop();
drawMembers(_global.teamXML.firstChild.firstChild);
img_mc._visible = false;
img_mc.hilite._visible = false;
if(classes.GlobalData.attr.tr != 1)
{
   txtBGColor._visible = false;
   colorPicker._visible = false;
}
colorPicker.clr = new Color(colorPicker.square);
if(_global.teamXML.firstChild.firstChild.attributes.bg && _global.teamXML.firstChild.firstChild.attributes.bg != "000000")
{
   var tgclr = Number("0x" + _global.teamXML.firstChild.firstChild.attributes.bg);
   colorPicker.clr.setRGB(tgclr);
   setGridColorHilite(getGridColorPoint(tgclr));
}
var image_bitmap = new flash.display.BitmapData(img_mc._width,img_mc._height);
image_bitmap.draw(img_mc);
img_mc.onRelease = function()
{
   var _loc3_ = image_bitmap.getPixel(img_mc._xmouse,img_mc._ymouse);
   var _loc4_ = undefined;
   if(_loc3_ > 0)
   {
      _loc4_ = _loc3_.toString(16);
      paintOverlay(_loc4_);
      colorPicker.clr.setRGB(Number("0x" + _loc4_));
      this._visible = false;
      colorPicker._visible = true;
      _root.teamUpdateBgColor(_loc4_);
   }
};
img_mc.onRollOut = function()
{
   this._visible = false;
   colorPicker._visible = true;
};
img_mc.onDragOut = img_mc.onRollOut;
colorPicker.onRelease = function()
{
   this._visible = false;
   setGridColorHilite(getGridColorPoint(Number("0x" + _global.teamXML.firstChild.firstChild.attributes.bg)));
   img_mc._visible = true;
   img_mc.swapDepths(getNextHighestDepth());
};
