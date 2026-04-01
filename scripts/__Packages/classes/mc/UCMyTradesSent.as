class classes.mc.UCMyTradesSent extends MovieClip
{
   var scrollPane;
   var btnPropose;
   var listXML;
   var listArr;
   var msg;
   static var _mc;
   function UCMyTradesSent()
   {
      super();
      classes.mc.UCMyTradesSent._mc = this;
      this.scrollPane = this.attachMovie("scrollingPaneGroup","scrollPane",1,{_x:12,_y:51});
      this.scrollPane.scrollerObj.setSizeMask(406,106);
      this.scrollPane.scrollerObj.resetScroller(106,396);
      this.btnPropose.onRelease = function()
      {
         classes.Control.dialogContainer("dialogOfferTradeContent");
      };
   }
   static function tradeStatusName(sid)
   {
      switch(sid)
      {
         case 1:
            return "Pending";
         case 2:
            return "Accepted";
         case 3:
            return "Declined";
         case 4:
            return "Sold";
         case 5:
            return "Traded";
         case 6:
            return "Expired";
         case 7:
            return "Retracted";
         default:
            return "";
      }
   }
   function buildList(d)
   {
      var _loc3_ = 14;
      this.listXML = new XML();
      this.listXML.ignoreWhite = true;
      this.listXML.parseXML(d);
      this.listArr = new Array();
      var _loc4_ = this.listXML.firstChild.childNodes.length;
      if(!_loc4_)
      {
         this.msg = "You have not sent any trade offers.";
      }
      var _loc5_ = 0;
      var _loc6_ = undefined;
      var _loc7_ = undefined;
      var _loc8_ = undefined;
      while(_loc5_ < _loc4_)
      {
         trace(_loc5_);
         _loc6_ = this.listXML.firstChild.childNodes[_loc5_];
         _loc7_ = this.listXML.firstChild.childNodes[_loc5_].attributes;
         _loc8_ = this.scrollPane.contentMC.attachMovie("ucMyTradesSentItem","item" + _loc5_,_loc5_);
         _loc8_.id = _loc6_.childNodes[0].attributes.aci + "_" + _loc6_.childNodes[1].attributes.aci;
         _loc8_.to = _loc6_.childNodes[1].attributes.u;
         _loc8_.mcarengine = classes.Lookup.carModelName(Number(_loc6_.childNodes[0].attributes.ci)) + " (" + classes.Lookup.engineType(Number(_loc6_.childNodes[0].attributes.eti)) + ")";
         _loc8_.ocarengine = classes.Lookup.carModelName(Number(_loc6_.childNodes[1].attributes.ci)) + " (" + classes.Lookup.engineType(Number(_loc6_.childNodes[1].attributes.eti)) + ")";
         _loc8_.status = classes.mc.UCMyTradesSent.tradeStatusName(Number(_loc7_.s));
         if(_loc8_.status == "Pending")
         {
            _loc8_.tfmt = new TextFormat();
            _loc8_.tfmt.color = 52224;
            _loc8_.fldStatus.setTextFormat(_loc8_.tfmt);
         }
         _loc8_._y = _loc5_ * _loc3_;
         _loc8_.nodeData = _loc6_;
         this.listArr.push(_loc8_);
         _loc5_ += 1;
      }
      this.scrollPane.scrollerObj.refreshScroller();
   }
   function setAllSelect(id)
   {
      var _loc3_ = 0;
      while(_loc3_ < this.listArr.length)
      {
         this.listArr[_loc3_].setSelect(id);
         _loc3_ += 1;
      }
   }
}
