viewThumb._visible = true;
var codeErrorMsg = "Your car does not have a racer number applied to it.  Please number your car by copying the given number into the box below.";
fldCode.restrict = "0-9 A-Z a-z";
fldCode.onChanged = function()
{
   code.toUpperCase();
   viewThumb.racerNum.txt = code;
};
nav2.onRelease = function()
{
   if(!code.length)
   {
      _root.displayAlert("warning","Car Not Ready",codeErrorMsg);
   }
   else
   {
      gotoAndStop("bracket");
      play();
   }
};
nav3.onRelease = function()
{
   gotoAndStop("car");
   play();
};
trace("maiURL: " + _global.mainURL);
codeContainer.loadMovie(_global.mainURL + "generateTournamentKey.aspx?aid=" + classes.GlobalData.id + "&rid=" + Math.floor(Math.random() * 1000000));
