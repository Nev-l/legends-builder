function showWinnerInfo()
{
   _root.debug += "showWinnerInfo: " + _parent.winnerID;
   var _loc5_ = -1;
   if(_parent.winnerID == _global.chatObj.raceObj.r1Obj.id)
   {
      _loc5_ = 0;
   }
   else if(_parent.winnerID == _global.chatObj.raceObj.r2Obj.id)
   {
      _loc5_ = 1;
   }
   var _loc6_ = undefined;
   var _loc7_ = undefined;
   var _loc8_ = undefined;
   if(_loc5_ > -1)
   {
      _loc6_ = new XML(_global.chatObj.twoRacersCarsXML.firstChild.childNodes[_loc5_]);
      if(_parent.winnerID == _global.chatObj.raceObj.r1Obj.id)
      {
         _loc7_ = _global.chatObj.raceObj.r1Obj;
      }
      else if(_parent.winnerID == rObj.r2id)
      {
         _loc7_ = _global.chatObj.raceObj.r2Obj;
      }
      _loc8_ = {_x:28,_y:166,uID:_loc7_.id,uName:_loc7_.un,tID:_loc7_.ti,tName:_loc7_.tn,uCred:_loc7_.sc};
      this.attachMovie("userInfo","user1Info",1,_loc8_);
      this.createEmptyMovieClip("car1",2);
      classes.Drawing.carView(car1,_loc6_,68);
      car1._x = 386;
      car1._y = 114;
   }
}
