btn.onRelease = function()
{
   classes.Lookup.addCallback("teamUpdateApp",this,CB_decline,"");
   _root.abc.closeMe();
   _root.abc = classes.AlertBox(_root.attachMovie("alertBox","abc",_root.getNextHighestDepth()));
   _root.abc.setValue("Delete an Application","Are you sure you want to remove this applicant?",warning);
   _root.abc.addButton("OK");
   _root.abc.addButton("Cancel");
   var _loc3_ = new Object();
   _loc3_.uID = uID;
   _loc3_.deleteMC = this._parent;
   _loc3_.onRelease = function(theButton, keepBoxOpen)
   {
      if(theButton.btnLabel.text === "OK")
      {
         _root.teamUpdateApp(this.uID,0);
         this.deleteMC.removeMovieClip();
      }
      if(!keepBoxOpen)
      {
         false;
         theButton._parent._parent.removeMovieClip();
      }
   };
   _root.abc.addListener(_loc3_);
};
