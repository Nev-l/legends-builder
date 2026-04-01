class classes.mc.UCMyListings extends MovieClip
{
   var scrollPane;
   var btnPost;
   var listXML;
   var listArr;
   var msg;
   static var _mc;
   function UCMyListings()
   {
      super();
      classes.mc.UCMyListings._mc = this;
      this.scrollPane = this.attachMovie("scrollingPaneGroup","scrollPane",1,{_x:12,_y:51});
      this.scrollPane.scrollerObj.setSizeMask(406,204);
      this.scrollPane.scrollerObj.resetScroller(204,396);
      this.btnPost.onRelease = function()
      {
         classes.Control.dialogContainer("dialogSellUsedCarContent");
      };
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
         this.msg = "You have not posted any cars for sale.";
      }
      var _loc5_ = 0;
      var _loc6_ = undefined;
      var _loc7_ = undefined;
      while(_loc5_ < _loc4_)
      {
         _loc6_ = this.listXML.firstChild.childNodes[_loc5_].attributes;
         _loc7_ = this.scrollPane.contentMC.attachMovie("ucMyListingsItem","item" + _loc5_,_loc5_);
         _loc7_.id = Number(_loc6_.i);
         _loc7_.s = Number(_loc6_.s);
         _loc7_.status = classes.mc.UCListing.listingStatusName(Number(_loc6_.s));
         if(_loc7_.status == "Listed")
         {
            _loc7_.tfmt = new TextFormat();
            _loc7_.tfmt.color = 52224;
            _loc7_.fldStatus.setTextFormat(_loc7_.tfmt);
         }
         _loc7_.price = "$" + classes.NumFuncs.commaFormat(Number(_loc6_.p));
         _loc7_.carengine = classes.Lookup.carModelName(Number(_loc6_.ci)) + " (" + classes.Lookup.engineType(Number(_loc6_.eti)) + ")";
         _loc7_.expiry = _loc6_.ex;
         _loc7_.priv = _loc6_.pv != 1 ? "No" : "Yes";
         if(_loc6_.t == 1)
         {
            if(Number(_loc6_.pt) > 0)
            {
               _loc7_.trade = _loc6_.pt;
               _loc7_.tfmtTrade = new TextFormat();
               _loc7_.tfmtTrade.color = 16777011;
               _loc7_.fldTrade.setTextFormat(_loc7_.tfmtTrade);
            }
            else
            {
               _loc7_.trade = "Yes";
            }
         }
         else
         {
            _loc7_.trade = "No";
         }
         _loc7_._y = _loc5_ * _loc3_;
         this.listArr.push(_loc7_);
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
