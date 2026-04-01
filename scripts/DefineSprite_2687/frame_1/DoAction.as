function clearHelp()
{
   helpBubble.removeMovieClip();
   panel.helpBubble.removeMovieClip();
}
function oppCarsCB(txml)
{
   oppCarsXML = new XML();
   oppCarsXML = txml;
   var _loc2_ = 0;
   while(_loc2_ < oppCarsXML.firstChild.childNodes.length)
   {
      if(oppCarsXML.firstChild.childNodes[_loc2_].attributes.i == oppCarsXML.firstChild.attributes.dc)
      {
         selOppCarXML = oppCarsXML.firstChild.childNodes[_loc2_];
         selOppCar = Number(selOppCarXML.attributes.i);
      }
      _loc2_ += 1;
   }
   if(!selOppCar)
   {
      selOppCarXML = oppCarsXML.firstChild.childNodes[0];
      selOppCar = Number(selOppCarXML.attributes.i);
   }
   gotoAndStop("oppCar");
   play();
}
function loadPlate(pid, seq)
{
   classes.Drawing.plateView(plate,pid,seq,45,true,true);
}
function goOppUser(oid, oname)
{
   oppID = oid;
   oppName = oname;
   gotoAndStop("oppCarLU");
   play();
}
function drawUserList()
{
   var _loc2_ = _global.chatObj.userListXML;
   var _loc3_ = undefined;
   var _loc4_ = undefined;
   var _loc5_ = undefined;
   for(var _loc6_ in userList)
   {
      _loc3_ = false;
      if(_loc6_.indexOf("item") > -1)
      {
         _loc5_ = 0;
         while(_loc5_ < _loc2_.firstChild.childNodes.length)
         {
            if(userList[_loc6_].userID == _loc2_.firstChild.childNodes[_loc5_].attributes.i)
            {
               _loc3_ = true;
               break;
            }
            _loc5_ += 1;
         }
      }
      if(!_loc3_)
      {
         userList[_loc6_].removeMovieClip();
      }
   }
   var _loc7_ = undefined;
   var _loc8_ = undefined;
   var _loc9_ = new Array();
   var _loc10_ = undefined;
   _loc5_ = 0;
   while(_loc5_ < _loc2_.firstChild.childNodes.length)
   {
      if(_loc2_.firstChild.childNodes[_loc5_].attributes.i != classes.GlobalData.id && userList["item" + _loc2_.firstChild.childNodes[_loc5_].attributes.i] == undefined)
      {
         userList.attachMovie("userListItem","item" + _loc2_.firstChild.childNodes[_loc5_].attributes.i,userList.getNextHighestDepth(),{userID:_loc2_.firstChild.childNodes[_loc5_].attributes.i,userName:_loc2_.firstChild.childNodes[_loc5_].attributes.un});
         classes.Drawing.portrait(userList["item" + _loc2_.firstChild.childNodes[_loc5_].attributes.i],_loc2_.firstChild.childNodes[_loc5_].attributes.i,2,0,0,4);
         _loc7_ = userList["item" + _loc2_.firstChild.childNodes[_loc5_].attributes.i].photo;
         _loc7_._xscale = 25;
         _loc7_._yscale = 25;
         _loc7_._x = 100;
         userList["item" + _loc2_.firstChild.childNodes[_loc5_].attributes.i].onRelease = function()
         {
            goOppUser(this.userID,this.userName);
         };
      }
      _loc5_ += 1;
   }
   orderUserList();
}
function orderUserList()
{
   var _loc2_ = _global.chatObj.userListXML;
   userList.clear();
   var _loc3_ = 0;
   var _loc4_ = 24;
   var _loc5_ = new Array();
   var _loc6_ = 0;
   while(_loc6_ < _loc2_.firstChild.childNodes.length)
   {
      if(_loc2_.firstChild.childNodes[_loc6_].attributes.i != classes.GlobalData.id)
      {
         _loc5_.push({id:_loc2_.firstChild.childNodes[_loc6_].attributes.i,teamID:_loc2_.firstChild.childNodes[_loc6_].attributes.ti,uName:_loc2_.firstChild.childNodes[_loc6_].attributes.un});
      }
      _loc6_ = _loc6_ + 1;
   }
   _loc5_.sortOn(["uName"]);
   var _loc7_ = _loc3_;
   var _loc8_ = undefined;
   _loc6_ = 0;
   while(_loc6_ < _loc5_.length)
   {
      userList["item" + _loc5_[_loc6_].id]._y = _loc7_;
      _loc7_ += _loc4_;
      userList["item" + _loc5_[_loc6_].id].swapDepths(0);
      userList["item" + _loc5_[_loc6_].id].swapDepths(_loc6_ + 1);
      _loc6_ = _loc6_ + 1;
   }
   with(userList)
   {
      moveTo(0,0);
      beginFill(0,0);
      lineTo(10,0);
      lineTo(10,_height + _loc3_);
      endFill();
   }
   userList.maskH = listMask._height;
   userList.maskT = listMask._y;
   userList._y = maskT;
   if(userList._height > listMask._height)
   {
      userList.onEnterFrame = function()
      {
         if(listMask.hitTest(_root._xmouse,_root._ymouse,false))
         {
            this.frac = (this._parent._ymouse - this.maskT) / this.maskH;
            this._y = this.maskT - (this._height - this.maskH) * this.frac;
         }
      };
   }
   else
   {
      delete userList.onEnterFrame;
      userList._y = maskT;
   }
}
