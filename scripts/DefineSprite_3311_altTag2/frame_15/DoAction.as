stop();
margin = 10;
fld.autoSize = true;
fldDesc.autoSize = true;
classes.Drawing.rect(box,fld._width + 2 * margin,16,0,50,0,0,0,1,16777215,60);
classes.Drawing.rect(box,fldDesc._width + 2 * margin,fldDesc._height + 2 * margin,0,50,0,16.6,0,1,16777215,60);
this.onEnterFrame = function()
{
   if(caller.toString() == undefined)
   {
      this.removeMovieClip();
   }
};
