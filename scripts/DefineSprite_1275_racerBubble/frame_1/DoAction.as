fld.autoSize = true;
hh = fld._y + fld._height + 14;
classes.Drawing.rect(this,ww,hh,16777215,100,0,0,8);
if(lane == 2)
{
   var ax = 0;
   var axs = -100;
}
else
{
   var ax = ww;
   var axs = 100;
}
this.attachMovie("racerBubbleAnchor","anchor",1,{_x:ax,_y:hh,_xscale:axs});
classes.RacePlay.racerBubbleMoveCB(this);
