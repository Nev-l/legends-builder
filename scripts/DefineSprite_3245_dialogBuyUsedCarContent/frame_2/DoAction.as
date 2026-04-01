stop();
privateGroup.fld.type = "dynamic";
delete btnCancel.onRelease;
delete btnOK.onRelease;
classes.Control.currentDialog = this;
_root.buyFromClassified(classifiedID,privateGroup.pw);
