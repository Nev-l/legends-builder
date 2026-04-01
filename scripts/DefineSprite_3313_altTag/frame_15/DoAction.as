stop();
margin = 10;
fld.autoSize = true;
classes.Drawing.rect(box,fld._width + 2 * margin,16,0,50,0,0,0,1,16777215,60);
this.onEnterFrame = function()
{
   if(caller.toString() == undefined)
   {
      this.removeMovieClip();
   }
};
