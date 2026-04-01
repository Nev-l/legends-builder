stop();
var msg = _parent.msg.split("\r\n").join("\r");
var title = _parent.title;
alertIconMC.gotoAndStop(_parent.iconName);
var tfw = 377;
var tfh = 278;
var tf = this.createTextField("tf",this.getNextHighestDepth(),23,92,tfw,tfh);
tf.embedFonts = true;
tf.wordWrap = true;
tf.multiline = true;
tf.text = msg;
tfmt = new TextFormat();
tfmt.font = "Arial";
tfmt.size = 11;
tf.setTextFormat(tfmt);
var scroller = new controls.ScrollBar(tf,289,null,81);
btnOK.onRelease = function()
{
   _parent.closeMe();
};
