function showKing(kingGrfx)
{
   kingGrfx._alpha = 0;
   kingGrfx._visible = true;
   kingGrfx.swapDepths(10);
   kingGrfx.onEnterFrame = function()
   {
      if(this._alpha < 100)
      {
         this._alpha += 7;
      }
      else
      {
         this._alpha = 100;
         showWinnerInfo();
         delete this.onEnterFrame;
      }
   };
}
function showWinnerInfo()
{
   var _loc4_ = undefined;
   var _loc5_ = undefined;
   var _loc6_ = undefined;
   if(_parent.kingObj.id)
   {
      _loc4_ = new XML(_global.chatObj.queueXML.firstChild.childNodes[0]);
      _loc5_ = _parent.lookupTeamID(_parent.kingObj.id);
      _loc6_ = {_x:28,_y:174,uID:_parent.kingObj.id,uName:_parent.kingObj.username,tID:_loc5_,tName:_parent.lookupTeamName(_loc5_),uCred:_parent.kingObj.sc};
      this.attachMovie("userInfo","user1Info",1,_loc6_);
      this.createEmptyMovieClip("car1",2);
      classes.Drawing.carView(car1,_parent.kingObj.carXML,68);
      car1._x = 386;
      car1._y = 114;
   }
}
