img_mc._visible = false;
img_mc.hilite._visible = false;
colorPicker.clr = new Color(colorPicker.square);
if(_global.loginXML.firstChild.firstChild.attributes.bg && _global.loginXML.firstChild.firstChild.attributes.bg != "000000")
{
   var tgclr = Number("0x" + _global.loginXML.firstChild.firstChild.attributes.bg);
   colorPicker.clr.setRGB(tgclr);
   setGridColorHilite(getGridColorPoint(tgclr));
}
var image_bitmap = new flash.display.BitmapData(img_mc._width,img_mc._height);
image_bitmap.draw(img_mc);
img_mc.onRelease = function()
{
   var _loc4_ = image_bitmap.getPixel(img_mc._xmouse,img_mc._ymouse);
   var _loc5_ = undefined;
   if(_loc4_ > 0)
   {
      _loc5_ = _loc4_.toString(16);
      _parent.paintOverlay(_loc5_);
      colorPicker.clr.setRGB(Number("0x" + _loc5_));
      this._visible = false;
      colorPicker._visible = true;
      _root.updateBgColor(_loc5_);
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
   setGridColorHilite(getGridColorPoint(Number("0x" + _global.loginXML.firstChild.firstChild.attributes.bg)));
   img_mc._visible = true;
};
