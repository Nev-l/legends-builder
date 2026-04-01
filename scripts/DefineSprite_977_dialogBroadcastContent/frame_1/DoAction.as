stop();
var msg = _parent.msg.split("\r\n").join("\r");
var tfw = 377;
var tfh = 278;
this.createTextField("tf",this.getNextHighestDepth(),23,92,tfw,tfh);
tf.html = true;
tf.wordWrap = true;
tf.multiline = true;
tf.styleSheet = _global.n2CSS;
tf.htmlText = msg;
var scroller = new controls.ScrollBar(tf,289,null,81);
btnOK.onRelease = function()
{
   if(!_root.displaySpecialEventDialogIfNecessary())
   {
      _root.displayTestDriveExpiredIfNecessary();
   }
   _parent.closeMe();
};
