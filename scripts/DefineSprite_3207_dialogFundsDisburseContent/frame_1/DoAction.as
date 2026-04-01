var targetID = 0;
fldAmount.restrict = "0-9";
classes.Drawing.portrait(teamAvatar,classes.GlobalData.attr.ti,2,0,0,2,false,"teamavatars");
var selectAction = function(uid)
{
   trace("SELECTED: " + uid);
   for(var _loc2_ in list)
   {
      if(list[_loc2_].userID == uid)
      {
         list.pointer._visible = true;
         list.pointer._y = list[_loc2_]._y;
      }
   }
   targetID = uid;
};
var membersXML = _global.teamXML.firstChild.firstChild;
var tAttr;
var count = 0;
var vSpace = 24;
var i = 0;
while(i < membersXML.childNodes.length)
{
   tAttr = membersXML.childNodes[i].attributes;
   classes.Drawing.userListItem(list,"user" + tAttr.i,tAttr.i,tAttr.un,0,count * vSpace,selectAction);
   count++;
   i++;
}
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
teamFundsDisplay.txt = "$" + classes.NumFuncs.commaFormat(_parent.teamFunds);
remainingFundsDisplay.txt = "$" + classes.NumFuncs.commaFormat(_parent.teamFunds);
fldAmount.onChanged = function()
{
   var _loc2_ = Number(_parent.teamFunds) - Number(amount);
   trace(_loc2_);
   trace(_parent.teamFunds + ", " + amount);
   remainingFundsDisplay.txt = "$" + classes.NumFuncs.commaFormat(Math.max(0,_loc2_));
};
btnOK.btnLabel.text = "OK";
btnOK.onRelease = function()
{
   if(!Number(amount))
   {
      classes.Control.dialogAlert("No Amount Specified","Please enter an amount of funds to disburse.");
   }
   else if(!targetID)
   {
      classes.Control.dialogAlert("No Recipient Selected","Please select a team member to receive the funds.");
   }
   else if(Number(amount) > Number(_global.teamXML.firstChild.firstChild.attributes.tf))
   {
      classes.Control.dialogAlert("Insufficient Funds","The team does not have enough funds for this disbursement.\r\rDisbursement amount: $" + amount + "\rTeam funds: $" + _global.teamXML.firstChild.firstChild.attributes.tf);
   }
   else
   {
      _root.teamDisperse(Number(amount),targetID);
      _parent.closeMe();
   }
};
btnCancel.btnLabel.text = "Cancel";
btnCancel.onRelease = function()
{
   _parent.closeMe();
};
