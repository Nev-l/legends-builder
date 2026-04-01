function CB_getRacersCars(c)
{
   trace("CB_getRacersCars");
   var _loc3_ = new XML(c);
   var _loc4_ = 1;
   var _loc5_ = undefined;
   var _loc6_ = undefined;
   while(_loc4_ <= 2)
   {
      _loc5_ = 1;
      while(_loc5_ <= 4)
      {
         _loc6_ = this["team" + _loc4_ + "Slot" + _loc5_];
         if(_loc6_.accountCarID == _loc3_.firstChild.attributes.i)
         {
            classes.Drawing.carView(_loc6_.car,new XML(_loc3_.firstChild.toString()),10);
         }
         _loc5_ += 1;
      }
      _loc4_ += 1;
   }
}
stop();
trace("detailNode...");
trace(detailNode.childNodes.length);
var matchCount = detailNode.childNodes.length;
fldNums.text = "";
var i = 1;
while(i <= matchCount)
{
   fldNums.text += i + ".\r";
   i++;
}
switch(detailNode.attributes.r)
{
   case "0":
      betIcon.gotoAndStop(1);
      fldRaceType.text = "FRIENDLY";
      break;
   case "1":
      betIcon.gotoAndStop(4);
      headerBar.clr = new Color(headerBar);
      headerBar.clr.setRGB(2594370);
      fldRaceType.text = "RANKED: $" + classes.NumFuncs.commaFormat(Number(detailNode.attributes.b));
}
switch(detailNode.attributes.h)
{
   case "0":
      raceIcon.gotoAndStop(1);
      break;
   case "1":
      raceIcon.gotoAndStop(2);
}
classes.Drawing.portrait(userPic,detailNode.attributes.ai1,2,0,0,4);
var _loc0_;
userPic.photo._yscale = _loc0_ = 50;
userPic.photo._xscale = _loc0_;
fldSenderName.text = classes.Lookup.buddyName(Number(detailNode.attributes.ai1));
classes.Drawing.portrait(teamPic1,detailNode.attributes.ti1,2,0,0,2,false,"teamavatars");
classes.Drawing.portrait(teamPic2,detailNode.attributes.ti2,2,0,0,2,false,"teamavatars");
teamName1 = _parent.lookupTeamName(detailNode.attributes.ti1);
teamName2 = _parent.lookupTeamName(detailNode.attributes.ti2);
var rArr = new Array();
var i = 1;
while(i <= 2)
{
   var j = 1;
   while(j <= 4)
   {
      var tItem = this["team" + i + "Slot" + j];
      if(Number(detailNode.childNodes[j - 1].attributes["ai" + i]))
      {
         tItem.userID = Number(detailNode.childNodes[j - 1].attributes["ai" + i]);
         tItem.userName = classes.Lookup.buddyName(tItem.userID);
         classes.Drawing.portrait(tItem,tItem.userID,2,0,0,4);
         tItem.btnBar.enabled = false;
         tItem.photo._yscale = _loc0_ = 25;
         tItem.photo._xscale = _loc0_;
         tItem.photo._x = 60;
         tItem.photo.onDragOver = _loc0_ = function()
         {
            this.clr = new Color(this);
            this.clr.setTransform({rb:0,gb:100,bb:100});
         };
         tItem.photo.onRollOver = _loc0_;
         tItem.photo.onDragOut = _loc0_ = function()
         {
            this.clr.setTransform({rb:0,gb:0,bb:0});
         };
         tItem.photo.onRollOut = _loc0_;
         tItem.photo.onRelease = function()
         {
            classes.Control.focusViewer(this._parent.userID);
            this.clr.setTransform({rb:0,gb:0,bb:0});
         };
         tItem.accountCarID = detailNode.childNodes[j - 1].attributes["aci" + i];
         tItem.createEmptyMovieClip("car",tItem.getNextHighestDepth());
         tItem.car._x = -40;
         tItem.car._y = -9;
         tItem.photo.onDragOver = _loc0_ = function()
         {
            this.clr = new Color(this);
            this.clr.setTransform({rb:0,gb:100,bb:100});
         };
         tItem.car.onRollOver = _loc0_;
         tItem.photo.onDragOut = _loc0_ = function()
         {
            this.clr.setTransform({rb:0,gb:0,bb:0});
         };
         tItem.car.onRollOut = _loc0_;
         tItem.car.onRelease = function()
         {
            classes.Control.focusViewer(this._parent.userID,this._parent.accountCarID);
            this.clr.setTransform({rb:0,gb:0,bb:0});
         };
         rArr.push(tItem.accountCarID);
         classes.Lookup.addCallback("getRacersCars",this,CB_getRacersCars,tItem.accountCarID);
         if(i == 2)
         {
            tItem.photo._x = -84;
            tItem.car._x *= -1;
            tItem.tf = tItem.fld.getTextFormat();
            tItem.tf.align = "left";
            tItem.fld.setTextFormat(tItem.tf);
         }
         else
         {
            tItem.car._xscale *= -1;
         }
      }
      else
      {
         tItem._visible = false;
      }
      j++;
   }
   i++;
}
_root.getRacersCars(rArr.toString());
nav1.onRelease = function()
{
   gotoAndStop("reveal");
   play();
};
nav2.onRelease = function()
{
};
nav3.onRelease = function()
{
   classes.TeamRivalsChallengePanel.removeChallenge(detailNode.attributes.id);
   _root.teamRivalsResponse(detailNode.attributes.id,0);
   gotoAndStop("reveal");
   play();
};
nav4.onRelease = function()
{
   _root.teamRivalsResponse(detailNode.attributes.id,1);
   gotoAndStop("hide");
   play();
};
