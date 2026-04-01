function CB_getRacersCars(c)
{
   trace("CB_getRacersCars...");
   var _loc2_ = new XML(c);
   var _loc3_ = 1;
   var _loc4_ = undefined;
   var _loc5_ = undefined;
   while(_loc3_ <= 2)
   {
      _loc4_ = carPair["car" + _loc3_];
      _loc5_ = 72;
      if(_loc4_.accountCarID && _loc4_.accountCarID == _loc2_.firstChild.attributes.i)
      {
         classes.Drawing.carView(_loc4_,_loc2_,_loc5_);
         _loc4_.isDrawn = true;
         break;
      }
      _loc3_ += 1;
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
var txml = _global.chatObj.challengeXML;
var matchNum = 2;
var matchTot = 2;
var i = 1;
while(i <= 4)
{
   if(Number(txml.firstChild.childNodes[i - 1].attributes.ai1))
   {
      matchTot = i;
      trace(i + " :: " + txml.firstChild.childNodes[i - 1].attributes.ai1 + "==" + _global.chatObj.raceObj.r1Obj.id);
      if(txml.firstChild.childNodes[i - 1].attributes.ai1 == _global.chatObj.raceObj.r1Obj.id)
      {
         matchNum = i;
      }
   }
   i++;
}
var rArr = new Array();
var i = 1;
while(i <= 2)
{
   var ttid = Number(txml.firstChild.attributes["ti" + i]);
   this["team" + i + "Name"] = classes.Lookup.getTeamNode(ttid).attributes.n;
   this["userPic" + i].teamID = ttid;
   this["SCbadge" + i].scDial.ticks.txt = txml.firstChild.attributes["sc" + i];
   classes.Drawing.portrait(this["userPic" + i].holder,ttid,2,0,0,1,false,"teamavatars");
   var tItem = this["team" + i + "Pos1"];
   var tid = Number(txml.firstChild.childNodes[matchNum - 1].attributes["ai" + i]);
   if(tid)
   {
      tItem.accountID = tid;
      tItem.userName = classes.Lookup.buddyName(tid);
      classes.Drawing.portrait(tItem.pic,tid,2,0,0,2);
      var tcar = carPair["car" + i];
      tcar.num = matchNum;
      tcar.accountCarID = Number(txml.firstChild.childNodes[matchNum - 1].attributes["aci" + i]);
      tcar.clr = new Color(this["team" + i + "Car" + matchNum]);
      tcar.clr.setTransform({rb:-180,gb:-180,bb:-180});
      tcar.fadeUp = carFadeUp;
      trace("set car: " + tcar.accountCarID);
      classes.Lookup.addCallback("getRacersCars",this,CB_getRacersCars,tcar.accountCarID);
      rArr.push(tcar.accountCarID);
   }
   i++;
}
_root.getRacersCars(rArr);
