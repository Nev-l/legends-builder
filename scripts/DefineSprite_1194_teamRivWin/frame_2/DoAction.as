function CB_getRacersCars(d)
{
   var _loc3_ = new XML(d);
   var _loc4_ = 1;
   var _loc5_ = undefined;
   var _loc6_ = undefined;
   while(_loc4_ <= 4)
   {
      _loc5_ = this["car" + _loc4_];
      _loc6_ = 75 - _loc4_ * 15;
      if(_loc5_.accountCarID && _loc5_.accountCarID == _loc3_.firstChild.attributes.i && !_loc5_.isDrawn)
      {
         classes.Drawing.carView(_loc5_,_loc3_,_loc6_);
         trace("CB... (" + _loc5_.num + ") " + _loc5_.accountCarID + " == " + _loc3_.firstChild.attributes.i);
         _loc5_.isDrawn = true;
      }
      _loc4_ += 1;
   }
   var _loc7_ = true;
   _loc4_ = 1;
   while(_loc4_ <= 4)
   {
      if(this["car" + _loc4_].accountID && !this["car" + _loc4_].isDrawn)
      {
         _loc7_ = false;
      }
      _loc4_ += 1;
   }
   trace("isAllDrawn: " + _loc7_);
   if(_loc7_)
   {
      cont();
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
function cont()
{
   play();
}
stop();
var i;
if(winnerID == txml.firstChild.attributes.ti1)
{
   i = 1;
}
else if(winnerID == txml.firstChild.attributes.ti2)
{
   i = 2;
}
var getCarsArr = new Array();
if(i)
{
   var j = 1;
   while(j <= 4)
   {
      var tid = Number(txml.firstChild.childNodes[j - 1].attributes["ai" + i]);
      if(tid)
      {
         var tcar = this["car" + j];
         tcar.num = j;
         tcar.accountCarID = Number(txml.firstChild.childNodes[j - 1].attributes["aci" + i]);
         tcar.clr = new Color(this["car" + j]);
         tcar.clr.setTransform({rb:-180,gb:-180,bb:-180});
         tcar.fadeUp = carFadeUp;
         trace("set car: " + tcar.accountCarID);
         getCarsArr.push(tcar.accountCarID);
         classes.Lookup.addCallback("getRacersCars",this,CB_getRacersCars,tcar.accountCarID);
         txtNames += classes.Lookup.buddyName(tid) + "\r";
         txtStats2 += validRT(Number(rxml.firstChild.childNodes[j - 1].attributes["rt" + i])) + "\r";
         txtStats3 += validET(Number(rxml.firstChild.childNodes[j - 1].attributes["et" + i])) + "\r";
         txtStats4 += validTS(Number(rxml.firstChild.childNodes[j - 1].attributes["ts" + i])) + "\r";
         var tbt = Number(rxml.firstChild.childNodes[j - 1].attributes["bt" + i]);
         txtStatsBT += "(" + Number(rxml.firstChild.childNodes[j - 1].attributes["bt" + i]) + ")\r";
      }
      j++;
   }
   _root.getRacersCars(getCarsArr);
}
if(txml.firstChild.attributes.h == 0)
{
   txtStats1 = txtStats2;
   txtStats2 = txtStats3;
   txtStats3 = txtStatsBT;
   txtCol1 = "RT";
   txtCol2 = "ET";
   txtCol3 = "(DI)";
   txtCol4 = "TS";
}
else
{
   txtCol2 = "RT";
   txtCol3 = "ET";
   txtCol4 = "TS";
}
