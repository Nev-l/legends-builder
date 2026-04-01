function onContinue()
{
   switch(ci)
   {
      case 148:
         title.text = "Custom HOOD PANEL Graphics";
         lblMessage.htmlText = "Click \'Browse\' to search your computer for the image you would like to use as a HOOD PANEL graphic. Note, there is no charge until you decide to buy. <br/><br/>Accepted Formats: jpg, gif, png <br/>Suggested size: 200x200 pixels (width x height)";
         break;
      case 149:
         title.text = "Custom SIDE PANEL Graphics";
         lblMessage.htmlText = "Click \'Browse\' to search your computer for the image you would like to use as a SIDE PANEL graphic. Note, there is no charge until you decide to buy. <br/><br/>Accepted Formats: jpg, gif, png <br/>Suggested size: 650x187 pixels (width x height)";
         break;
      case 150:
         title.text = "Custom FRONT PANEL Graphics";
         lblMessage.htmlText = "Click \'Browse\' to search your computer for the image you would like to use as a FRONT PANEL graphic. Note, there is no charge until you decide to buy. <br/><br/>Accepted Formats: jpg, gif, png <br/>Suggested size: 300x160 pixels (width x height)";
         break;
      case 151:
         title.text = "Custom BACK PANEL Graphics";
         lblMessage.htmlText = "Click \'Browse\' to search your computer for the image you would like to use as a BACK PANEL graphic. Note, there is no charge until you decide to buy. <br/><br/>Accepted Formats: jpg, gif, png <br/>Suggested size: 350x150 pixels (width x height)";
         break;
      default:
         _parent.closeMe();
   }
   btnOK.btnLabel.text = "Browse";
   btnOK.onRelease = function()
   {
      onBrowse();
   };
}
function onBrowse()
{
   trace("onBrowse: " + ci);
   classes.Lookup.addCallback("fileBrowse",this,onFileSelect,"customGraphics" + ci);
   _root.fileBrowse("customGraphics" + ci);
}
function onFileSelect(tobj)
{
   trace("onFileSelect");
   if(tobj.path && tobj.path.length)
   {
      _global.shopUGGGroup.setLocalPath(ci,tobj.path,tobj.filesize,tobj.previewPath);
      _parent.closeMe();
   }
}
