function CB_getRacersCars(c)
{
   trace("CB_getRacersCars...");
   trace(this);
   var _loc3_ = new XML(c);
   var _loc4_ = 1;
   var _loc5_ = undefined;
   var _loc6_ = undefined;
   var _loc7_ = undefined;
   while(_loc4_ <= 2)
   {
      _loc5_ = 1;
      while(_loc5_ <= 4)
      {
         _loc6_ = this["team" + _loc4_ + "Car" + _loc5_];
         _loc7_ = 75 - _loc5_ * 15;
         if(_loc6_.accountCarID && _loc6_.accountCarID == _loc3_.firstChild.attributes.i && !_loc6_.isDrawn)
         {
            classes.Drawing.carView(_loc6_,_loc3_,_loc7_);
            trace("CB... (" + _loc6_.num + ") " + _loc6_.accountCarID + " == " + _loc3_.firstChild.attributes.i);
            trace(_loc6_);
            _loc6_.isDrawn = true;
         }
         _loc5_ += 1;
      }
      _loc4_ += 1;
   }
}
function carFadeUp()
{
   this.fadeStep = 30;
   this.onEnterFrame = function()
   {
      this.newFade = this.clr.getTransform().rb + this.fadeStep;
      if(this.newFade < 0)
      {
         this.clr.setTransform({rb:this.newFade,gb:this.newFade,bb:this.newFade});
      }
      else
      {
         this.clr.setTransform({rb:0,gb:0,bb:0});
         delete this.onEnterFrame;
      }
   };
}
_global.chatObj.raceObj = _global.chatObj.newRaceObj;
var txml = _global.chatObj.challengeXML;
var rArr = new Array();
var i = 1;
while(i <= 2)
{
   var ttid = Number(txml.firstChild.attributes["ti" + i]);
   this["team" + i + "Name"] = classes.Lookup.getTeamNode(ttid).attributes.n;
   this["userPic" + i].teamID = ttid;
   this["SCbadge" + i].scDial.ticks.txt = txml.firstChild.attributes["sc" + i];
   var j = 1;
   while(j <= 4)
   {
      var tItem = this["team" + i + "Pos" + j];
      var tid = Number(txml.firstChild.childNodes[j - 1].attributes["ai" + i]);
      if(tid)
      {
         tItem.num = j;
         tItem.accountID = tid;
         tItem.userName = classes.Lookup.buddyName(tid);
         classes.Drawing.portrait(tItem.pic,tid,2,0,0,2);
         if(txml.firstChild.childNodes[j - 1].childNodes.attributes["commited" + i] == 1)
         {
            statusBulb.gotoAndStop(2);
         }
         var tcar = this["team" + i + "Car" + j];
         tcar.num = j;
         tcar.accountCarID = Number(txml.firstChild.childNodes[j - 1].attributes["aci" + i]);
         tcar.clr = new Color(this["team" + i + "Car" + j]);
         tcar.clr.setTransform({rb:-180,gb:-180,bb:-180});
         tcar.fadeUp = carFadeUp;
         if(i == 2)
         {
            tcar._xscale *= -1;
         }
         trace("set car: " + tcar.accountCarID);
         classes.Lookup.addCallback("getRacersCars",this,CB_getRacersCars,tcar.accountCarID);
         rArr.push(tcar.accountCarID);
      }
      j++;
   }
   i++;
}
_root.getRacersCars(rArr);
