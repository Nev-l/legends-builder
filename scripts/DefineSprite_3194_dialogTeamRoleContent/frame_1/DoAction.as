stop();
var filterByType = _parent.filterByType;
var targetID = 0;
var targetUname = "";
var targetRole;
var selectAction = function(uid)
{
   targetID = uid;
   gotoAndStop("pickRole");
   play();
};
avatar.removeMovieClip();
membersXML = _global.teamXML.firstChild.firstChild;
var tAttr;
var vSpace = 24;
if(!filterByType)
{
   filterByType = 4;
}
var count = 0;
var i = 0;
while(i < membersXML.childNodes.length)
{
   tAttr = membersXML.childNodes[i].attributes;
   if(tAttr.i != classes.GlobalData.id)
   {
      if(tAttr.tr == filterByType)
      {
         classes.Drawing.userListItem(list,"user" + tAttr.i,tAttr.i,tAttr.un,0,count * vSpace,selectAction);
         count++;
      }
   }
   i++;
}
if(!count)
{
   classes.Control.dialogAlert("None Found","There are no members of this type to select from.");
}
else
{
   classes.Drawing.portrait(teamAvatar,classes.GlobalData.attr.ti,2,0,0,2,false,"teamavatars");
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
}
btnCancel.btnLabel.text = "Cancel";
btnCancel.onRelease = function()
{
   _parent.closeMe();
};
