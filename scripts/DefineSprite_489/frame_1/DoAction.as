bntParts.onRelease = function()
{
   this._parent._parent.navToParts();
};
btnSell.onRelease = function()
{
   cid = _parent.accountCarID;
   var _loc2_ = {carXML:_parent.carXML};
   trace("btnSell: " + cid);
   _loc2_.cb = function(tObj)
   {
      trace("dialogBtnOK callback");
      var _loc4_ = tObj.s;
      var _loc5_ = tObj.b;
      if(_loc4_ == 1)
      {
         classes.GlobalData.updateInfo("m",_loc5_);
         classes.GlobalData.removeCar(_global.sellCarObj.cid);
         _root.displayAlert("funds","Sell Car Succeeded","You have successfully sold your car.");
         _global.myGarageMC.refreshGarage();
      }
      else if(_loc4_ == -50)
      {
         _root.displayAlert("triangle","Account Locked","Sorry, you left a race that is still in progress. Your account is temporarily locked until the race is finished.  This may take moment.");
      }
      else if(_loc4_ == -1)
      {
         _root.displayAlert("warning","Can Not Sell Your Only Car","Sorry, but you can not sell the only car in your garage.  You\'ll have to get more garage space by moving up to a nicer neighborhood.  Becoming a member will also increase your garage space.");
      }
      else if(_loc4_ == -2)
      {
         _root.displayAlert("warning","Can Not Sell This Car","You can not sell this car because you currently are not the owner.");
      }
      else if(_loc4_ == -4)
      {
         _root.displayAlert("warning","Test Drive Car","You can not sell this car because it is a test drive car.");
      }
      else
      {
         _root.displayAlert("warning","Sell Car Failed","Sorry, for some reason your attempt to sell your car could not go through. Please try again later.");
      }
      _global.sellCarObj.cid = 0;
   };
   classes.Control.dialogContainer("dialogCarValueContent",{tObj:_loc2_});
};
