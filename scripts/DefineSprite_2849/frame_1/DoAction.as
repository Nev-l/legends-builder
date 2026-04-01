function setDetail(o, t, entryReq, descr)
{
   _global.clearTimeout(contST);
   detailObj = _global.sectionTrackMC.detailObj = o;
   detailObj.tstr = t;
   detailObj.entryReq = entryReq;
   detailObj.descr = descr;
   gotoAndStop("detail");
   play();
}
function setupDetailLeft()
{
   var _loc2_ = 1;
   if(detailObj.s == 0)
   {
      _loc2_ = 3;
   }
   else if(detailObj.s == 2)
   {
      _loc2_ = 2;
   }
   detailLeft.gotoAndStop(_loc2_);
   detailLeft.hwidth = 132;
   var _loc3_;
   if(Number(detailObj.d))
   {
      _loc3_ = new Date(Number(detailObj.d) * 1000);
      detailLeft.fldDay.text = classes.NumFuncs.dayName(_loc3_.getUTCDay()).toUpperCase();
      detailLeft.fldDate.text = _loc3_.getUTCDate();
      detailLeft.fldTime.text = detailObj.tstr;
      detailLeft.onEnterFrame = function()
      {
         this.fldDay._xscale = 100 * this.hwidth / this.fldDay._width;
         this.fldTime._xscale = 100 * this.hwidth / this.fldTime._width;
         delete this.onEnterFrame;
      };
   }
   else
   {
      detailLeft.fldTime.text = " ANY TIME ";
      detailLeft.onEnterFrame = function()
      {
         this.fldTime._xscale = 100 * this.hwidth / this.fldTime._width;
         this.fldTime._yscale = this.fldTime._xscale;
         delete this.onEnterFrame;
      };
   }
}
function extraDetail()
{
   btnEntryReq._visible = true;
   if(detailObj.ct == "m")
   {
      costGroup.txtCost = "$" + detailObj.c;
   }
   else if(detailObj.ct == "p")
   {
      costGroup.txtCost = detailObj.c;
      costGroup.nextFrame();
   }
   else if(detailObj.ct == "f")
   {
      costGroup.txtCost = "FREE";
   }
}
function setLiveTimeout()
{
   trace("setLiveTimeout");
   var _loc3_ = undefined;
   if(Number(detailObj.d))
   {
      _loc3_ = Number(detailObj.d) * 1000 - (Number(new Date()) + classes.GlobalData.serverTimeOffset);
      trace("timeLeft: " + _loc3_);
      if(_loc3_ > 0)
      {
         if(_loc3_ <= classes.NumFuncs.maxInterval)
         {
            detailObj.liveSI = _global.setTimeout(this,"goDetailOpen",_loc3_);
         }
      }
      else
      {
         goDetailOpen();
      }
   }
   else
   {
      goDetailOpen();
   }
}
function setCountdownTime()
{
   var _loc1_;
   var _loc2_;
   var _loc3_;
   if(Number(detailObj.de))
   {
      _loc1_ = Number(detailObj.de) * 1000 - (Number(new Date()) + classes.GlobalData.serverTimeOffset);
      if(_loc1_ > 0)
      {
         _loc2_ = classes.NumFuncs.get2Mins(Math.floor(_loc1_ / 60000)) + ":";
         _loc2_ += classes.NumFuncs.get2Mins(Math.floor(_loc1_ % 60000 / 1000)) + ".";
         _loc3_ = String(_loc1_ % 1000).substr(0,2);
         if(_loc3_.length == 1)
         {
            _loc3_ = "0" + _loc3_;
         }
         _loc2_ += _loc3_;
         countdownGroup.fldTimeLeft.text = _loc2_;
         _loc2_ = null;
      }
      else
      {
         countdownGroup.fldTimeLeft.text = "00:00.00";
      }
   }
   else
   {
      countdownGroup.fldTimeLeft.text = " OPEN";
   }
}
function goDetailOpen()
{
   trace("goDetailOpen");
   if(this)
   {
      trace("this == true");
      detailObj.s = 2;
      setupDetailLeft();
      gotoAndStop("detailOpen");
      play();
   }
}
function startTourney(id, tid, mp, pp, b, dobj)
{
   _global.sectionTrackMC.detailObj = dobj;
   _global.sectionTrackMC.tourneyID = id;
   _global.sectionTrackMC.tourneyScheduleID = tid;
   if(tid > 0 && tid <= 3)
   {
      _global.sectionTrackMC.gotoAndPlay("compTourney");
   }
   else
   {
      classes.Control.dialogContainer("dialogEnterTournamentContent",{id:id,mp:mp,pp:pp,b:b});
   }
}
