var pic = this.createEmptyMovieClip("pic",1);
pic._xscale = pic._yscale = 25;
pic._x = 50;
classes.Drawing.portrait(pic,id,1,0,0,4,false,!isTeam ? "avatars" : "teamavatars");
checkeredFlag._visible = tf != 1 ? false : true;
if(isTeam)
{
   hotName.onRelease = function()
   {
      classes.Control.focusViewer(null,null,id);
   };
}
else
{
   hotName.onRelease = function()
   {
      classes.Control.focusViewer(id);
   };
}
if(acid)
{
   hotCol2.onRelease = function()
   {
      classes.Control.focusViewer(id,acid);
   };
}
