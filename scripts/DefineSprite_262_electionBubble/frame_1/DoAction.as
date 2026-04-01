fld.autoSize = true;
hh = fld._y + fld._height + 14;
classes.Drawing.rect(this,ww,hh,16777215,100,0,0,8);
trace("hello!");
var anchorHeight = 19;
var anchorWidth = 41;
var speakerType = t;
var targetX = x;
var targetY = y;
var ax;
var axs;
switch(speakerType)
{
   case "C":
      axs = 100;
      this._x = targetX - anchorWidth - 10;
      ax = anchorWidth + 10;
      this._y = targetY - hh - anchorHeight;
      trace(this._y);
      break;
   case "1":
      axs = 100;
      this._x = targetX - ww;
      ax = ww;
      this._y = targetY - hh - anchorHeight;
      trace(this._y);
      break;
   case "2":
      axs = 100;
      this._x = targetX - ww / 2;
      ax = ww / 2;
      this._y = targetY - hh - anchorHeight;
      trace(this._y);
      break;
   case "3":
      axs = -100;
      this._x = targetX;
      ax = 10;
      this._y = targetY - hh - anchorHeight;
      trace(this._y);
}
this.attachMovie("racerBubbleAnchor","anchor",1,{_x:ax,_y:hh,_xscale:axs});
