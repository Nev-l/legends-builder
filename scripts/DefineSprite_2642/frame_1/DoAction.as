btnHelp.onRelease = function()
{
   _parent.clearHelp();
   helpBubble = createEmptyMovieClip("helpBubble",getNextHighestDepth());
   var _loc2_ = new Array();
   _loc2_.push(new Array(143,5,174,-115,"Create a race challenge to send to another member in this room.  Select your car and your opponent\'s car, and choose either a Bracket or H2H race.  You can create a friendly race, put some money on the line or even bet your car with a pink slip race!"));
   tutorialObj = new classes.util.Tutorial(helpBubble,_loc2_);
   helpBubble.onRelease = function()
   {
      this.removeMovieClip();
   };
};
