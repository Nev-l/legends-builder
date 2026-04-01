btnHelp.onRelease = function()
{
   _parent.clearHelp();
   helpBubble = createEmptyMovieClip("helpBubble",getNextHighestDepth());
   var _loc2_ = new Array();
   _loc2_.push(new Array(143,5,174,-115,"Create a team race challenge to send to another team in this room.  The challenge will automatically go to the other team\'s highest ranking member in the room.  That person will have the option to accept or reject your challenge.  Note: Team race results will affect the team\'s street credit, not the SC of each racer."));
   tutorialObj = new classes.util.Tutorial(helpBubble,_loc2_);
   helpBubble.onRelease = function()
   {
      this.removeMovieClip();
   };
};
