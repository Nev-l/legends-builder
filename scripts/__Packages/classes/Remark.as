class classes.Remark extends MovieClip
{
   var aryRemarks;
   var bgMC;
   var bodyMC;
   var userTxtFormat;
   var txtFormat;
   var uID;
   var _remarkWidth = 307;
   var _padding = 15;
   function Remark()
   {
      super();
      this.aryRemarks = new Array();
      this.bgMC = this.createEmptyMovieClip("bgMC",this.getNextHighestDepth());
      this.bodyMC = this.createEmptyMovieClip("bodyMC",this.getNextHighestDepth());
      this.bodyMC._x = this._padding;
      this.bodyMC._y = this._padding;
      this.userTxtFormat = new TextFormat();
      this.userTxtFormat.color = 16777215;
      this.userTxtFormat.font = "Arial";
      this.userTxtFormat.size = 9;
      this.txtFormat = new TextFormat();
      this.txtFormat.color = 0;
      this.txtFormat.font = "Arial";
      this.txtFormat.size = 12;
   }
   function drawAllRemark(rXML, showCtl)
   {
      if(!showCtl)
      {
         this._remarkWidth = 280;
      }
      trace("drawAllRemark: " + rXML.toString());
      this.bodyMC.clear();
      for(var _loc4_ in this.bodyMC)
      {
         this.bodyMC[_loc4_].removeMovieClip();
      }
      this.aryRemarks.length = 0;
      var _loc5_ = rXML.firstChild.childNodes.length;
      this._parent._parent.remarksHomeTop.txtCount = "You have " + _loc5_ + " remark" + (_loc5_ != 1 ? "s" : "");
      var _loc6_ = 0;
      while(_loc6_ < _loc5_)
      {
         this.addRemark(rXML.firstChild.childNodes[_loc6_].attributes.rid,rXML.firstChild.childNodes[_loc6_].attributes.fid,rXML.firstChild.childNodes[_loc6_].attributes.fu,rXML.firstChild.childNodes[_loc6_].attributes.dc,rXML.firstChild.childNodes[_loc6_].attributes.nd,rXML.firstChild.childNodes[_loc6_].firstChild.nodeValue,showCtl);
         _loc6_ += 1;
      }
      this._parent._parent.scrollerObj.refreshScroller();
   }
   function addRemark(rid, fid, fu, dc, nd, rmk, showCtl)
   {
      var _loc9_ = this.bodyMC.createEmptyMovieClip("remarkItem" + this.aryRemarks.length,this.bodyMC.getNextHighestDepth());
      var _loc10_ = undefined;
      if(this.aryRemarks.length > 0)
      {
         _loc10_ = this.bodyMC._height;
         this.bodyMC.beginFill(9145227,100);
         this.bodyMC.moveTo(0,_loc10_ + this._padding);
         this.bodyMC.lineTo(this._remarkWidth - this._padding * 3,_loc10_ + this._padding);
         this.bodyMC.lineTo(this._remarkWidth - this._padding * 3,_loc10_ + this._padding + 1);
         this.bodyMC.lineTo(0,_loc10_ + this._padding + 1);
         this.bodyMC.lineTo(0,_loc10_ + this._padding);
         this.bodyMC.endFill();
         _loc9_._y = this.bodyMC._height + this._padding;
      }
      else
      {
         _loc9_._y = 0;
      }
      _loc9_.createEmptyMovieClip("avatar",_loc9_.getNextHighestDepth());
      var _loc11_ = new classes.ImageIO();
      classes.Drawing.portrait(_loc9_.avatar,fid,2,0,0,2);
      _loc9_.avatar._xscale = _loc9_.avatar._yscale = 55;
      _loc9_.avatar.uID = fid;
      _loc9_.avatar.onRelease = function()
      {
         classes.Control.focusViewer(this.uID);
      };
      _loc9_.createTextField("uname",_loc9_.getNextHighestDepth(),0,42,60,10);
      _loc9_.uname.text = fu;
      _loc9_.uname.autoSize = true;
      _loc9_.uname.antiAliasType = "advanced";
      _loc9_.uname.setTextFormat(this.userTxtFormat);
      _loc9_.createTextField("rmkTxt",_loc9_.getNextHighestDepth(),70,0,this._remarkWidth - this._padding * 3 - 70,10);
      _loc9_.rmkTxt.multiline = true;
      _loc9_.rmkTxt.wordWrap = true;
      _loc9_.rmkTxt.autoSize = true;
      _loc9_.rmkTxt.text = dc + "\n" + rmk;
      _loc9_.rmkTxt.setTextFormat(this.txtFormat);
      if(showCtl)
      {
         _loc9_.attachMovie("RemarkControl","remarkCtl",_loc9_.getNextHighestDepth());
         _loc9_.remarkCtl.rid = rid;
         _loc9_.remarkCtl._y = _loc9_._height;
         _loc9_.remarkCtl.nonDelete = nd;
      }
      this.aryRemarks.push(_loc9_);
      this.drawRoundedRectangle(this.bgMC);
   }
   function drawRoundedRectangle(mv)
   {
      mv.clear();
      classes.Drawing.rect(mv,this._remarkWidth,this.bodyMC._height + this._padding * 2,16777215,30,0,0,10);
      classes.Drawing.rect(mv,this._remarkWidth,10,16711680,0,0,this.bodyMC._height + this._padding * 2);
   }
}
