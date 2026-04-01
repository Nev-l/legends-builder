class classes.HomeTeamStatus extends MovieClip
{
   var btnCreate;
   function HomeTeamStatus()
   {
      super();
      trace("class HomeTeamStatus");
      var _loc4_ = function(d)
      {
         _global.appXML = new XML(d);
         this.drawMyApplications(_global.appXML.firstChild);
      };
      classes.Lookup.addCallback("teamGetMyApps",this,_loc4_,"");
      _root.teamGetMyApps();
      this.btnCreate.onRelease = function()
      {
         _root.abc.closeMe();
         _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),{contentName:"dialogTeamCreateContent"});
      };
   }
   function drawMyApplications(txml)
   {
      var _loc4_ = 0;
      var _loc5_ = 50;
      var _loc6_ = new TextFormat();
      _loc6_.color = 16777215;
      _loc6_.font = "Arial";
      _loc6_.bold = true;
      _loc6_.size = 12;
      var _loc7_ = this.createTextField("appsTitle",this.getNextHighestDepth(),_loc5_,_loc4_,210,36);
      _loc7_.embedFonts = true;
      _loc7_.selectable = false;
      _loc7_.setNewTextFormat(_loc6_);
      _loc4_ += 30;
      if(txml.childNodes.length)
      {
         _loc7_.text = "Outgoing Applications";
      }
      else
      {
         _loc7_.text = "You have no outgoing applications";
         _loc7_ = this.createTextField("appsNone",this.getNextHighestDepth(),_loc5_,_loc4_,210,36);
         _loc7_.embedFonts = true;
         _loc7_.multiline = true;
         _loc7_.autoSize = true;
         _loc7_.wordWrap = true;
         _loc7_.selectable = false;
         _loc6_.size = 10;
         _loc7_.setNewTextFormat(_loc6_);
         _loc7_.text = "You can apply to teams by finding them in the Viewer and clicking the \'Join\' button.\r\rYou can apply to as many teams as you like at a time.  More than one team may offer you membership, but you can only join one of them.\r\rThe statuses of all your team applications will appear here.";
         _loc4_ += 100;
      }
      _loc6_.font = "ArialBmp9";
      _loc6_.bold = false;
      _loc6_.size = 9;
      var _loc8_ = undefined;
      var _loc9_ = 0;
      while(_loc9_ < txml.childNodes.length)
      {
         _loc8_ = txml.childNodes[_loc9_].attributes;
         this.attachMovie("teamInfo50","application" + _loc9_,this.getNextHighestDepth(),{_x:_loc5_,_y:_loc4_,scale:50,tID:_loc8_.ti,tName:_loc8_.tn,tCred:_loc8_.sc,teamXML:_global.txml});
         this.attachMovie("applicationOptions","options" + _loc9_,this.getNextHighestDepth(),{tID:_loc8_.ti,_x:_loc5_,_y:_loc4_ + 42});
         if(_loc8_.s == "Accepted")
         {
            this["options" + _loc9_].gotoAndPlay("accepted");
         }
         else if(_loc8_.s == "Declined")
         {
            this["options" + _loc9_].gotoAndPlay("declined");
         }
         this.createTextField("comment" + _loc9_,this.getNextHighestDepth(),_loc5_ + 219,_loc4_ + 4,160,70);
         _loc7_ = this["comment" + _loc9_];
         _loc7_.embedFonts = true;
         _loc7_.multiline = true;
         _loc7_.selectable = false;
         _loc7_.wordWrap = true;
         _loc7_.setNewTextFormat(_loc6_);
         _loc7_.text = !_loc8_.n.length ? "" : _loc8_.n;
         _loc4_ += 83;
         _loc9_ += 1;
      }
      this._parent._parent.scrollerObj.refreshScroller();
   }
}
