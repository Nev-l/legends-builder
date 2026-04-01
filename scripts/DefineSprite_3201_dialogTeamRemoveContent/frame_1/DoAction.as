stop();
var targetID = 0;
var targetUname = "";
var selectAction = function(uid)
{
   for(var _loc2_ in list)
   {
      if(list[_loc2_].userID == uid)
      {
         list.pointer._visible = true;
         list.pointer._y = list[_loc2_]._y;
         btnOK._visible = true;
      }
   }
   targetID = uid;
};
membersXML = _global.teamXML.firstChild.firstChild;
var tAttr;
var count = 0;
var vSpace = 24;
var i = 0;
while(i < membersXML.childNodes.length)
{
   tAttr = membersXML.childNodes[i].attributes;
   if(tAttr.i != classes.GlobalData.id && tAttr.tr > 1)
   {
      classes.Drawing.userListItem(list,"user" + tAttr.i,tAttr.i,tAttr.un,0,count * vSpace,selectAction);
      count++;
   }
   i++;
}
if(!count)
{
   classes.Control.dialogAlert("No Members to Remove","There are no members on your team who can currently be removed.");
}
else
{
   list.attachMovie("pointerL","pointer",list.getNextHighestDepth(),{_x:126,_visible:false});
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
   list._y = maskT;
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
   classes.Drawing.portrait(teamAvatar,classes.GlobalData.attr.ti,2,0,0,2,false,"teamavatars");
}
btnOK._visible = false;
btnOK.btnLabel.text = "OK";
btnOK.onRelease = function()
{
   nextFrame();
};
btnCancel.btnLabel.text = "Cancel";
btnCancel.onRelease = function()
{
   _parent.closeMe();
};
