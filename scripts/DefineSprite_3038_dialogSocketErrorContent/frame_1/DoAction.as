btnTroubleshootSocket.onRelease = function()
{
   _root.openURL("http://www.nittolegends.com/support_connection.aspx");
};
btnCancel.btnLabel.text = "Close";
btnCancel.onRelease = function()
{
   _parent.closeMe();
};
