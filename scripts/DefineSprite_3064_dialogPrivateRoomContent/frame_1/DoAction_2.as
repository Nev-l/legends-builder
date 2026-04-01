var roomName = _parent.roomName;
var typeID = _parent.typeID;
var roomID = _parent.roomID;
var asInvisible = _parent.asInvisible;
var isPrivate = 0;
var isMember = 0;
var setting;
fldAttemptPW.restrict = classes.Lookup.keyboardRestrictChars;
attemptPW = "";
incorrectPW._visible = false;
btnOK.btnLabel.text = "Enter";
btnOK.onRelease = function()
{
   onOK();
};
btnCancel.btnLabel.text = "Cancel";
btnCancel.onRelease = function()
{
   _parent.closeMe();
};
