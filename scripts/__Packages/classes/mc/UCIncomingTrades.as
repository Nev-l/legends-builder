class classes.mc.UCIncomingTrades extends MovieClip
{
   var cid;
   var btnClose;
   var scrollPane;
   var listXML;
   var listArr;
   static var _mc;
   function UCIncomingTrades()
   {
      super();
      classes.mc.UCIncomingTrades._mc = this;
      if(!this.cid)
      {
         return undefined;
      }
      this.btnClose.onRelease = function()
      {
         classes.SectionClassified._mc.goMyListingsDetail(this._parent.cid,classes.SectionClassified.classifiedStatus);
      };
      this.scrollPane = this.attachMovie("scrollingPaneGroup","scrollPane",1,{_x:12,_y:51});
      this.scrollPane.scrollerObj.setSizeMask(228,339);
      this.scrollPane.scrollerObj.resetScroller(339,218);
      _root.pendingTrades(this.cid);
   }
   function buildList(d)
   {
      var _loc3_ = 14;
      this.listXML = new XML();
      this.listXML.ignoreWhite = true;
      this.listXML.parseXML(d);
      this.listArr = new Array();
      var _loc4_ = this.listXML.firstChild.childNodes.length;
      trace("incoming trades buildList");
      var _loc5_ = 0;
      var _loc6_ = undefined;
      var _loc7_ = undefined;
      var _loc8_ = undefined;
      while(_loc5_ < _loc4_)
      {
         trace(_loc5_);
         _loc6_ = this.listXML.firstChild.childNodes[_loc5_];
         _loc7_ = this.listXML.firstChild.childNodes[_loc5_].attributes;
         _loc8_ = this.scrollPane.contentMC.attachMovie("ucIncomingTradesItem","item" + _loc5_,_loc5_);
         _loc8_.id = _loc6_.childNodes[0].attributes.aci + "_" + _loc6_.childNodes[1].attributes.aci;
         _loc8_.from = _loc6_.childNodes[1].attributes.u;
         _loc8_.ocarengine = classes.Lookup.carModelName(Number(_loc6_.childNodes[1].attributes.ci)) + " (" + classes.Lookup.engineType(Number(_loc6_.childNodes[1].attributes.eti)) + ")";
         _loc8_.status = _loc7_.s;
         _loc8_._y = _loc5_ * _loc3_;
         _loc8_.nodeData = _loc6_;
         this.listArr.push(_loc8_);
         _loc5_ += 1;
      }
      this.scrollPane.scrollerObj.refreshScroller();
   }
}
