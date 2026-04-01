stop();
pw = "";
if(_parent.targetClassifiedID)
{
   listingID1 = _parent.targetClassifiedID;
}
fldListingID1.restrict = "0-9";
fldListingID2.restrict = "0-9";
fldPW.restrict = classes.Lookup.keyboardRestrictChars;
fldListingID1.tabIndex = 1;
fldListingID2.tabIndex = 2;
fldPW.tabIndex = 3;
btnOK.onRelease = function()
{
   if(listingID1 && listingID2)
   {
      nextFrame();
   }
};
btnCancel.btnLabel.text = "Cancel";
btnCancel.onRelease = function()
{
   this._parent._parent.closeMe();
};
