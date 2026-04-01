class classes.TeamInfo extends MovieClip
{
   var scale;
   var badgeAreaWidth;
   var tID;
   var photo;
   var canChange;
   var id;
   var fldName;
   var tName;
   var fldCred;
   var tCred;
   var teamXML;
   var badges;
   function TeamInfo()
   {
      super();
      if(!this.scale)
      {
         this.scale = 100;
      }
      if(this.scale == 50)
      {
         this.badgeAreaWidth = 85;
      }
      else
      {
         this.badgeAreaWidth = 170 * this.scale / 100;
      }
      if(!this.tID)
      {
         this.tID = 0;
      }
      this.updateAvatar();
      this.photo._xscale = this.photo._yscale = this.scale;
      if(this.canChange)
      {
         this.photo.id = this.tID;
         this.photo.onRelease = function()
         {
            _root.aub = classes.AvatarUploadBox(_root.attachMovie("avatarUploadBox","aub",_root.getNextHighestDepth(),{id:this.id,avatarType:"teamavatars"}));
         };
      }
      this.fldName.text = this.tName;
      this.fldCred.text = String(this.tCred);
      this.showBadges(this.teamXML);
   }
   function updateAvatar()
   {
      trace("UPDATING TEAM AVATAR");
      classes.Drawing.portrait(this,this.tID,1,0,0,Math.ceil(100 / this.scale),false,"teamavatars",true);
   }
   function showBadges(bxml)
   {
      var _loc3_ = new Array();
      var _loc4_ = undefined;
      trace("bxml: ");
      trace(bxml);
      var _loc5_ = 0;
      while(_loc5_ < bxml.firstChild.firstChild.childNodes.length)
      {
         trace(bxml.firstChild.firstChild.childNodes[_loc5_].nodeName);
         if(bxml.firstChild.firstChild.childNodes[_loc5_].nodeName == "b")
         {
            trace("found badge!");
            _loc4_ = bxml.firstChild.firstChild.childNodes[_loc5_].attributes;
            _loc3_.push(_loc4_);
         }
         _loc5_ += 1;
      }
      var _loc6_ = false;
      classes.Badges.drawBadges(this.badges,_loc3_,this.badgeAreaWidth,_loc6_);
   }
}
