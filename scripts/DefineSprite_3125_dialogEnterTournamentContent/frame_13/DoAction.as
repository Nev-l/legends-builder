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
      txtError = "You must enter the racer number.";
   }
   else
   {
      txtError = "";
      if(_parent.b == 1)
      {
         gotoAndStop("bracket");
         play();
      }
      else
      {
         checkDone();
      }
   }
};
codeContainer.loadMovie(_global.mainURL + "generateTournamentKey.aspx?aid=" + classes.GlobalData.id + "&t=h&rid=" + Math.floor(Math.random() * 1000000));
