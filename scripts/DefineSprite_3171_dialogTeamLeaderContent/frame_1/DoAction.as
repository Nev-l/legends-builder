stop();
var targetID = 0;
var targetUname = "";
classes.Drawing.portrait(teamAvatar,classes.GlobalData.attr.ti,2,0,0,2,false,"teamavatars");
var selectAction = function(uid)
{
   targetID = uid;
   gotoAndStop("change");
   play();
};
membersXML = _global.teamXML.firstChild.firstChild;
var tAttr;
var count = 0;
var vSpace = 24;
var i = 0;
while(i < membersXML.childNodes.length)
{
   tAttr = membersXML.childNodes[i].attributes;
   if(tAttr.i != classes.GlobalData.id)
   {
      classes.Drawing.userListItem(list,"user" + tAttr.i,tAttr.i,tAttr.un,0,count * vSpace,selectAction);
      count++;
   }
   i++;
}
with(list)
{
   clear();
   beginFill(0,0);
   lineTo(100,0);
   lineTo(100,list._height + 10);
   lineTo(0,list._height + 10);
   lineTo(0,0);
   endFill();
}
list.maskH = listMask._height;
list.maskT = listMask._y;
list._y = list.maskT;
if(list._height > listMask._height)
{
   list.onEnterFrame = function()
   {
      if(listMask.hitTest(_root._xmouse,_root._ymouse,false))
      {
         this.frac = (this._parent._ymouse - this.maskT) / this.maskH;
         this._y = this.maskT - (this._height - this.maskH) * this.frac;
      }
   };
}
btnCancel.btnLabel.text = "Cancel";
btnCancel.onRelease = function()
{
   _parent.closeMe();
};
