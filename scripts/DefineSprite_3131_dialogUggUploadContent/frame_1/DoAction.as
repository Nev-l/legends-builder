stop();
var secsAt1000Kb = Math.round(_parent.filesize * 8 / 1000000);
var secsAt128Kb = Math.round(_parent.filesize * 8 / 128000);
msg = "You are about to upload " + _parent.uggCount + " image" + (_parent.uggCount <= 1 ? "" : "s") + ".  With a total file size of " + Math.round(_parent.filesize / 1000) + " KB, this process can take " + secsAt1000Kb + " to " + secsAt128Kb + " seconds (or longer, depending on your connection).  Please do not interfere with the upload process.\r\rNote: Points will be deducted when the process is complete.  ABSOLUTELY NO REFUNDS so take care that your images are not offensive.";
msg += "\r\rClick \'Upload\' to continue.";
btnOK.btnLabel.text = "Upload";
btnOK.onRelease = function()
{
   if(Number(classes.GlobalData.attr.p) >= _parent.uggCost)
   {
      _root.uggUpload(_global.shopPartsMC.selectedCarXML.firstChild.attributes.i,_global.shopUGGGroup.path148,_global.shopUGGGroup.path149,_global.shopUGGGroup.path150,_global.shopUGGGroup.path151);
      nextFrame();
   }
   else
   {
      msg = "Sorry, you do not have enough Points in your account.  This purchase requires:<br/><br/>";
      msg += _parent.uggCost + " Points<br/><br/>";
      msg += "To get Points, check out the Shop at <a href=\"asfunction:_root.openURL,http://www.nittolegends.com/1320Shop_points.aspx\">http://www.nittolegends.com/1320Shop_points.aspx</a>";
      gotoAndStop("done");
   }
};
btnCancel.btnLabel.text = "Cancel";
btnCancel.onRelease = function()
{
   _parent.closeMe();
};
