stop();
if(_parent.txtMsg != undefined)
{
   txtMsg = _parent.txtMsg;
}
if(_parent.txtHead != undefined)
{
   txtHead = _parent.txtHead;
}
dialInGroup.txtDialIn = "";
if(_parent.isBracket)
{
   dialInGroup.fldDialIn.restrict = "0-9.";
}
else
{
   dialInGroup._visible = false;
}
this.attachMovie("dialogLights","dialogLights",this.getNextHighestDepth(),{_x:-70,_y:4});
