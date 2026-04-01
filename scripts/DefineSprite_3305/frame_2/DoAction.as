classes.Drawing.applyMainShad(bg);
fldRemark.restrict = classes.Lookup.keyboardRestrictChars;
fldRemark.onSetFocus = function()
{
   if(remark == remarkInstr)
   {
      remark = "";
   }
};
btnOK.onRelease = function()
{
   if(!remark.length || remark == remarkInstr)
   {
      txtError = "Please enter a remark before submitting.";
      gotoAndStop("error");
      play();
   }
   else
   {
      gotoAndStop("send");
      play();
   }
};
btnCancel.onRelease = function()
{
   this._parent._parent.closeMe();
};
