stop();
btn.onRelease = function()
{
   helpBubble.removeMovieClip();
   if(_parent._parent._currentframe == 1)
   {
      _parent._parent.gotoAndPlay("show");
   }
   else
   {
      _parent._parent.gotoAndPlay("hide");
   }
};
btnHelp.onRelease = function()
{
   helpBubble.removeMovieClip();
   helpBubble = createEmptyMovieClip("helpBubble",getNextHighestDepth());
   var _loc2_ = new Array();
   if(_global.chatObj.roomType == "KOTHH")
   {
      _loc2_.push(new Array(143,5,174,-115,"Challenge the current King of the Hill to a HEAD-TO-HEAD race and claim the spot for yourself.  If you are the King of the Hill any racer in the room can line up to compete against you.  Start a winning streak and try to be the best king on Nitto 1320 Legends!"));
   }
   else if(_global.chatObj.roomType == "KOTHB")
   {
      _loc2_.push(new Array(143,5,174,-115,"Challenge the current King of the Hill to a BRACKET race and claim the spot for yourself.  If you are the King of the Hill any racer in the room can line up to compete against you.  Start a winning streak and try to be the best king on Nitto 1320 Legends!"));
   }
   tutorialObj = new classes.util.Tutorial(helpBubble,_loc2_);
   helpBubble.onRelease = function()
   {
      this.removeMovieClip();
   };
};
