viewThumb._visible = true;
txtDetail = "";
if(payType == "p" && _parent.pp > 0)
{
   txtDetail += _parent.pp + " will be deducted from your Points. Remember, once you enter the tournament strip, you may not leave or you will be disqualified.\r\rClick Continue to enter the tournament.";
}
else if(payType == "m" && _parent.mp > 0)
{
   txtDetail += "$" + _parent.mp + " will be deducted from your funds. Remember, once you enter the tournament strip, you may not leave or you will be disqualified.\r\rClick Continue to enter the tournament.";
}
else
{
   txtDetail += "You are about to enter this tournament. Remember, once you enter the tournament strip, you may not leave or you will be disqualified.\r\rClick Continue to enter the tournament.";
}
nav2.btnLabel.text = "Continue";
nav2.onRelease = function()
{
   gotoAndStop("send");
   play();
};
