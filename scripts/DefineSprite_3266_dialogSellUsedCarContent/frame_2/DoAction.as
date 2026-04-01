stop();
fldPrice.restrict = "0-9";
fldPrice.tabIndex = 1;
classes.Drawing.plateView(plate,selCarXML.firstChild.attributes.pi,selCarXML.firstChild.attributes.pn,25,true);
classes.Drawing.carView(carThumb,selCarXML,17.5,"front");
var pw = "";
var tradesFlag = 0;
btnOK.btnLabel.text = "Continue";
btnOK.onRelease = function()
{
   if(privateGroup.isPrivate && privateGroup.pw.length < 5)
   {
      privateGroup.txtError = "error: password must be at least 5 characters long";
   }
   else
   {
      privateGroup.txtError = "";
      if(!price.length)
      {
         price = 0;
      }
      if(privateGroup.isPrivate)
      {
         pw = privateGroup.pw;
      }
      if(checkboxTrades.isChecked)
      {
         tradesFlag = 1;
      }
      nextFrame();
   }
};
