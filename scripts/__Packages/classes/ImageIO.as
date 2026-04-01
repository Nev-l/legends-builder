class classes.ImageIO
{
   var listener;
   var _parent;
   var _alpha;
   var onEnterFrame;
   var mcLoader;
   var _aid;
   var _mv;
   var _noCache;
   var _avatarType = "avatars";
   function ImageIO()
   {
      this.listener = new Object();
      this.listener.onLoadError = function(target, errorCode)
      {
         trace("ImageIO.onLoadError aid=" + this._parent._aid + " errorCode=" + errorCode + " type=" + this._parent._avatarType);
         this.showDefaultAvatar();
      };
      this.listener.onLoadComplete = function(target)
      {
         trace("ImageIO.onLoadComplete aid=" + this._parent._aid + " type=" + this._parent._avatarType);
         target.onEnterFrame = function()
         {
            if(this._alpha < 100)
            {
               this._alpha += 20;
            }
            else
            {
               this._alpha = 100;
               delete this.onEnterFrame;
            }
         };
         this.mcLoader.removeListener(this);
      };
      this.mcLoader = new MovieClipLoader();
      this.mcLoader.addListener(this.listener);
   }
   function set avatarType(at)
   {
      this._avatarType = at;
   }
   function loadAvatar(mv, aid, noCache)
   {
      this._aid = aid;
      this._mv = mv;
      this._noCache = noCache;
      _root.getAvatar(this._aid,this,this._avatarType,noCache);
   }
   function showAvatar()
   {
      trace("ImageIO.showAvatar aid=" + this._aid + " type=" + this._avatarType + " noCache=" + this._noCache);
      var _loc2_ = "cache/" + this._avatarType + "/" + this._aid + ".jpg";
      if(this._noCache || this._avatarType == "avatars")
      {
         _loc2_ += "?ts=" + new Date().getTime();
      }
      trace("ImageIO.loadClip url=" + _loc2_);
      this.mcLoader.loadClip(_loc2_,this._mv);
   }
   function showDefaultAvatar()
   {
      trace("ImageIO.showDefaultAvatar aid=" + this._aid + " type=" + this._avatarType);
      if(this._avatarType == "teamavatars")
      {
         this._mv.attachMovie("portraitTeamAvatar","noImage",1);
      }
      else
      {
         this._mv.attachMovie("portrait_offline","noImage",1);
      }
      this._mv.onEnterFrame = function()
      {
         if(this._alpha < 100)
         {
            this._alpha += 20;
         }
         else
         {
            this._alpha = 100;
            delete this.onEnterFrame;
         }
      };
      this.mcLoader.removeListener(this.listener);
   }
   function idToPath(aid)
   {
      return Math.floor(aid / 1000000).toString() + "/" + Math.floor(aid / 10000 % 100).toString() + "/" + Math.floor(aid / 100 % 100).toString() + "/" + Math.floor(aid % 100).toString();
   }
}
