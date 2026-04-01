car1 = screenEventShake.raceScreen.carAni1;
car2 = screenEventShake.raceScreen.carAni2;
carHolder1 = car1.carAni_shift.carAni_Nitrous.carAni_speedJitter.carHolder;
carHolder2 = car2.carAni_shift.carAni_Nitrous.carAni_speedJitter.carHolder;
renderCar(1,0);
renderCar(2,0);
carHolder1._visible = false;
carHolder2._visible = false;
car1._visible = false;
car2._visible = false;
var renderStr = "race";
if(isSpectator)
{
   renderStr = "spectate";
}
classes.Drawing.carView(carHolder1,tCarXML1,100,renderStr);
if(tCarXML2.firstChild)
{
   classes.Drawing.carView(carHolder2,tCarXML2,100,renderStr);
}
var rObj = _global.chatObj.raceObj.r1Obj;
var user1Obj = {_x:10,_y:250,_visible:false,uID:rObj.id,uName:rObj.un,tID:rObj.ti,tName:rObj.tn,uCred:rObj.sc};
var rObj = _global.chatObj.raceObj.r2Obj;
var user2Obj = {_x:400,_y:250,_visible:false,isReversed:true,uID:rObj.id,uName:rObj.un,tID:rObj.ti,tName:rObj.tn,uCred:rObj.sc};
this.attachMovie("userInfo","user1Info",21,user1Obj);
user1Info.cacheAsBitmap = true;
this.attachMovie("userInfoRev","user2Info",22,user2Obj);
user2Info.cacheAsBitmap = true;
if(isSpectator)
{
   user1Info._visible = true;
   user2Info._visible = true;
}
