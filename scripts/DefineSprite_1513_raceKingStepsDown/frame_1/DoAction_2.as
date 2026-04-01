var exKingCarXML = new XML(_parent.kingObj.carXML.toString());
var tks = _parent.kingObj.ks;
if(!tks)
{
   tks = 0;
   txtStreak = "x1";
}
else
{
   txtStreak = "x" + tks;
}
var kObj = _parent.kingObj;
var kTID = _parent.lookupTeamID(kObj.id);
var winnerObj = {_x:28,_y:174,uID:kObj.id,uName:kObj.username,tID:kTID,tName:_parent.lookupTeamName(kTID),uCred:kObj.sc};
this.attachMovie("userInfo","user1Info",1,winnerObj);
this.createEmptyMovieClip("car1",2);
classes.Drawing.carView(car1,exKingCarXML,62);
car1._x = 396;
car1._y = 129;
var clrMtx = new Array();
clrMtx = clrMtx.concat([0.5,0,0,0,0]);
clrMtx = clrMtx.concat([0,0.5,0,0,0]);
clrMtx = clrMtx.concat([0,0,0.5,0,0]);
clrMtx = clrMtx.concat([0,0,0,1,0]);
var fltr = new flash.filters.ColorMatrixFilter(clrMtx);
car1.filters = new Array(fltr);
_parent.updateQueue(kObj.id,"",true);
_parent.kingObj = new Object();
_parent.showKingInfo();
