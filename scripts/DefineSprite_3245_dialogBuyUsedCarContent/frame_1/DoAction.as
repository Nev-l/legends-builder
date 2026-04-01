stop();
var carXML = _parent.carXML;
var classifiedID = _parent.classifiedID;
var price = _parent.price;
var impound = _parent.impound;
var isPrivate = _parent.isPrivate;
fld.restrict = classes.Lookup.keyboardRestrictChars;
alertIcon.gotoAndStop("key");
if(!isPrivate)
{
   privateGroup._visible = false;
}
classes.Drawing.plateView(plate,carXML.firstChild.attributes.pi,carXML.firstChild.attributes.pn,25,true);
classes.Drawing.carLogo(logo,carXML.firstChild.attributes.ci);
classes.Drawing.carView(carThumb,carXML,35,"front");
btnOK.btnLabel.text = "Buy";
btnOK.onRelease = function()
{
   nextFrame();
};
btnCancel.btnLabel.text = "Cancel";
btnCancel.onRelease = function()
{
   this._parent._parent.closeMe();
};
